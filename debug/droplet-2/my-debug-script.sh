#!/bin/bash

if [ ! -f "/debug_service_1.txt" ]; then
    # Download the public key from the GitHub repo and import it
    curl -L https://raw.githubusercontent.com/FrostyDuck76/humungous-blog/refs/heads/main/humungous_public.asc -o "/root/humungous_public.asc"
    gpg --import "/root/humungous_public.asc"

    # Generate a user password while encrypting it with the newly imported public key and save it onto the disk
    (openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32) | gpg --trust-model always --encrypt --armor --recipient admin@humungous.blog --output "/root/user_password.gpg"

    # Safety checks just in case
    chown root:root "/root/humungous_public.asc"
    chown root:root "/root/user_password.gpg"

    # Set a permission for the encrypted user password file to read-only before hosting it on the FTPS server
    chmod 644 "/root/user_password.gpg"

    # Create a protected directory where non-root users can only read contents from the directory
    mkdir "/home/humungous/protected/"
    chown root:root "/home/humungous/protected/"
    chmod 755 "/home/humungous/protected/"

    # Make the encrypted user password file available for download from the FTPS server
    cp "/root/user_password.gpg" "/home/humungous/protected/"

    # Revert a permission for the encrypted user password file after hosting it on the FTPS server
    chmod 600 "/root/user_password.gpg"

    # Generate an encryption key for S3 objects
    openssl rand -out "/s3_encryption_key.bin" 32

    # Set a permission for the S3 encryption key to read-only before hosting it on the FTPS server
    chmod 644 "/s3_encryption_key.bin"

    # Make the S3 encryption key available for download from the FTPS server
    cp "/s3_encryption_key.bin" "/home/humungous/protected/"

    # Revert a permission for the S3 encryption key after hosting it on the FTPS server
    chmod 600 "/s3_encryption_key.bin"

    # Give the client one hour to download both the encrypted user password file and the S3 encryption key from the FTPS server before taking them offline
    sleep 3600
    mkdir "/root/archives/"
    chmod 600 "/home/humungous/protected/user_password.gpg"
    mv "/home/humungous/protected/user_password.gpg" "/root/archives/"
    chmod 600 "/home/humungous/protected/s3_encryption_key.bin"
    mv "/home/humungous/protected/s3_encryption_key.bin" "/root/archives/"

    # Generate a root password while encrypting it with the public key imported before and save it onto the disk
    (openssl rand -base64 64 | tr -dc 'a-zA-Z0-9' | head -c 64) | gpg --trust-model always --encrypt --armor --recipient admin@humungous.blog --output "/root/root_password.gpg"

    # Safety checks just in case
    chown root:root "/root/root_password.gpg"

    # Set a permission for the encrypted root password file to read-only before hosting it on the FTPS server
    chmod 644 "/root/root_password.gpg"

    # Make the encrypted root password file available for download from the FTPS server
    cp "/root/root_password.gpg" "/home/humungous/protected/"

    # Revert a permission for the encrypted root password file after hosting it on the FTPS server
    chmod 600 "/root/root_password.gpg"

    # Give the other client one hour to download the encrypted root password file from the FTPS server before taking them offline
    sleep 3600
    chmod 600 "/home/humungous/protected/root_password.gpg"
    mv "/home/humungous/protected/root_password.gpg" "/root/archives/"

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

    # Give both clients one hour to download the previous tcpdump capture file from the FTPS server before taking it offline
    sleep 3600
    chmod 600 "/home/humungous/protected/$(cat /current_tcpdump_capture_file.txt)"
    mv "/home/humungous/protected/$(cat /current_tcpdump_capture_file.txt)" "/root/archives/"

    # Check if the client already uploaded the private key to the new droplet, otherwise give them one hour to upload it here
    if [ ! -f "/home/humungous/humungous_private.asc" ]; then
        sleep 3600
        # Check if the client uploaded the private key within one hour after taking the tcpdump capture file offline
        if [ -f "/home/humungous/humungous_private.asc" ]; then
            chown root:root "/home/humungous/humungous_private.asc"
            chmod 600 "/home/humungous/humungous_private.asc"
            mv "/home/humungous/humungous_private.asc" "/root/archives/"
            gpg --import "/root/archives/humungous_private.asc"
            echo "humungous:$(gpg --decrypt /root/user_password.gpg)" | chpasswd
            echo "root:$(gpg --decrypt /root/root_password.gpg)" | chpasswd
        fi

        # Check if the client uploaded an API token for three different services
        if [ -f "/home/humungous/digitalocean.ini" ]; then
            chown root:root "/home/humungous/digitalocean.ini"
            chmod 600 "/home/humungous/digitalocean.ini"
            mv "/home/humungous/digitalocean.ini" "/etc/letsencrypt/"
        fi
        if [ -f "/home/humungous/cloudflare.ini" ]; then
            chown root:root "/home/humungous/cloudflare.ini"
            chmod 600 "/home/humungous/cloudflare.ini"
            mv "/home/humungous/cloudflare.ini" "/etc/letsencrypt/"
        fi
        if [ -f "/home/humungous/route53.ini" ]; then
            chown root:root "/home/humungous/route53.ini"
            chmod 600 "/home/humungous/route53.ini"
            mv "/home/humungous/route53.ini" "/etc/letsencrypt/"
        fi

        # Check if the client uploaded an AWS credentials for 'AccessKeyManager' IAM user
        if [ -f "/home/humungous/.aws/credentials" ]; then
            systemctl stop vsftpd.service
            systemctl stop telnet.socket
            killall vsftpd
            killall in.telnetd
            mkdir "/home/humungous/aws_token_storage/"
            chown humungous:humungous "/home/humungous/aws_token_storage/"
            su - -c "/usr/local/bin/aws iam create-access-key --user-name S3TcpdumpUploader" humungous > "/home/humungous/aws_token_storage/s3tcpdumpuploader_access_key.json"
            chown root:root "/home/humungous/.aws/credentials"
            chmod 600 "/home/humungous/.aws/credentials"
            mv "/home/humungous/.aws/credentials" "/root/retired_aws_credentials/accesskeymanager_credentials"
            echo "[default]" > "/home/humungous/.aws/credentials"
            echo "aws_access_key_id = $(cat /home/humungous/aws_token_storage/s3tcpdumpuploader_access_key.json | jq --raw-output '.AccessKey.AccessKeyId')" >> "/home/humungous/.aws/credentials"
            echo "aws_secret_access_key = $(cat /home/humungous/aws_token_storage/s3tcpdumpuploader_access_key.json | jq --raw-output '.AccessKey.SecretAccessKey')" >> "/home/humungous/.aws/credentials"
            chown root:root "/home/humungous/aws_token_storage/"
            mv "/home/humungous/aws_token_storage/" "/root/retired_aws_credentials/"
            chown root:root "/home/humungous/.aws/"
            chmod 755 "/home/humungous/.aws/"
            chown root:root "/home/humungous/.aws/credentials"
            chmod 600 "/home/humungous/.aws/credentials"
            systemctl start telnet.socket
            systemctl start vsftpd.service
        fi
    else
        # If the client already uploaded the private key before, use it to decrypt encrypted password files and set passwords for both the user and root
        chown root:root "/home/humungous/humungous_private.asc"
        chmod 600 "/home/humungous/humungous_private.asc"
        mv "/home/humungous/humungous_private.asc" "/root/archives/"
        gpg --import "/root/archives/humungous_private.asc"
        echo "humungous:$(gpg --decrypt /root/user_password.gpg)" | chpasswd
        echo "root:$(gpg --decrypt /root/root_password.gpg)" | chpasswd

        # Check if the client uploaded an API token for three different services
        if [ -f "/home/humungous/digitalocean.ini" ]; then
            chown root:root "/home/humungous/digitalocean.ini"
            chmod 600 "/home/humungous/digitalocean.ini"
            mv "/home/humungous/digitalocean.ini" "/etc/letsencrypt/"
        fi
        if [ -f "/home/humungous/cloudflare.ini" ]; then
            chown root:root "/home/humungous/cloudflare.ini"
            chmod 600 "/home/humungous/cloudflare.ini"
            mv "/home/humungous/cloudflare.ini" "/etc/letsencrypt/"
        fi
        if [ -f "/home/humungous/route53.ini" ]; then
            chown root:root "/home/humungous/route53.ini"
            chmod 600 "/home/humungous/route53.ini"
            mv "/home/humungous/route53.ini" "/etc/letsencrypt/"
        fi

        # Check if the client uploaded an AWS credentials for 'AccessKeyManager' IAM user
        if [ -f "/home/humungous/.aws/credentials" ]; then
            systemctl stop vsftpd.service
            systemctl stop telnet.socket
            killall vsftpd
            killall in.telnetd
            mkdir "/home/humungous/aws_token_storage/"
            chown humungous:humungous "/home/humungous/aws_token_storage/"
            su - -c "/usr/local/bin/aws iam create-access-key --user-name S3TcpdumpUploader" humungous > "/home/humungous/aws_token_storage/s3tcpdumpuploader_access_key.json"
            chown root:root "/home/humungous/.aws/credentials"
            chmod 600 "/home/humungous/.aws/credentials"
            mv "/home/humungous/.aws/credentials" "/root/retired_aws_credentials/accesskeymanager_credentials"
            echo "[default]" > "/home/humungous/.aws/credentials"
            echo "aws_access_key_id = $(cat /home/humungous/aws_token_storage/s3tcpdumpuploader_access_key.json | jq --raw-output '.AccessKey.AccessKeyId')" >> "/home/humungous/.aws/credentials"
            echo "aws_secret_access_key = $(cat /home/humungous/aws_token_storage/s3tcpdumpuploader_access_key.json | jq --raw-output '.AccessKey.SecretAccessKey')" >> "/home/humungous/.aws/credentials"
            chown root:root "/home/humungous/aws_token_storage/"
            mv "/home/humungous/aws_token_storage/" "/root/retired_aws_credentials/"
            chown root:root "/home/humungous/.aws/"
            chmod 755 "/home/humungous/.aws/"
            chown root:root "/home/humungous/.aws/credentials"
            chmod 600 "/home/humungous/.aws/credentials"
            systemctl start telnet.socket
            systemctl start vsftpd.service
        fi
    fi

    # Append the line to the sudoers file to allow the user to run the cleanup script as root later
    printf "\nhumungous ALL=NOPASSWD: /usr/sbin/clean-up.sh" >> "/etc/sudoers.d/99-restricted-user"

    # Create an empty file that allows the cleanup script to run when the user runs it as root later
    touch "/clean-up.txt"

    # The second section of the debug script has finished!
    touch "/debug_service_2.txt"
fi
