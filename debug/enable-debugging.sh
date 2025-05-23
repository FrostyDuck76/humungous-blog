#!/bin/bash

if [ "$(hostname)" == "first-stage-droplet" ]; then
    # Download debugging scripts and services from the GitHub repo
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/droplet-1/my-debug-script.sh -o "/root/scripts/my-debug-script.sh"
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/droplet-1/my-debug-script.service -o "/root/services/my-debug-script.service"
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/clean-up.sh -o "/root/scripts/clean-up.sh"

    # Convert line-encodings from CRLF to LF
    dos2unix "/root/scripts/my-debug-script.sh"
    dos2unix "/root/services/my-debug-script.service"
    dos2unix "/root/scripts/clean-up.sh"

    # Move the downloaded debugging script to /usr/bin
    mv "/root/scripts/my-debug-script.sh" "/usr/bin/"

    # Move the cleanup script to /usr/sbin
    mv "/root/scripts/clean-up.sh" "/usr/sbin/"

    # Restore security context of scripts
    restorecon "/usr/bin/my-debug-script.sh"
    restorecon "/usr/sbin/clean-up.sh"

    # Make downloaded scripts executable
    chmod +x "/usr/bin/my-debug-script.sh"
    chmod 755 "/usr/sbin/clean-up.sh"

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
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/clean-up.sh -o "/root/scripts/clean-up.sh"

    # Convert line-encodings from CRLF to LF
    dos2unix "/root/scripts/my-debug-script.sh"
    dos2unix "/root/services/my-debug-script.service"
    dos2unix "/root/scripts/clean-up.sh"

    # Move the downloaded debugging script to /usr/bin
    mv "/root/scripts/my-debug-script.sh" "/usr/bin/"

    # Move the cleanup script to /usr/sbin
    mv "/root/scripts/clean-up.sh" "/usr/sbin/"

    # Restore security context of scripts
    restorecon "/usr/bin/my-debug-script.sh"
    restorecon "/usr/sbin/clean-up.sh"

    # Make downloaded scripts executable
    chmod +x "/usr/bin/my-debug-script.sh"
    chmod 755 "/usr/sbin/clean-up.sh"

    # Move the downloaded service to /etc/systemd/system
    mv "/root/services/my-debug-script.service" "/etc/systemd/system/"

    # Restore security context of the service
    restorecon "/etc/systemd/system/my-debug-script.service"

    # Append the line to the startup script that starts the debugging service
    printf "\nsystemctl start my-debug-script.service" >> "/usr/bin/my-startup-script.sh"
elif [ "$(hostname)" == "humungous-s3-tester" ]; then
    # Download debugging scripts and services from the GitHub repo
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/droplet-3/my-debug-script.sh -o "/root/scripts/my-debug-script.sh"
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/droplet-3/my-debug-script.service -o "/root/services/my-debug-script.service"
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/clean-up.sh -o "/root/scripts/clean-up.sh"

    # Convert line-encodings from CRLF to LF
    dos2unix "/root/scripts/my-debug-script.sh"
    dos2unix "/root/services/my-debug-script.service"
    dos2unix "/root/scripts/clean-up.sh"

    # Move the downloaded debugging script to /usr/bin
    mv "/root/scripts/my-debug-script.sh" "/usr/bin/"

    # Move the cleanup script to /usr/sbin
    mv "/root/scripts/clean-up.sh" "/usr/sbin/"

    # Restore security context of scripts
    restorecon "/usr/bin/my-debug-script.sh"
    restorecon "/usr/sbin/clean-up.sh"

    # Make downloaded scripts executable
    chmod +x "/usr/bin/my-debug-script.sh"
    chmod 755 "/usr/sbin/clean-up.sh"

    # Move the downloaded service to /etc/systemd/system
    mv "/root/services/my-debug-script.service" "/etc/systemd/system/"

    # Restore security context of the service
    restorecon "/etc/systemd/system/my-debug-script.service"

    # Append the line to the startup script that starts the debugging service
    printf "\nsystemctl start my-debug-script.service" >> "/usr/bin/my-startup-script.sh"
fi
