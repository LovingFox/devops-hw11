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
            args '-v /var/run/docker.sock:/var/run/docker.sock --group-add $(cat /tmp/group)'
        }
    }

    stages {
        stage('Fetch and build') {
            steps {
                git 'https://github.com/LovingFox/boxfuse-sample-java-war-hello.git'
                sh "mvn package"
                sh "echo FROM nexus.rtru.tk:8123/hw11-app-template:${params.Template} > Dockerfile"
                sh "echo COPY ./target/*.war /opt/tomcat/webapps/ROOT.war >> Dockerfile"
                sh "docker build -t nexus.rtru.tk:8123/hw11-app:${params.Version} ."
            }
        }

        stage('Push and local remove') {
            steps {
                sh "docker push nexus.rtru.tk:8123/hw11-app:${params.Version}"
                sh "docker rmi nexus.rtru.tk:8123/hw11-app:${params.Version}"
            }
        }

        stage('Deploy at devops5') {
            steps {
                sshagent(['77e6ac01-81f8-45ac-9b89-d91f5dbdd25f']) {
                    sh 'ssh -o StrictHostKeyChecking=no -l root devops5 \'for ID in $(docker ps -q); do docker stop $ID; done\''
                    sh 'ssh -o StrictHostKeyChecking=no -l root devops5 \'for ID in $(docker ps -a -q); do docker rm $ID; done\''
                    sh 'ssh -o StrictHostKeyChecking=no -l root devops5 \'for ID in $(docker images -q); do docker rmi $ID; done\''
                    sh "ssh -o StrictHostKeyChecking=no -l root devops5 docker pull nexus.rtru.tk:8123/hw11-app:${params.Version}"
                    sh "ssh -o StrictHostKeyChecking=no -l root devops5 docker run -p 80:8080 -d --name hw11 nexus.rtru.tk:8123/hw11:${params.Version}"
                }
            }
        }
    }
}
