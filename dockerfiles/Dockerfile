FROM azul/zulu-openjdk-alpine:21-jre

ARG APP_NAME
ENV APP=$APP_NAME

COPY build/libs/$APP.jar .
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "$APP.jar"]
