FROM alpine:3.14

LABEL maintainer="Sergey Denisov <DenisovS21@gmail.com>"

RUN apk update && \
    apk upgrade && \
    apk add ca-certificates && \
    update-ca-certificates && \
    apk add tzdata jq curl bash

RUN rm -rf /var/cache/apk/*

ENV TZ=Asia/Novosibirsk

WORKDIR /root/

COPY ./tgbot.sh .

CMD ["./tgbot.sh"]