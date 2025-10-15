# Use the official Tomcat image with OpenJDK 17
FROM tomcat:9-jdk17-temurin-jammy

# Set environment variables (optional but good practice)
ENV APP_HOME /usr/local/tomcat/webapps
WORKDIR $APP_HOME

# Copy the WAR file into the Tomcat webapps directory
COPY target/VendingMachine-5.war VendingMachine-5.war

# Expose the port the app runs on
EXPOSE 8080

# The base Tomcat image already includes the CMD to start Tomcat,
# so no need to specify it again.
