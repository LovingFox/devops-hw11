pipeline {
    parameters {
        string(name: "Version", defaultValue: "1.0")
        string(name: "Template", defaultValue: "1.0")
    }
    agent {
        docker {
            image "nexus.rtru.tk:8123/hw11-builder:${params.Version}"
            registryUrl 'https://nexus.rtru.tk:8123/'
            registryCredentialsId '678de0e5-da9b-4305-bcf5-1f10f46f8246'
            args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 120'
        }
    }

    stages {
        stage('Fetch, build and push') {
            steps {
                git 'https://github.com/LovingFox/boxfuse-sample-java-war-hello.git'
                sh "mvn package"
                sh "echo FROM nexus.rtru.tk:8123/hw11-app-template:${params.Template} > Dockerfile"
                sh "echo COPY ./target/*.war /opt/tomcat/webapps/ROOT.war >> Dockerfile"
                sh "docker build -t nexus.rtru.tk:8123/hw11-app:${params.Version} ."
                sh "docker push nexus.rtru.tk:8123/hw11-app:${params.Version}"
                sh "docker rmi nexus.rtru.tk:8123/hw11-app:${params.Version}"
            }
        }
    }
}
