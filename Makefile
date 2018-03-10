DOCKER := docker run --rm -it --mount "source=apk_cache,target=/var/cache/distfiles" --mount "type=bind,source=$(PWD),target=$(PWD)" -e "PACKAGER_PRIVKEY=$(PWD)/key.rsa" -e "REPODEST=$(PWD)/repo"

.PHONY: all
all: ripgrep

.PHONY: ripgrep
ripgrep:
	$(DOCKER) --workdir "$(PWD)/ripgrep" builder 'abuild'

.PHONY: push
push: all
	s3cmd sync --acl-public repo/alpine-repository/ s3://apk/edge/alpine-repository/
	s3cmd setacl --acl-public --recursive s3://apk

.PHONY: clean
clean:
	rm -rf repo/*
