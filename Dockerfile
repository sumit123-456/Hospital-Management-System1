# ===== Stage 1: Build =====
FROM eclipse-temurin:21-jdk AS build

# Set working directory
WORKDIR /app

# Copy Maven wrapper and project files
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src ./src

# Make mvnw executable
RUN chmod +x mvnw

# Download dependencies offline (cache layer)
RUN ./mvnw dependency:go-offline -B

# Build the project without tests
RUN ./mvnw -B package -DskipTests -DfinalName=hospital-app

# ===== Stage 2: Runtime =====
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/hospital-app.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
