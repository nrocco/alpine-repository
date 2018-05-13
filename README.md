alpine-repository
=================

A set of apk packages for alpine linux edge


install
-------

First import the public key:

    wget -O /etc/apk/keys/key.rsa.pub https://apk.cloudstorage.nl.leaseweb.com/key.rsa.pub

Now add the repository to apk:

    echo 'http://apk.cloudstorage.nl.leaseweb.com/edge/alpine-repository' >> /etc/apk/repositories

Update apk

    apk update --no-cache
