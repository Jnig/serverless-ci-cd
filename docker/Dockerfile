FROM mesosphere/aws-cli:latest

RUN apk -v --update add \
        git \
        && \
    rm /var/cache/apk/*

ADD mirror.sh /usr/local/bin 
RUN git config --global credential.helper '!aws codecommit credential-helper $@' \
    && git config --global credential.UseHttpPath true \
    && chmod +x /usr/local/bin/mirror.sh

ENTRYPOINT ["sh"]
