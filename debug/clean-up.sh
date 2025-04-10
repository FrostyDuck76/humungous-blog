#!/bin/bash

if [ -f "/clean-up.txt" ]; then
    # Delete the empty 'protected' directory because it's not needed anymore
    rm -r "/home/humungous/protected/"

    # Move the debugging script to /root/archives
    mv "/usr/bin/my-debug-script.sh" "/root/archives/"

    # Move the debugging service to /root/archives
    mv "/etc/systemd/system/my-debug-script.service" "/root/archives/"

    # Delete the flags that prevent the debugging service from running again
    rm "/debug_service_1.txt"
    rm "/debug_service_2.txt"

    # Delete the file that refers to the first tcpdump capture file
    rm "/current_tcpdump_capture_file.txt"

    # Reload service configurations
    systemctl daemon-reload

    # Fetch the original startup script
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/scripts/my-startup-script.sh -o "/root/scripts/my-startup-script.sh"

    # Convert line-encodings from CRLF to LF for the downloaded script
    dos2unix "/root/scripts/my-startup-script.sh"

    # Move the current modified startup script to /root/archives
    mv "/usr/bin/my-startup-script.sh" "/root/archives/"

    # Move the downloaded script to /usr/bin
    mv "/root/scripts/my-startup-script.sh" "/usr/bin/"

    # Restore security context of the script
    restorecon "/usr/bin/my-startup-script.sh"

    # Make the downloaded script executable
    chmod +x "/usr/bin/my-startup-script.sh"

    # Reload service configurations again
    systemctl daemon-reload

    # Fetch the original sudoers file
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/configs/99-restricted-user -o "/root/configs/99-restricted-user"

    # Convert line-encodings from CRLF to LF for the downloaded sudoers file
    dos2unix "/root/configs/99-restricted-user"

    # Move the current modified sudoers file to /root/archives
    mv "/etc/sudoers.d/99-restricted-user" "/root/archives/"

    # Move the downloaded sudoers file to /etc/sudoers.d
    mv "/root/configs/99-restricted-user" "/etc/sudoers.d/"

    # Restore security context of the sudoers file
    restorecon "/etc/sudoers.d/99-restricted-user"

    # Set a permission for the sudoers file
    chmod 440 "/etc/sudoers.d/99-restricted-user"

    # Delete the cleanup flag to ensure this script never runs again
    rm "/clean-up.txt"
fi
