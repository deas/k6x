FROM golang:1.17-bullseye as build
WORKDIR /go/src/app
RUN go install go.k6.io/xk6/cmd/xk6@latest
RUN xk6 build --with github.com/grafana/xk6-output-prometheus-remote@latest
FROM gcr.io/distroless/base-debian11
COPY --from=build /go/src/app/k6 /
CMD ["/k6"]
