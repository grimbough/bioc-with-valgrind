FROM bioconductor/bioconductor_docker:devel

RUN apt-get update && apt-get -y install valgrind

## Download R devel
WORKDIR /tmp/
RUN wget -c https://stat.ethz.ch/R/daily/R-devel.tar.gz -O - | tar -xz

RUN echo "$valgrind_level"

## Build and install R
ARG valgrind_level
WORKDIR /tmp/R-devel
RUN ./configure \
  --with-valgrind-instrumentation=$valgrind_level \
  --with-system-valgrind-headers=yes \
  --prefix=/usr/local \
  --enable-R-shlib \
  --enable-memory-profiling 
RUN make -j && make install

WORKDIR /
RUN rm -r /tmp/R-devel
