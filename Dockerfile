FROM mesosphere/aws-cli:latest

RUN apk -v --update add \
        git \
        && \
    rm /var/cache/apk/*

ENTRYPOINT ["bash"]
