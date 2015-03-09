#!/usr/bin/make -f

all:

listpackages:
	@find packages/ -name "*deb" | sed -e 's_^packages/__' -e 's/_.*//'

mangle:

dockerdev:
	docker pull registry.docker/build/debian-devel
	docker build -f debian/Dockerfile.devel -t registry.docker/build/debian-devel debian
	docker push registry.docker/build/debian-devel

dockerbuild: dockerdev
	docker build -t registry.docker/build/debian-docker debian

deb: dockerbuild
	docker run -it --rm -v $(CURDIR)/packages:/packages registry.docker/build/debian-docker bash -c "/tianon/extract-origtargz.sh && dpkg-buildpackage -us -uc && mv ../*.deb /packages && chown $(id -u):$(id -g) /packages/*"

clean:
	rm -f packages/*

distclean: clean

