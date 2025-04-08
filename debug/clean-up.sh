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

    # Delete the cleanup flag to ensure this script never runs again
    rm "/clean-up.txt"
fi
