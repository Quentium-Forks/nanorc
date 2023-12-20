FROM alpine:latest
RUN apk add --no-cache python3 py3-pip nano curl
RUN curl https://raw.githubusercontent.com/Quentium-Forks/nanorc/master/install.sh | sh
ENTRYPOINT [ "nano" ]