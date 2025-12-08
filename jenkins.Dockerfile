FROM jenkins/jenkins:lts

USER root

# Installer Docker CLI dans Jenkins (client uniquement)
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean

# Permettre à Jenkins d'utiliser Docker
RUN usermod -aG docker jenkins

USER jenkins
