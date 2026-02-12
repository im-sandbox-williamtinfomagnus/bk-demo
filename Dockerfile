# Stage 1: Builds
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY . .
RUN chmod +x ./gradlew && ./gradlew build

# Stage 2: Runtime (INTENTIONALLY VULNERABLE)
FROM ubuntu:22.04

WORKDIR /app

# Install Java 17 (vulnerable version)
RUN apt-get update && apt-get install -y openjdk-17-jre-headless && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/app/build/libs/app.jar app.jar

EXPOSE 7070
CMD ["java", "-jar", "app.jar"]