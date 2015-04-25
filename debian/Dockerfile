FROM registry.docker/build/debian-devel

# since we're uploading to experimental, let's build with deps from it too
#RUN echo 'APT::Default-Release "experimental";' > /etc/apt/apt.conf.d/default

# start by adding just "debian/control" so we can get mk-build-deps with maximum caching
COPY control /usr/src/docker.io/debian/
WORKDIR /usr/src/docker.io

# grab sid dependencies and include experimental packages
RUN APT_LINE=$(cat /etc/apt/sources.list | grep '^deb ' | grep 'jessie main') ; \
    echo $APT_LINE | sed 's/jessie/sid/' >> /etc/apt/sources.list && \
    cat /etc/apt/sources.list && \
    apt-get update && \
    apt-get -t sid install golang-logrus-dev && \
    sed -i 's/sid main/experimental main/' /etc/apt/sources.list

# get all the build deps of _this_ package in a nice repeatable way
RUN apt-get update && mk-build-deps -irt'apt-get -t experimental --no-install-recommends -yV' debian/control && dpkg-checkbuilddeps

# need our debian/ directory to compile _this_ package
COPY . /usr/src/docker.io/debian

# tianon is _really_ lazy, and likes a preseeded bash history
RUN echo 'uscan --force-download --verbose --download-current-version && DOCKER_TARBALLS=.. ./debian/helpers/download-libcontainer && /tianon/extract-origtargz.sh && dpkg-buildpackage -us -uc && lintian -EvIL+pedantic' >> /root/.bash_history
