#!/bin/bash

if [ ! -f "/debug_service_1.txt" ]; then
    # Download a GPG key generation template
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/debug/droplet-1/humungous-email-rsa4096-noexpiry.batch -o "/root/humungous-email-rsa4096-noexpiry.batch"
    dos2unix "/root/humungous-email-rsa4096-noexpiry.batch"

    # Generate public and private keys using the template
    gpg --batch --generate-key /root/humungous-email-rsa4096-noexpiry.batch

    # Export public and private keys
    gpg --armor --export admin@humungous.blog > "/root/humungous_public.asc"
    gpg --armor --export-secret-keys admin@humungous.blog > "/root/humungous_private.asc"

    # Safety checks just in case
    chown root:root "/root/humungous_public.asc"
    chown root:root "/root/humungous_private.asc"

    # Set permissions for both of these files to read-only before hosting them on the FTPS server
    chmod 644 "/root/humungous_public.asc"
    chmod 644 "/root/humungous_private.asc"

    # Create a protected directory where non-root users can only read contents from the directory
    mkdir "/home/humungous/protected/"
    chown root:root "/home/humungous/protected/"
    chmod 755 "/home/humungous/protected/"

    # Make both the public key and private key available for download from the FTPS server
    cp "/root/humungous_public.asc" "/home/humungous/protected/"
    cp "/root/humungous_private.asc" "/home/humungous/protected/"

    # Revert a permission for the private key after hosting it on the FTPS server
    chmod 600 "/root/humungous_private.asc"

    # Give the clients one hour to download public and private keys from the FTPS server before taking them offline
    sleep 3600
    mkdir "/root/archives/"
    chmod 600 "/home/humungous/protected/humungous_public.asc"
    chmod 600 "/home/humungous/protected/humungous_private.asc"
    mv "/home/humungous/protected/humungous_public.asc" "/root/archives/"
    mv "/home/humungous/protected/humungous_private.asc" "/root/archives/"

    # If the client uploaded the public key to a GitHub repo, download it to verify the authenticity of the public key
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/humungous_public.asc -o "/root/github-public.asc"
    dos2unix "/root/github-public.asc"

    # Get the name of the capture file actively used by tcpdump
    ls "/var/log/tcpdumpd/" > "/current_tcpdump_capture_file.txt"

    # Move onto the next section of the debug script
    systemctl start my-restart-script.service
    touch "/debug_service_1.txt"
elif [ ! -f "/debug_service_2.txt" ]; then
    # Now that we're moving onto the next section of the script, copy the previous tcpdump capture file to the root home directory
    cp "/var/log/tcpdumpd/$(cat /current_tcpdump_capture_file.txt)" "/root/"

    # Safety checks just in case
    chown root:root "/root/$(cat /current_tcpdump_capture_file.txt)"

    # Set a permission for the previous tcpdump capture file to read-only before hosting it on the FTPS server
    chmod 644 "/root/$(cat /current_tcpdump_capture_file.txt)"

    # Make the previous tcpdump capture file available for download from the FTPS server
    cp "/root/$(cat /current_tcpdump_capture_file.txt)" "/home/humungous/protected/"

    # Give both clients one hour to download the previous tcpdump capture file from the FTPS server before taking it offline
    sleep 3600
    chmod 600 "/home/humungous/protected/$(cat /current_tcpdump_capture_file.txt)"
    mv "/home/humungous/protected/$(cat /current_tcpdump_capture_file.txt)" "/root/archives/"

    # Since this is a temporary droplet only intended to generate GPG keys, power off the droplet and create a snapshot of it before destroying it
    systemctl start my-shutdown-script.service
    touch "/debug_service_2.txt"

    # Append the line to the sudoers file to allow the user to run the cleanup script as root later
    printf "\nhumungous ALL=NOPASSWD: /usr/sbin/clean-up.sh" >> "/etc/sudoers.d/99-restricted-user"

    # Create an empty file that allows the cleanup script to run when the user runs it as root later
    touch "/clean-up.txt"
fi