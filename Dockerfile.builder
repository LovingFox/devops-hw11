FROM maven:3.8-eclipse-temurin-11-focal

# Update and install some common pacakges
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get -y install docker-ce
    
# Clear cache
RUN apt-get clean
