FROM registry.docker/build/debian-devel

WORKDIR /build

RUN apt-get update && apt-get -y install \
  bison \
  debhelper \
  ed \
  gawk \
  netbase \
  perl \ 
  git \
  build-essential \
  devscripts

RUN  git clone https://anonscm.debian.org/git/pkg-golang/golang.git --branch debian/2%1.4.3-3 && \
     cd golang && \
     debuild -us -uc -b

#ENTRYPOINT ["/bin/bash", "-c"]
#CMD ["/bin/mv /build/*.deb /packages"]

RUN dpkg -i \
  golang_*.deb \
  golang-doc_*.deb \
  golang-src_*.deb \
  golang-go_*.deb \
  golang-go-linux-amd64*.deb
