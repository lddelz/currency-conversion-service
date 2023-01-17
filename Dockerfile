FROM eclipse-temurin:17.0.3_7-jdk-alpine AS builder
WORKDIR /currency-conversion-service
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} currency-conversion-service-0.0.1-SNAPSHOT.jar
RUN java -Djarmode=layertools -jar currency-conversion-service-0.0.1-SNAPSHOT.jar extract

FROM eclipse-temurin:17.0.3_7-jdk-alpine
WORKDIR /currency-conversion-service
COPY --from=builder currency-conversion-service/dependencies/ ./
COPY --from=builder currency-conversion-service/spring-boot-loader/ ./
COPY --from=builder currency-conversion-service/snapshot-dependencies/ ./
COPY --from=builder currency-conversion-service/application/ ./

VOLUME /tmp
USER nobody:nobody

ENTRYPOINT ["java", "-XshowSettings:vm", "-XX:+UseZGC", "-XX:MaxRAMPercentage=75.0", "org.springframework.boot.loader.JarLauncher"]
EXPOSE 5400
