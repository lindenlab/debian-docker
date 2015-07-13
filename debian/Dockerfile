FROM registry.docker/build/debian-devel

#RUN echo 'deb http://incoming.debian.org/debian-buildd buildd-unstable main contrib non-free' > /etc/apt/sources.list.d/incoming.list

# start by adding just "debian/control" so we can get mk-build-deps with maximum caching
COPY control /usr/src/docker.io/debian/
WORKDIR /usr/src/docker.io

# grab sid dependencies and include experimental packages
RUN APT_LINE=$(cat /etc/apt/sources.list | grep '^deb ' | grep 'jessie main') ; \
    echo $APT_LINE | sed 's/jessie/sid/' >> /etc/apt/sources.list && \
    cat /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y -t sid install golang \
        golang-goprotobuf-dev \
        golang-go-patricia-dev \
        golang-logrus-dev \
        golang-dbus-dev \
        golang-gocapability-dev \
        golang-fsnotify-dev \
        go-md2man \
        golang-context-dev \
        golang-go-systemd-dev \
        golang-go.net-dev \
        golang-gosqlite-dev \
        golang-mux-dev \
        golang-pty-dev && \
    sed -i 's/sid main/experimental main/' /etc/apt/sources.list

# get all the build deps of _this_ package in a nice repeatable way
RUN apt-get update && mk-build-deps -irt'apt-get -t experimental --no-install-recommends -yV' debian/control && dpkg-checkbuilddeps

# need our debian/ directory to compile _this_ package
COPY . /usr/src/docker.io/debian

# tianon is _really_ lazy, and likes a preseeded bash history
RUN echo 'uscan --force-download --verbose --download-current-version && \
    DOCKER_TARBALLS=.. ./debian/helpers/download-libcontainer && \
    /tianon/extract-origtargz.sh && \
    quilt push -a && \
    dpkg-buildpackage -us -uc && lintian -EvIL+pedantic' >> /root/.bash_history
