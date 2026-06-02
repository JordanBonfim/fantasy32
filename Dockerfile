FROM debian:12 AS builder

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        coreutils \
        make && \
    rm -rf /var/lib/apt/lists/*

COPY Makefile .
COPY src/ src/

RUN make -j"$(nproc)"

FROM debian:12 AS runtime

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libstdc++6 \
        libsdl2-2.0-0 \
        libsdl2-dev && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r app && \
    useradd -r -g app -d /app -s /usr/sbin/nologin app

COPY --from=builder /app/build/app ./app

RUN chown app:app ./app

USER app

CMD ["./app"]