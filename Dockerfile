FROM alpine:3.8

RUN apk add --update --no-cache git bash openssh
# config for git
RUN mkdir -p ~/.ssh && \
    echo -e "[url \"ssh://git@github.com:\"]\\n\\tinsteadOf = https://github.com" >> ~/.gitconfig && \
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > ~/.ssh/config

COPY semversions.sh /usr/local/bin/

ENTRYPOINT [ "semversions.sh" ]