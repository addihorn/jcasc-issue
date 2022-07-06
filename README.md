# JCasC - unclassified root Node 

## Build with
> docker build -t myjenkins .

## Run with
> docker run -it --name myjenkins --rm --network host -p 8080:8080 myjenkins

## Issue

Settings defined in the unclassified block are not reflected in the final build.

### How to reproduce

Build and run the server.
Navigate to `localhost:8080/configure` and check entry for root-URL / Jenkins Location.  
Expected Value: `https://jenkins.my-domain.de/`  
Actual Value: `http://localhost:8080/`  

Same can be seen with the SonarQube and Gitea servers Settings.

Other settings like tools and credentials are provided correctly.  
Got to `http://localhost:8080/configureTools/` and check Values for Maven and Gradle.

## Additional Information

This is only a subset of the configurations used, but they showcase the issue.  
The complete plugin-List is provided, in case some plugins are at fault.  

