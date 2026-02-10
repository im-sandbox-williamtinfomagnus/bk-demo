# Stage 1: Build
FROM eclipse-temurin:25-jdk AS build
WORKDIR /app
COPY . .
RUN chmod +x ./gradlew && ./gradlew build

# Stage 2: Runtime (INTENTIONALLY VULNERABLE)
FROM ubuntu:18.04

WORKDIR /app

# Install Java 8 (vulnerable version)
RUN apt-get update && apt-get install -y openjdk-8-jre-headless && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/app/build/libs/app.jar app.jar

EXPOSE 7070
CMD ["java", "-jar", "app.jar"]