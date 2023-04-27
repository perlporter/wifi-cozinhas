#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

# copiando arquivo necessario para login automatico
sudo mv 60-lightdm-gtk-greeter.conf /etc/lightdm/lightdm.conf.d/

apt update -y
apt upgrade -y

# instala ambiente gráfico, ferramentas de rede e browser
apt install -y ubuntu-desktop-minimal \
    lightdm \
    net-tools \
    traceroute \
    firefox

dpkg --configure -a

# remove pacotes desnecessários (incluindo tela inicial de "boas-vindas")
apt remove -y gnome-initial-setup
apt autoremove -y

# configurando o lightdm pq o gdm3 não tava funcionando
echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
dpkg-reconfigure lightdm
echo set shared/default-x-display-manager lightdm | debconf-communicate

# mandando bootar em modo gráfico
systemctl set-default graphical.target
