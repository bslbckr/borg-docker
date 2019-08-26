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
else
    ssh-keygen -t ecdsa -b 521 -N '' -C 'for use with borg docker image' -f /root/.ssh/id_ecdsa
    cat ~/.ssh/id_ecdsa.pub >> ~/.ssh/authorized_keys
    echo "***** your private key for accessing this image ******"
    cat ~/.ssh/id_ecdsa
fi

echo "***** the sshd-config *****"
cat /etc/ssh/sshd_config

exec "$@"
