# Use an official Gradle image to build the app
FROM gradle:jdk21-alpine AS build

# Set the working directory
WORKDIR /project

# Copy the Gradle wrapper and the build.gradle.kts and settings.gradle.kts files
COPY build.gradle.kts settings.gradle.kts ./

# Copy the rest of the project files
COPY src ./src

# Build the project
RUN gradle build --no-daemon -x test

# Use an official OpenJDK runtime as a parent image
FROM eclipse-temurin:21-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the built jar file from the build stage
COPY --from=build /project/build/libs/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]
