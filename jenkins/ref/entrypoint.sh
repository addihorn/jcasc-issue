if [ "${MY_POD_NAMESPACE}" ]; 
    then 
        export MY_POD_NAMESPACE="-${MY_POD_NAMESPACE}"
        export K8S_SUBDOMAIN=".apps.os-prod"; 
    fi

if [ "${AGENT_TLS_ENABLED}" == false ];
    then
      export AGENT_PROTOCOL="http";
    fi
    
echo "Setting Kubernetes Jenkins-URL to ${AGENT_PROTOCOL}://jenkins${MY_POD_NAMESPACE}${K8S_SUBDOMAIN}.lab.my-domain.de/" 

# Starting Jenkins
/usr/local/bin/jenkins.sh
