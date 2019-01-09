FROM golang:1.11-alpine AS builder

ENV GOBIN $GOPATH/bin
ENV GOROOT /usr/local/go
ENV PATH $PATH:/:$GOROOT/bin:$GOPATH/bin

RUN apk add --update --no-cache git bash curl openssh make

ARG go_workspace=/go
ENV GOPATH $go_workspace
ENV PROJECT_DIR=$GOPATH/src/github.com/pantheon-systems
WORKDIR $PROJECT_DIR

RUN git clone https://github.com/pantheon-systems/autotag.git

WORKDIR $PROJECT_DIR/autotag
RUN make deps

RUN GOOS=linux GOARCH=amd64 go build -i -o autotag/autotag autotag/*.go

FROM alpine:3.8 AS production

RUN apk add --update --no-cache git bash openssh
# config for git
RUN mkdir -p ~/.ssh && \
    echo -e "[url \"ssh://git@github.com:\"]\\n\\tinsteadOf = https://github.com" >> ~/.gitconfig && \
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > ~/.ssh/config

COPY --from=builder /go/src/github.com/pantheon-systems/autotag/autotag /usr/local/bin/