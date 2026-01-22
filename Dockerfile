FROM eclipse-temurin:25-jre
WORKDIR /app
COPY app/build/libs/app.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]