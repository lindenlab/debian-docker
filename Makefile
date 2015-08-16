#!/usr/bin/make -f

UID:=$(shell id -u)
GID:=$(shell id -g)

all:

listpackages:
	@dh_listpackages
	@echo dmsetup
	@echo libdevmapper1.02.1

mangle:

dockerdev:
	docker build -f debian/Dockerfile.devel -t registry.docker/build/debian-devel debian

dockerbuild: dockerdev
	docker build -t registry.docker/build/debian-docker debian

deb: dockerbuild
	docker run -i --rm -v $(CURDIR)/packages:/packages registry.docker/build/debian-docker bash -c "uscan --force-download --verbose --download-current-version && \
		DOCKER_TARBALLS=.. ./debian/helpers/download-libcontainer && \
		/tianon/extract-origtargz.sh && \
		quilt push -a && \
		dpkg-buildpackage -us -uc -b && \
		mv ../*.deb /packages && chown $(UID):$(GID) /packages/*"
	cp deps/* packages

clean:
	rm -f packages/*

distclean: clean

