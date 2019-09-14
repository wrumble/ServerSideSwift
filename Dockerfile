FROM ibmcom/swift-ubuntu:5.0.2

WORKDIR /ServerSideSwift
COPY . .

RUN swift build -c release
CMD .build/release/ServerSideSwift