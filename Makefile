DOCKER := docker run --rm -it \
	--dns 1.1.1.1 \
	--mount "source=apk_cache,target=/var/cache/distfiles" \
	--mount "type=bind,source=$(PWD),target=$(PWD)" \
	--mount "type=bind,source=$(PWD)/key.rsa.pub,target=/etc/apk/keys/key.rsa.pub" \
	--env "PACKAGER_PRIVKEY=$(PWD)/key.rsa" \
	--env "REPODEST=$(PWD)/repo"

.PHONY: versions
versions:
	grep -E '^pkgver=|url=' */APKBUILD

.PHONY: shell
shell:
	$(DOCKER) --workdir "$(PWD)" builder ash -l

.PHONY: all
all: ide

.PHONY: ide
ide:
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild checksum
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild -r
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild cleanoldpkg

.PHONY: push
push:
	mc mirror --overwrite --remove repo/alpine-repository/ leaseweb/apk/edge/alpine-repository/
	env/bin/s3cmd --config fuu.cfg setacl --acl-public --recursive s3://apk

.PHONY: clean
clean:
	rm -rf repo/*

.PHONY: builder
builder:
	docker build -t builder builder/
