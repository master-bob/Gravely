#!/bin/bash
source config.sh

setup_user(){
    useradd -m -G ssh-user -s /bin/bash $user
    echo $password | passwd "$user"
    echo "$user ALL=(ALL:ALL) ALL" >> /etc/sudoers
    
    return $?
}

install_sudo(){
    pacman -Sy --noconfirm sudo
    return $?
}

install_sudo
while [ $? -ne 0 ]; do install_sudo; done

setup_user
while [ $? -ne 0 ]; do setup_user; done

rm config.sh
