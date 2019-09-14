FROM swift:latest as builder

ADD ./ /ServerSideSwift
WORKDIR /ServerSideSwift

RUN swift build -c release
CMD .build/release/ServerSideSwift