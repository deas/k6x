FROM golang:1.17-bullseye as builder
WORKDIR /go/src/app
RUN go install go.k6.io/xk6/cmd/xk6@latest
RUN xk6 build --with github.com/grafana/xk6-output-prometheus-remote@latest
# For the moment, we'd like to be compatible with upstream k6. Also, we want a few
# tools like tar for a bit of trickery
#
# https://github.com/grafana/k6/blob/master/Dockerfile
# FROM gcr.io/distroless/base-debian11
# COPY --from=builder /go/src/app/k6 /
# CMD ["/k6"]

FROM alpine:3.14
RUN apk add --no-cache ca-certificates && \
    adduser -D -u 12345 -g 12345 k6
COPY --from=builder /go/src/app/k6 /usr/bin/k6

USER 12345
WORKDIR /home/k6
ENTRYPOINT ["k6"]
