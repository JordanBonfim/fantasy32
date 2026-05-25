FROM alpine:3.19 AS builder
WORKDIR /app
RUN apk add --no-cache build-base coreutils

# Copy only files needed for build to leverage cache
COPY Makefile .
COPY src/ src/

RUN make -j$(nproc)

FROM alpine:3.19 AS runtime
WORKDIR /app
RUN apk add --no-cache libstdc++
RUN addgroup -S app && adduser -S -G app app
COPY --from=builder /app/build/app ./app
RUN chown app:app ./app
USER app
CMD ["./app"]