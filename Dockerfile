FROM alpine:3.10

EXPOSE 22
VOLUME /opt/backup /opt/keys

RUN apk add --update --no-cache openssh borgbackup && \
    mkdir -p /tmp && \
    rm -rf /etc/ssh/ssh_host*key && \
    sed -i -e 's/^root:!/root::/' /etc/shadow

ADD entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
