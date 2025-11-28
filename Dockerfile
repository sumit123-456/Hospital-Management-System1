FROM eclipse-temurin:21-jdk AS build

WORKDIR /app

# Copy everything from the build context
COPY . .

# Make mvnw executable
RUN chmod +x mvnw

# Cache dependencies
RUN ./mvnw dependency:go-offline -B

# Build without tests
RUN ./mvnw -B package -DskipTests -DfinalName=hospital-app

FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy JAR
COPY --from=build /app/target/hospital-app.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
