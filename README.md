# devops-hw11

### Jenkins pipline

The pipeline by Jenkins for a Tomcat application.

Tomcat application based on the test project:

[https://github.com/LovingFox/boxfuse-sample-java-war-hello.git](https://github.com/LovingFox/boxfuse-sample-java-war-hello.git)

##### Files

1. *Jenkinsfile* (pipeline)
2. *Dockerfile.builder* (building container)
3. *Dockerfile.app-template* (template container for application ready)

##### Prepare images

1. make a builder image by *Dockerfile.builder*
2. push the builder image to the Register (`nexus.rtru.tk:8123/hw11-builder:1.0`)
3. make an app-template image by *Dockerfile.app-template*
4. push the app-template image to the Register (`nexus.rtru.tk:8123/hw11-app-template:1.0`)

##### Steps of the Jenkins pipeline
1. build an application inside a container based on `hw11-builder`
2. pack the application to an image based on `hw11-app-template`
3. push the application image to the Register (`nexus.rtru.tk:8123/hw11-app:1.0`)
4. deploy the application image on a remote Node
