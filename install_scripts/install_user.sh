#!/bin/bash -e

user=$(grep ":${HOST_UID}" < /etc/group | cut -d":" -f1)

if [ ! "$user" ]; then
  user="tux"

  groupadd -g "${HOST_GID}" $user

  useradd -m  -u "${HOST_UID}" -g "${HOST_GID}" -s /bin/bash $user

fi

apt install -y sudo
# ensures that the user can logging in with bash shell
usermod -aG sudo -s /bin/bash $user

# set default passwd to tux user
passwd="azertyuiop"
echo "${user}:${passwd}" | chpasswd

echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

cat >> "$(grep $user < /etc/passwd | cut -d ":" -f6)"/.bashrc <<EOT
alias ls='ls --color=auto';
alias ll='ls --color=auto -alF';
alias la='ls --color=auto -A';
alias l='ls --color=auto -CF';
EOT
