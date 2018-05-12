DOCKER := docker run --rm -it \
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
all: ripgrep ide fd ctagsio cloudctl

.PHONY: ripgrep
ripgrep:
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild checksum
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild -r
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild cleanoldpkg

.PHONY: ide
ide:
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild checksum
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild -r
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild cleanoldpkg

.PHONY: fd
fd:
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild checksum
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild -r
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild cleanoldpkg

.PHONY: ctagsio
ctagsio:
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild checksum
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild -r
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild cleanoldpkg

.PHONY: cloudctl
cloudctl:
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild checksum
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild -r
	$(DOCKER) --workdir "$(PWD)/$@" builder abuild cleanoldpkg

.PHONY: push
push:
	s3cmd sync --delete-removed --acl-public repo/alpine-repository/ s3://apk/edge/alpine-repository/
	s3cmd setacl --acl-public --recursive s3://apk

.PHONY: clean
clean:
	rm -rf repo/*

.PHONY: builder
builder:
	docker build -t builder builder/
