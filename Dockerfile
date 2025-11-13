# Pull official base image
FROM python:3.12-slim

RUN apt update && \
    apt -y install curl zip unzip ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L -o /tmp/jdk.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.13+11/OpenJDK17U-jdk_x64_linux_hotspot_17.0.13_11.tar.gz && \
    mkdir -p /opt/java /app && \
    tar -xzf /tmp/jdk.tar.gz -C /opt/java --strip-components=1 && \
    rm /tmp/jdk.tar.gz

# Set environment variables
ENV JAVA_HOME=/opt/java
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy application files
COPY ./basic /app/basic
COPY ./gradle /app/gradle
COPY ./util /app/util
COPY ./gradle.properties /app/gradle.properties
COPY ./gradlew /app/gradlew
COPY ./settings.gradle.kts /app/settings.gradle

RUN ./gradlew clean basic:basic-02-health-endpoint:build