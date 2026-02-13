# Stage 1: Build
FROM eclipse-temurin:25-jdk AS build
WORKDIR /app
COPY . .
RUN chmod +x ./gradlew && ./gradlew build

# Stage 2: Runtime
FROM chainguard/jre:latest
WORKDIR /app
COPY --from=build /app/app/build/libs/app.jar app.jar
EXPOSE 7070
CMD ["java", "-jar", "app.jar"]