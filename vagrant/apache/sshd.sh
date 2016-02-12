#!/bin/bash
source config.sh

install_sshd() {
    pacman -Sy --no-confirm openssh
    return $?
}

config_sshd() {
    #Copy default config
    cp /sshd_config /etc/ssh/sshd_config

    # Insert custom parameters
    sed -ri "s/#Port 22/Port $port/g" /etc/ssh/sshd_config

    #rm default config
    rm /sshd_config

    #Generate custom server keys
    cd /etc/ssh
    rm ssh_host_*key*
    ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null
    ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null

    #generate client keys
    #ssh-keygen -t ed25519 -o -a 100 -f ~/.ssh/id_ed25519
    #ssh-keygen -t rsa -b 4096 -o -a 100 -f ~/.ssh/id_rs

    # Create ssh-user group
    sudo groupadd ssh-user

    # add user to group
    sudo usermod -a -G ssh-user $user

    # Copy user key to correct location
    mkdir ~/.ssh
    chmod 700 ~/.ssh
    cat /db_id_ed25519.pub >> ~/.ssh/authorized_keys
    rm /db_id_ed25519.pub
    chmod 600 ~/.ssh/authorized_keys
}

install_sshd
while [ $? -ne 0]; do install_sshd; done

config_sshd
while [ $? -ne 0]; do config_sshd; done

#TODO: this should be changed to sshd.socket
systemctl start sshd.service
