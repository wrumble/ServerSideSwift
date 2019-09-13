FROM swiftdocker/swift

ADD ./ /ServerSideSwift
WORKDIR /ServerSideSwift

RUN useradd myuser && \
    chown -R myuser /app

USER myuser

ENV PATH /app/.build/release:$PATH
CMD .build/release/App --env=production --workdir="/ServerSideSwift"

EXPOSE 8080
