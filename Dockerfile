# Stage 1: Build
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app
COPY . .
RUN chmod +x ./gradlew && ./gradlew build

# Stage 2: Runtime
FROM gcr.io/distroless/java21-debian12
WORKDIR /app
COPY --from=build /app/app/build/libs/app.jar app.jar
EXPOSE 7070
CMD ["app.jar"]