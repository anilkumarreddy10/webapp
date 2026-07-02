# Use a lightweight JDK image
FROM eclipse-temurin:17-jdk-alpine

# Set working directory inside container
WORKDIR /app

# Copy your JAR file into the container
COPY target/*.jar app.jar

# Run the JAR when the container starts
CMD ["java", "-jar", "app.jar"]
