FROM alpine:edge
RUN apk update
RUN apk add alpine-sdk
RUN adduser -G abuild -g "Alpine Packager" -s /bin/ash -D packager
RUN echo "packager ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER packager
CMD ["ash", "-l"]
