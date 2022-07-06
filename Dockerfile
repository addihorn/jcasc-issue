

FROM docker.io/alpine:latest AS secrets
USER root
ARG SONARQUBE_TOKEN=NothingToSeeHere
ARG KUBERNETES_TOKEN=NothingToSeeHere
ARG GITEA_TOKEN=NothingToSeeHere

RUN mkdir /secrets

RUN printf ${SONARQUBE_TOKEN} > /secrets/SONARQUBE_TOKEN
RUN printf ${KUBERNETES_TOKEN} > /secrets/KUBERNETES_TOKEN
RUN printf ${GITEA_TOKEN} > /secrets/GITEA_TOKEN


############################################################

FROM docker.io/jenkins/jenkins:lts-jdk11
USER root

ENV K8S_JENKINS_URL "https://jenkins.lab.my-domain.de"
ENV K8S_JENKINS_PORT 443
ENV SECRETS "/secrets/jenkins"
ENV SECRET_FILE_PATH "/secrets"
ENV AGENT_TLS_ENABLED true
ENV AGENT_PROTOCOL "https"
ENV K8S_SUBDOMAIN ""
ENV MY_POD_NAMESPACE ""
ENV COLOR_SCHEME "pink"

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Dhudson.remoting.ClassFilter=com.openshift.jenkins.plugins.OpenShiftDSL"
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/configurations


#install git
RUN apt-get update && apt-get install -y git


#Copy a base Configuration to the new cluster
COPY jenkins/ /usr/share/jenkins/

# run pluginmanagement from cli instead of shell-script
# if this failes load plugins via shell-script
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt \
						--verbose

#RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.

RUN chgrp 0 /usr/share/jenkins/ref/entrypoint.sh \
	&& chmod 777 /usr/share/jenkins/ref/entrypoint.sh


USER jenkins

COPY --from=secrets /secrets ${SECRET_FILE_PATH}

ENTRYPOINT ["/bin/bash", "-c", "/usr/share/jenkins/ref/entrypoint.sh"] 