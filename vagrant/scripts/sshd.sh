#!/bin/bash
source config.sh

install_sshd() {
    pacman -Sy --no-confirm openssh
    return $?
}

config_sshd() {
    sed -ri 's/#Port 22/Port $port/g' /etc/ssh/sshd_config
    sed -ri 's/#LogLevel INFO/LogLevel VERBOSE/g' /etc/ssh/sshd_config
    sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config

    # Taken from Mozilla's infoSec team: Securing OpenSSH
    printf 'HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
     
KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
     
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
     
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com' >> /etc/ssh/sshd_config
}

install_sshd
while [ $? -ne 0]; do install_sshd; done

config_sshd
while [ $? -ne 0]; do config_sshd; done


chmod 400 ~/.ssh/authorized_keys
#TODO: this should be changed to sshd.socket
systemctl start sshd.service
