{
  pkgs,
  profile,
  backupFiles ? [".config/mimeapps.list.backup"],
  ...
}: let
  backupFilesString = pkgs.lib.strings.concatStringsSep " " backupFiles;
in
  pkgs.writeShellScriptBin "zcli" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    # --- Configuration ---
    PROJECT="zaneyos"   #ddubos or zaneyos
    PROFILE="${profile}"
    BACKUP_FILES_STR="${backupFilesString}"
    VERSION="1.0.1"
    FLAKE_NIX_PATH="$HOME/$PROJECT/flake.nix"

    read -r -a BACKUP_FILES <<< "$BACKUP_FILES_STR"

    # --- Helper Functions ---
    print_help() {
      echo "ZaneyOS CLI Utility -- version $VERSION"
      echo ""
      echo "Usage: zcli [command]"
      echo ""
      echo "Commands:"
      echo "  cleanup         - Clean up old system generations. Can specify a number to keep."
      echo "  diag            - Create a system diagnostic report."
      echo "                    (Filename: homedir/diag.txt)"
      echo "  list-gens       - List user and system generations."
      echo "  rebuild         - Rebuild the NixOS system configuration."
      echo "  trim            - Trim filesystems to improve SSD performance."
      echo "  update          - Update the flake and rebuild the system."
      echo "  update-host     - Auto set host and profile in flake.nix."
      echo "                    (Opt: zcli update-host [hostname] [profile])"
      echo ""
      echo "  help            - Show this help message."
    }

    handle_backups() {
      if [ ''${#BACKUP_FILES[@]} -eq 0 ]; then
        echo "No backup files configured to check."
        return
      fi

      echo "Checking for backup files to remove..."
      for file_path in "''${BACKUP_FILES[@]}"; do
        full_path="$HOME/$file_path"
        if [ -f "$full_path" ]; then
          echo "Removing stale backup file: $full_path"
          rm "$full_path"
        fi
      done
    }

    detect_gpu_profile() {
      local detected_profile=""
      local has_nvidia=false
      local has_intel=false
      local has_amd=false
      local has_vm=false

      if lspci &> /dev/null; then # Check if lspci is available
        if lspci | grep -qi 'vga\|3d'; then
          while read -r line; do
            if echo "$line" | grep -qi 'nvidia'; then
              has_nvidia=true
            elif echo "$line" | grep -qi 'amd'; then
              has_amd=true
            elif echo "$line" | grep -qi 'intel'; then
              has_intel=true
            elif echo "$line" | grep -qi 'virtio\|vmware'; then
              has_vm=true
            fi
          done < <(lspci | grep -i 'vga\|3d')

          if "$has_vm"; then
            detected_profile="vm"
          elif "$has_nvidia" && "$has_intel"; then
            detec0.1ted_profile="nvidia-laptop"
          elif "$has_nvidia"; then
            detected_profile="nvidia"
          elif "$has_amd"; then
            detected_profile="amd"
          elif "$has_intel"; then
            detected_profile="intel"
          fi
        fi
      else
        echo "Warning: lspci command not found. Cannot auto-detect GPU profile." >&2
      fi
      echo "$detected_profile" # Return the detected profile
    }

    # --- Main Logic ---
    if [ "$#" -eq 0 ]; then
      echo "Error: No command provided." >&2
      print_help
      exit 1
    fi

    case "$1" in
      cleanup)
        echo "Warning! This will remove old generations of your system."
        read -p "How many generations to keep (default: all)? " keep_count

        if [ -z "$keep_count" ]; then
          read -p "This will remove all but the current generation. Continue (y/N)? " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
            nh clean all -v
          else
            echo "Cleanup cancelled."
          fi
        else
          read -p "This will keep the last $keep_count generations. Continue (y/N)? " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
            nh clean all -k "$keep_count" -v
          else
            echo "Cleanup cancelled."
          fi
        fi

        LOG_DIR="$HOME/zcli-cleanup-logs"
        mkdir -p "$LOG_DIR"
        LOG_FILE="$LOG_DIR/zcli-cleanup-$(date +%Y-%m-%d_%H-%M-%S).log"
        echo "Cleaning up old log files..." >> "$LOG_FILE"
        find "$LOG_DIR" -type f -mtime +3 -name "*.log" -delete >> "$LOG_FILE" 2>&1
        echo "Cleanup process logged to $LOG_FILE"
        ;;
      diag)
        echo "Generating system diagnostic report..."
        inxi --full > "$HOME/diag.txt"
        echo "Diagnostic report saved to $HOME/diag.txt"
        ;;
            help)
        print_help
        ;;
            list-gens)
        echo "--- User Generations ---"
        nix-env --list-generations | cat || echo "Could not list user generations."
        echo ""
        echo "--- System Generations ---"
        nix profile history --profile /nix/var/nix/profiles/system | cat || echo "Could not list system generations."
        ;;
            rebuild)
        handle_backups
        echo "Starting NixOS rebuild for host: $(hostname)"
        if nh os switch --hostname "$PROFILE"; then
          echo "Rebuild finished successfully"
        else
          echo "Rebuild Failed" >&2
          exit 1
        fi
        ;;
            trim)
        echo "Running 'sudo fstrim -v /' may take a few minutes and impact system performance."
        read -p "Enter (y/Y) to run now or enter to exit (y/N): " -n 1 -r
        echo # move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          echo "Running fstrim..."
          sudo fstrim -v /
          echo "fstrim complete."
        else
          echo "Trim operation cancelled."
        fi
        ;;
            update)
        handle_backups
        echo "Updating flake and rebuilding system for host: $(hostname)"
        if nh os switch --hostname "$PROFILE" --update; then
          echo "Update and rebuild finished successfully"
        else
          echo "Update and rebuild Failed" >&2
          exit 1
        fi
        ;;
            update-host)
        target_hostname=""
        target_profile=""

        if [ "$#" -eq 3 ]; then # zcli update-host <hostname> <profile>
          target_hostname="$2"
          target_profile="$3"
        elif [ "$#" -eq 1 ]; then # zcli update-host (auto-detect)
          echo "Attempting to auto-detect hostname and GPU profile..."
          target_hostname=$(hostname)
          target_profile=$(detect_gpu_profile)

          if [ -z "$target_profile" ]; then
            echo "Error: Could not auto-detect a specific GPU profile. Please provide it manually." >&2
            echo "Usage: zcli update-host [hostname] [profile]" >&2
            exit 1
          fi
          echo "Auto-detected Hostname: $target_hostname"
          echo "Auto-detected Profile: $target_profile"
        else
          echo "Error: Invalid number of arguments for 'update-host'." >&2
          echo "Usage: zcli update-host [hostname] [profile]" >&2
          exit 1
        fi

        echo "Updating $FLAKE_NIX_PATH..."

        # Update host
        if sed -i "s/^[[:space:]]*host[[:space:]]*=[[:space:]]*\".*\"/    host = \"$target_hostname\"/" "$FLAKE_NIX_PATH"; then
          echo "Successfully updated host to: $target_hostname"
        else
          echo "Error: Failed to update host in $FLAKE_NIX_PATH" >&2
          exit 1
        fi

        # Update profile
        if sed -i "s/^[[:space:]]*profile[[:space:]]*=[[:space:]]*\".*\"/    profile = \"$target_profile\"/" "$FLAKE_NIX_PATH"; then
          echo "Successfully updated profile to: $target_profile"
        else
          echo "Error: Failed to update profile in $FLAKE_NIX_PATH" >&2
          exit 1
        fi

        echo "Flake.nix updated successfully!"
        ;;
      add-host)
        hostname=""
        profile_arg=""

        if [ "$#" -ge 2 ]; then
          hostname="$2"
        fi
        if [ "$#" -eq 3 ]; then
          profile_arg="$3"
        fi

        if [ -z "$hostname" ]; then
          read -p "Enter the new hostname: " hostname
        fi

        if [ -d "$HOME/$PROJECT/hosts/$hostname" ]; then
          echo "Error: Host '$hostname' already exists." >&2
          exit 1
        fi

        echo "Copying default host configuration..."
        cp -r "$HOME/$PROJECT/hosts/default" "$HOME/$PROJECT/hosts/$hostname"

        detected_profile=""
        if [[ -n "$profile_arg" && "$profile_arg" =~ ^(intel|amd|nvidia|nvidia-hybrid|vm)$ ]]; then
          detected_profile="$profile_arg"
        else
          echo "Detecting GPU profile..."
          detected_profile=$(detect_gpu_profile)
          echo "Detected GPU profile: $detected_profile"
          read -p "Is this correct? (y/n) " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Nn]$ ]]; then
            read -p "Enter the correct profile (intel, amd, nvidia, nvidia-hybrid, vm): " new_profile
            while [[ ! "$new_profile" =~ ^(intel|amd|nvidia|nvidia-hybrid|vm)$ ]]; do
              echo "Invalid profile. Please enter one of the following: intel, amd, nvidia, nvidia-hybrid, vm"
              read -p "Enter the correct profile: " new_profile
            done
            detected_profile=$new_profile
          fi
        fi

        echo "Setting profile to '$detected_profile'..."
        sed -i "s/profile = .*/profile = \"$detected_profile\";/" "$HOME/$PROJECT/hosts/$hostname/default.nix"

        read -p "Generate new hardware.nix? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          echo "Generating hardware.nix..."
          sudo nixos-generate-config --show-hardware-config > "$HOME/$PROJECT/hosts/$hostname/hardware.nix"
          echo "hardware.nix generated."
        fi

        echo "Adding new host to git..."
        git -C "$HOME/$PROJECT" add .
        echo "hostname: $hostname added"
        ;;
      del-host)
        hostname=""
        if [ "$#" -eq 2 ]; then
          hostname="$2"
        else
          read -p "Enter the hostname to delete: " hostname
        fi

        if [ ! -d "$HOME/$PROJECT/hosts/$hostname" ]; then
          echo "Error: Host '$hostname' does not exist." >&2
          exit 1
        fi

        read -p "Are you sure you want to delete the host '$hostname'? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          echo "Deleting host '$hostname'..."
          rm -rf "$HOME/$PROJECT/hosts/$hostname"
          git -C "$HOME/$PROJECT" add .
          echo "hostname: $hostname removed"
        else
          echo "Deletion cancelled."
        fi
        ;;
      *)
        echo "Error: Invalid command '$1'" >&2
        print_help
        exit 1
        ;;
    esac
  ''
