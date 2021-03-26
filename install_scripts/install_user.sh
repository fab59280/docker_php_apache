#!/bin/bash -e

user=$(grep "x:${HOST_UID}" < /etc/passwd | cut -d":" -f1)
group=$(grep "x:${HOST_GID}" < /etc/group | cut -d":" -f1)

if [ ! "$group" ]; then
  group="tux"
  groupadd -g "${HOST_GID}" $group
fi

if [ ! "$user" ]; then
  user="tux"
  useradd -m  -u "${HOST_UID}" -g "${HOST_GID}" -s /bin/bash $user
fi

apt install -y sudo
# ensures that the user can logging in with bash shell and is in the group defined above
usermod -aG sudo,$group -s /bin/bash $user

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
