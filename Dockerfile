FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    nginx \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ansible \
    && echo "ansible:ansible" | chpasswd \
    && usermod -aG sudo ansible \
    && echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /run/sshd

COPY app/index.html /var/www/html/index.html

RUN sed -i 's/listen 80 default_server;/listen 10000 default_server;/' \
    /etc/nginx/sites-available/default \
    && sed -i 's/listen \[::\]:80 default_server;/listen [::]:10000 default_server;/' \
    /etc/nginx/sites-available/default

EXPOSE 22 10000

CMD ["/bin/bash", "-c", "/usr/sbin/sshd && nginx -g 'daemon off;'"]