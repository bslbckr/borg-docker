#!/bin/sh

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    ssh-keygen -q -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
    ssh-keygen -q -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

mkdir -p /var/run/sshd

# generate ssh-keys for login
if [ -f /opt/keys/authorized_keys ]; then
    cp /opt/keys/authorized_keys ~/.ssh/authorized_keys
elif [ ! -f /root/.ssh/id_ecdsa ]; then
    ssh-keygen -t ecdsa -b 521 -N '' -C 'for use with borg docker image' -f /root/.ssh/id_ecdsa
    cat <<EOF >> ~/.ssh/authorized_keys
command="borg serve --restrict-to-repository=/opt/backup/melmac",restrict $(cat ~/.ssh/id_ecdsa.pub)
EOF
    echo "***** your private key for accessing this image ******"
    cat ~/.ssh/id_ecdsa
fi

exec "$@"
