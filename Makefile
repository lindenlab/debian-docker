#!/usr/bin/make -f

UID:=$(shell id -u)
GID:=$(shell id -g)

all:

listpackages:
	@dh_listpackages
	@echo golang-logrus-dev
	@echo golang-fsnotify-dev

mangle:

dockerdev:
	docker build -f debian/Dockerfile.devel -t registry.docker/build/debian-devel debian

dockerbuild: dockerdev
	docker build -t registry.docker/build/debian-docker debian

deb: dockerbuild
	docker run -i --rm -v $(CURDIR)/packages:/packages registry.docker/build/debian-docker bash -c "/tianon/extract-origtargz.sh && dpkg-buildpackage -us -uc && mv ../*.deb /packages && chown $(UID):$(GID) /packages/*"

clean:
	rm -f packages/*

distclean: clean

