# Build
FROM maven:alpine as builder
WORKDIR /workspace/
COPY . /workspace/

RUN mvn -B -e -C -T 1C dependency:go-offline
RUN mvn -B -e -o -T 1C package -Dmaven.test.skip=true

# Runtime
FROM openjdk:8-jre-alpine

RUN apk update && apk add tzdata \
      && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
      && echo "Asia/Shanghai" >  /etc/timezone \
      && apk del tzdata

ARG module=springboot4circleci
ARG version=0.0.1-SNAPSHOT
ENV jarName=$module-$version.jar

COPY --from=builder /workspace/target/$jarName /

WORKDIR /

EXPOSE 8080

ENTRYPOINT java $JAVA_OPTS -jar $jarName