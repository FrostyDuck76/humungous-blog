#!/bin/bash

if [ "$(hostname)" == "first-stage-droplet" ]; then
    # Download debugging scripts and services from the GitHub repo
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/droplet-1/my-debug-script.sh -o "/root/scripts/my-debug-script.sh"
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/droplet-1/my-debug-script.service -o "/root/services/my-debug-script.service"

    # Convert line-encodings from CRLF to LF
    dos2unix "/root/scripts/my-debug-script.sh"
    dos2unix "/root/services/my-debug-script.service"

    # Move the downloaded script to /usr/bin
    mv "/root/scripts/my-debug-script.sh" "/usr/bin/"

    # Restore security context of the script
    restorecon "/usr/bin/my-debug-script.sh"

    # Make the downloaded script executable
    chmod +x "/usr/bin/my-debug-script.sh"

    # Move the downloaded service to /etc/systemd/system
    mv "/root/services/my-debug-script.service" "/etc/systemd/system/"

    # Restore security context of the service
    restorecon "/etc/systemd/system/my-debug-script.service"

    # Append the line to the startup script that starts the debugging service
    printf "\nsystemctl start my-debug-script.service" >> "/usr/bin/my-startup-script.sh"
elif [ "$(hostname)" == "humungous-blog" ]; then
    # Download debugging scripts and services from the GitHub repo
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/droplet-2/my-debug-script.sh -o "/root/scripts/my-debug-script.sh"
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/droplet-2/my-debug-script.service -o "/root/services/my-debug-script.service"

    # Convert line-encodings from CRLF to LF
    dos2unix "/root/scripts/my-debug-script.sh"
    dos2unix "/root/services/my-debug-script.service"

    # Move the downloaded script to /usr/bin
    mv "/root/scripts/my-debug-script.sh" "/usr/bin/"

    # Restore security context of the script
    restorecon "/usr/bin/my-debug-script.sh"

    # Make the downloaded script executable
    chmod +x "/usr/bin/my-debug-script.sh"

    # Move the downloaded service to /etc/systemd/system
    mv "/root/services/my-debug-script.service" "/etc/systemd/system/"

    # Restore security context of the service
    restorecon "/etc/systemd/system/my-debug-script.service"

    # Append the line to the startup script that starts the debugging service
    printf "\nsystemctl start my-debug-script.service" >> "/usr/bin/my-startup-script.sh"
fi
