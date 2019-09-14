FROM ibmcom/swift-ubuntu:5.0.2

ADD ./ /ServerSideSwift
WORKDIR /ServerSideSwift

RUN swift build -c release
CMD .build/release/ServerSideSwift