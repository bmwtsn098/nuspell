# Build Stage:
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git cmake libicu-dev wget

## Add Source Code
ADD . /nuspell
WORKDIR /nuspell

## Build Step
RUN rm -rf build
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make
RUN make install
WORKDIR /nuspell/build/src/nuspell
RUN cp libnuspell.so /usr/local/lib
RUN cp libnuspell.so.5 /usr/local/lib
RUN cp libnuspell.so.5.1.0 /usr/local/lib
ENV LD_LIBRARY_PATH=/usr/local/lib
RUN wget -O en_US.aff https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.aff?id=a4473e06b56bfe35187e302754f6baaa8d75e54f
RUN wget -O en_US.dic https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.dic?id=a4473e06b56bfe35187e302754f6baaa8d75e54f


# Package Stage
#FROM --platform=linux/amd64 ubuntu:20.04
#COPY --from=builder /fuzzme /
