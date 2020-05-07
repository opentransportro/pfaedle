FROM ubuntu:18.04 as build
MAINTAINER OpenTransport version: 0.1

RUN apt-get update && \
  apt-get -y install \
    build-essential protobuf-compiler cmake libprotobuf-dev \
    make g++ libreadosm-dev libproj-dev libgoogle-perftools-dev \
    curl zlib1g-dev


ENV WORK=/opt/pfaedle
WORKDIR ${WORK}
RUN mkdir -p ${WORK}

ADD . ${WORK}
RUN cd ${WORK}
RUN mkdir build && cd build && cmake .. && make -j 4 && make install


FROM ubuntu:18.04
MAINTAINER OpenTransport version: 0.1

RUN apt-get update && \
  apt-get -y install libgomp1
RUN rm -rf /var/lib/apt/lists/*
COPY --from=build /usr/local/bin/pfaedle /usr/local/bin/pfaedle
COPY --from=build /usr/local/etc/pfaedle/pfaedle.cfg /usr/local/etc/pfaedle/pfaedle.cfg
