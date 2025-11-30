FROM jenkins/jenkins:lts
USER root

# Fix for Jenkins update center redirect issue
# Forces jenkins-plugin-cli to use the correct endpoint
ENV JENKINS_UC=https://updates.jenkins.io/current
ENV JENKINS_UC_DOWNLOAD=https://updates.jenkins.io/current
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental

# Install plugins from plugins.txt
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt

# Install Maven, Java, Docker, other tools
RUN apk add --no-cache maven \
    openjdk17 \
    docker \
    gettext

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
 && chmod +x ./kubectl \
 && mv ./kubectl /usr/local/bin/kubectl

# Not production safe (Jenkins running as root) — okay for CI/CD training/demo
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
