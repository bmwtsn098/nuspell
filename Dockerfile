# Build Stage:
FROM --platform=linux/amd64 debian:bookworm as builder

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
RUN wget -O en_US.aff https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.aff?id=a4473e06b56bfe35187e302754f6baaa8d75e54f
RUN wget -O en_US.dic https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.dic?id=a4473e06b56bfe35187e302754f6baaa8d75e54f


# Package Stage
FROM debian:bullseye-slim
COPY --from=builder /nuspell/build/src/nuspell/libnuspell.so /usr/local/lib
COPY --from=builder /nuspell/build/src/nuspell/libnuspell.so.5 /usr/local/lib
COPY --from=builder /nuspell/build/src/nuspell/libnuspell.so.5.1.0 /usr/local/lib
COPY --from=builder /usr/local/bin/nuspell /usr/local/bin
COPY --from=builder /nuspell/build/src/nuspell/en_US.aff /
COPY --from=builder /nuspell/build/src/nuspell/en_US.dic /
ENV LD_LIBRARY_PATH=/usr/local/lib
RUN apt-get update && apt-get install -y libicu71

