FROM mesosphere/aws-cli:latest

RUN apk -v --update add \
        git \
        && \
    rm /var/cache/apk/*

RUN git config --global credential.helper '!aws codecommit credential-helper $@' && git config --global credential.UseHttpPath true

ENTRYPOINT ["sh"]
