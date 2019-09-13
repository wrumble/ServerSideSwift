FROM swiftdocker/swift
ADD . /ServerSideSwift
WORKDIR /ServerSideSwift
CMD swift build --configuration release
EXPOSE 8080
ENTRYPOINT [".build/release/ServerSideSwift"]