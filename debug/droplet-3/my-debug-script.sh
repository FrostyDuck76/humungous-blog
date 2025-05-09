#!/bin/bash

if [ ! -f "/debug_service_1.txt" ]; then
    # Get the name of the capture file actively used by tcpdump
    ls "/var/log/tcpdumpd/" > "/current_tcpdump_capture_file.txt"

    # Move onto the next section of the debug script
    touch "/debug_service_1.txt"
    systemctl start my-restart-script.service
elif [ ! -f "/debug_service_2.txt" ]; then
    # Now that we're moving onto the next section of the script, copy the previous tcpdump capture file to the root home directory
    cp "/var/log/tcpdumpd/$(cat /current_tcpdump_capture_file.txt)" "/root/"

    # Safety checks just in case
    chown root:root "/root/$(cat /current_tcpdump_capture_file.txt)"

    # Set a permission for the previous tcpdump capture file to read-only before hosting it on the FTPS server
    chmod 644 "/root/$(cat /current_tcpdump_capture_file.txt)"

    # Make the previous tcpdump capture file available for download from the FTPS server
    cp "/root/$(cat /current_tcpdump_capture_file.txt)" "/home/humungous/protected/"

    # Give both clients 15 minutes to download the previous tcpdump capture file from the FTPS server before taking it offline
    sleep 900
    chmod 600 "/home/humungous/protected/$(cat /current_tcpdump_capture_file.txt)"
    mv "/home/humungous/protected/$(cat /current_tcpdump_capture_file.txt)" "/root/archives/"

    # Check if the client uploaded an AWS credentials for 'AccessKeyManager' IAM user
    if [ -f "/home/humungous/.aws/credentials" ]; then
        systemctl stop vsftpd.service
        systemctl stop telnet.socket
        killall vsftpd
        killall in.telnetd
        mkdir "/home/humungous/aws_token_storage/"
        chown humungous:humungous "/home/humungous/aws_token_storage/"
        su - -c "/usr/local/bin/aws iam create-access-key --user-name S3Debugger" humungous > "/home/humungous/aws_token_storage/s3tcpdumpuploader_access_key.json"
        chown root:root "/home/humungous/.aws/credentials"
        chmod 600 "/home/humungous/.aws/credentials"
        mv "/home/humungous/.aws/credentials" "/root/retired_aws_credentials/accesskeymanager_credentials"
        echo "[default]" > "/home/humungous/.aws/credentials"
        echo "aws_access_key_id = $(cat "/home/humungous/aws_token_storage/s3tcpdumpuploader_access_key.json" | jq --raw-output '.AccessKey.AccessKeyId')" >> "/home/humungous/.aws/credentials"
        echo "aws_secret_access_key = $(cat "/home/humungous/aws_token_storage/s3tcpdumpuploader_access_key.json" | jq --raw-output '.AccessKey.SecretAccessKey')" >> "/home/humungous/.aws/credentials"
        chown root:root "/home/humungous/aws_token_storage/"
        mv "/home/humungous/aws_token_storage/" "/root/retired_aws_credentials/"
        chown root:root "/home/humungous/.aws/"
        chmod 755 "/home/humungous/.aws/"
        systemctl start telnet.socket
        systemctl start vsftpd.service
    fi

    # Append the line to the sudoers file to allow the user to run the cleanup script as root later
    printf "\nhumungous ALL=NOPASSWD: /usr/sbin/clean-up.sh" >> "/etc/sudoers.d/99-restricted-user"

    # Create an empty file that allows the cleanup script to run when the user runs it as root later
    touch "/clean-up.txt"

    # The second section of the debug script has finished!
    touch "/debug_service_2.txt"
fi
