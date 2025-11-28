# Stage 1: Build
FROM maven:3.9.4-eclipse-temurin-17 AS build

WORKDIR /app

# Copy only what’s necessary for dependency resolution first
COPY pom.xml .
COPY src ./src

# Build the application without tests
RUN mvn -B package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy the packaged jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose default Spring Boot port (adjust if different)
EXPOSE 8080

# Run the jar
CMD ["java", "-jar", "app.jar"]
