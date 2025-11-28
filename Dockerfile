# ===== Stage 1: Build =====
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Set working directory inside the container
WORKDIR /app

# Copy Maven configuration and source code
# The paths are relative to the build context (we will set context explicitly)
COPY . .

# Build the project without running tests
RUN mvn -B package -DskipTests

# ===== Stage 2: Runtime =====
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
