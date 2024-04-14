FROM azul/zulu-openjdk-alpine:21-jre

ARG APP_NAME

COPY build/libs/${APP_NAME}.jar .
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "${APP_NAME}.jar"]
