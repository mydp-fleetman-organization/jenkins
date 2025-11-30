FROM jenkins/jenkins:2.441-alpine-jdk21
USER root

# Copy plugins list and let the jenkins-plugin-cli resolve & install dependencies
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt

# install Maven, Java, Docker, gettext
RUN apk add --no-cache maven \
    openjdk17 \
    docker \
    gettext

# Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
 && chmod +x ./kubectl \
 && mv ./kubectl /usr/local/bin/kubectl

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
