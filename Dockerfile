FROM openjdk:8-jre-alpine

# 设置时区与语言
RUN apk update && apk add tzdata \
      && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
      && echo "Asia/Shanghai" >  /etc/timezone \
      && apk del tzdata

ARG module=springboot4circleci
ARG version=0.0.1-SNAPSHOT
ENV jarName=$module-$version.jar

ADD target/$jarName /

ADD ./docker-entrypoint.sh /

RUN chmod u+x /docker-entrypoint.sh

WORKDIR /

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]