FROM swiftdocker/swift
ADD . /ServerSideSwift
WORKDIR /ServerSideSwift
CMD swift run
EXPOSE 8080
ENTRYPOINT [".build/release/ServerSideSwift"]