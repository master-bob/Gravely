FROM derjudge/archlinux-apache-php
MAINTAINER masterbob <masterbob@gmail.com >
#RUN pacman -Syu --noconfirm

COPY config.sh /
COPY apache_id_ed25519.pub /
COPY sshd_config / 
COPY init.sh /
COPY sshd.sh /

RUN bash /init.sh

CMD ["/sshd.sh"]
