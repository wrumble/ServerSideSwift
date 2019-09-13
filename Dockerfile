FROM swiftdocker/swift

ADD ./ /ServerSideSwift
WORKDIR /ServerSideSwift

RUN useradd myuser && \
    chown -R myuser /ServerSideSwift

USER myuser

RUN swift build -c release
ENV PATH /app/.build/release:$PATH
CMD .build/release/ServerSideSwift --env=production --workdir="/ServerSideSwift"

EXPOSE 8080
