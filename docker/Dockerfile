FROM mesosphere/aws-cli:latest

RUN apk -v --update add \
        git openssh-client \
        && \
    rm /var/cache/apk/*

ADD mirror.sh /usr/local/bin 
RUN chmod +x /usr/local/bin/mirror.sh

ENTRYPOINT ["sh"]
