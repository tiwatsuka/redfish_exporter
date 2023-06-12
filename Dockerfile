FROM golang:rc-bullseye AS builder

LABEL maintainer="Takuya Iwatsuka <takuya.iwatsuka@gmail.com>"

ARG ARCH=amd64

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH "$GOROOT/bin:$GOPATH/bin:$PATH"
ENV GO_VERSION 1.15.2
ENV GO111MODULE=on 

WORKDIR /app
COPY . .

# Build dependencies
RUN make build

FROM golang:rc-bullseye

COPY --from=builder /app/build/redfish_exporter /usr/local/bin/redfish_exporter
RUN mkdir /etc/prometheus
COPY config.yml.example /etc/prometheus/redfish_exporter.yml
CMD ["/usr/local/bin/redfish_exporter","--config.file","/etc/prometheus/redfish_exporter.yml"]
