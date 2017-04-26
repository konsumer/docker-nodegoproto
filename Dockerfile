FROM alpine:3.5

ENV GOPATH=/go \
  PATH=$PATH:/go/bin

RUN \
  apk add --no-cache nodejs protobuf go git curl unzip libc-dev && \
  mkdir /proto && \
  git clone --depth 1 https://github.com/googleapis/googleapis.git /tmp/proto && \
  curl -s -L https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip > /tmp/proto.zip && \
  unzip -q /tmp/proto.zip -d /tmp/proto && \
  mv /tmp/proto/include/google/protobuf/ /tmp/proto/google/ && \
  mv /tmp/proto/google/ /proto/ && \
  rm -rf /tmp/proto* && \
  go get \
    github.com/golang/protobuf/protoc-gen-go \
    github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
    github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway

ENTRYPOINT ["/usr/bin/protoc", "-I /proto"]
