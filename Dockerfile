FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    openssh-server \
    sudo \
    python3 \
    python3-apt \
    nano \
    && mkdir /var/run/sshd


# Crear usuario ansible con password ansible
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd


# Dar permisos sudo sin password
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# Permitir login por contraseña SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config


EXPOSE 22


CMD ["/usr/sbin/sshd", "-D"]
