DOCKER := docker run --rm -it --mount "source=apk_cache,target=/var/cache/distfiles" --mount "type=bind,source=$(PWD),target=$(PWD)" -e "PACKAGER_PRIVKEY=$(PWD)/key.rsa" -e "REPODEST=$(PWD)/repo"

all: ripgrep

.PHONY: ripgrep
ripgrep:
	$(DOCKER) --workdir "$(PWD)/ripgrep" builder 'abuild'
