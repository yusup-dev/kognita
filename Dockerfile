FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/kognita-0.0.1-SNAPSHOT.jar kognita.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "kognita.jar"]
