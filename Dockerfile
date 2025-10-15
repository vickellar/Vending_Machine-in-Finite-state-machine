# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set environment variables for the application
ENV APP_HOME /usr/src/app
WORKDIR $APP_HOME

# Copy the WAR file into the container
COPY target/VendingMachine-5.war app.war

# Install Tomcat
RUN apt-get update && apt-get install -y wget \
    && wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.73/bin/apache-tomcat-9.0.73.tar.gz \
    && tar -xzf apache-tomcat-9.0.73.tar.gz \
    && mv apache-tomcat-9.0.73 tomcat \
    && rm apache-tomcat-9.0.73.tar.gz

# Deploy the WAR file
RUN mv VendingMachine-5.war tomcat/webapps/

# Expose the port the app runs on
EXPOSE 8080

# Start Tomcat
CMD ["tomcat/bin/catalina.sh", "run"]