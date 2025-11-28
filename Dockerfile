# ===== Stage 1: Build =====
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Set working directory
WORKDIR /app

# 1️⃣ Copy only pom.xml first to cache dependencies
COPY pom.xml .

# Download dependencies offline (cache layer)
RUN mvn dependency:go-offline -B

# 2️⃣ Copy the source code
COPY src ./src

# 3️⃣ Build the project without tests
# Explicitly specify the final JAR name
RUN mvn -B package -DskipTests -DfinalName=hospital-app

# ===== Stage 2: Runtime =====
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/hospital-app.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
