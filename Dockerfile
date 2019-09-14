FROM ibmcom/swift-ubuntu:5.0.2

# ADD ./ /ServerSideSwift
WORKDIR /ServerSideSwift
COPY . .

RUN swift build -c release
CMD .build/release/ServerSideSwift