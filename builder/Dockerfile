FROM alpine:edge
RUN apk update
RUN apk add alpine-sdk
RUN apk add go
RUN adduser -G abuild -g "Alpine builder" -s /bin/ash -D builder
RUN echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER builder
CMD ["ash", "-l"]
