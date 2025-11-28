# Multi-stage Dockerfile for building and running the Spring Boot application
# Builds the jar with Maven (uses the project's Maven wrapper) and runs on a slim Java 21 runtime

### Build stage
FROM maven:3.10.1-eclipse-temurin-21 AS build
WORKDIR /workspace

# Copy maven wrapper and project files
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x mvnw

# Build the application (skip tests for faster builds; remove -DskipTests to run tests)
RUN ./mvnw -B -DskipTests package

### Runtime stage
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy the packaged jar from the build stage
COPY --from=build /workspace/target/*.jar app.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Use a simple entrypoint that respects any JVM options passed via the JAVA_OPTS env var
ENV JAVA_OPTS="-Xms256m -Xmx512m"
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]
