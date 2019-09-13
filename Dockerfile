FROM swiftdocker/swift

ADD ./ /ServerSideSwift
WORKDIR /ServerSideSwift

# RUN useradd myuser && \
#     chown -R myuser /ServerSideSwift

# USER myuser

# EXPOSE 8080

RUN swift build -c release
CMD .build/release/ServerSideSwift