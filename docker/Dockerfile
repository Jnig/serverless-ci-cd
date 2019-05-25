FROM python:alpine 

RUN apk -v --update add \
        git openssh-client \
        jq \
        && \
    rm /var/cache/apk/*
RUN pip install --no-cache-dir awscli

ADD mirror.sh /usr/local/bin 
RUN chmod +x /usr/local/bin/mirror.sh

ENTRYPOINT ["sh"]
