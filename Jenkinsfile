pipeline {
    parameters {
        string(name: "builderVersion", defaultValue: "1.0")
        string(name: "appVersion", defaultValue: "1.0")
        string(name: "appTemplateVersion", defaultValue: "1.0")
    }

    agent any

    stages {
        stage('Get docker socket group') {
            steps {
                script {
                    DOCKER_GROUP = sh(returnStdout: true, script: 'stat -c %g /var/run/docker.sock').trim()
                }
            }
        }
        stage('Fetch, build, push and local remove') {
            agent {
                docker {
                    image "nexus.rtru.tk:8123/hw11-builder:${params.builderVersion}"
                    registryUrl 'https://nexus.rtru.tk:8123/'
                    registryCredentialsId '678de0e5-da9b-4305-bcf5-1f10f46f8246'
                    args "-v /var/run/docker.sock:/var/run/docker.sock --group-add ${DOCKER_GROUP}"
                }
            }
            steps {
                git 'https://github.com/LovingFox/boxfuse-sample-java-war-hello.git'
                sh "mvn package"
                sh "echo FROM nexus.rtru.tk:8123/hw11-app-template:${params.appTemplateVersion} > Dockerfile"
                sh "echo RUN rm -rf /opt/tomcat/webapps/ROOT >> Dockerfile"
                sh "echo COPY ./target/*.war /opt/tomcat/webapps/ROOT.war >> Dockerfile"
                sh "docker build -t nexus.rtru.tk:8123/hw11-app:${params.appVersion} ."
                sh "docker push nexus.rtru.tk:8123/hw11-app:${params.appVersion}"
                sh "docker rmi nexus.rtru.tk:8123/hw11-app:${params.appVersion}"
            }
        }

        stage('Deploy at devops5') {
            steps {
                sshagent(['77e6ac01-81f8-45ac-9b89-d91f5dbdd25f']) {
                    sh 'ssh -o StrictHostKeyChecking=no -l root devops5 \'for ID in $(docker ps -q); do docker stop $ID; done\''
                    sh 'ssh -o StrictHostKeyChecking=no -l root devops5 \'for ID in $(docker ps -a -q); do docker rm $ID; done\''
                    sh 'ssh -o StrictHostKeyChecking=no -l root devops5 \'for ID in $(docker images -q); do docker rmi $ID; done\''
                    sh "ssh -o StrictHostKeyChecking=no -l root devops5 docker pull nexus.rtru.tk:8123/hw11-app:${params.appVersion}"
                    sh "ssh -o StrictHostKeyChecking=no -l root devops5 docker run -p 80:8080 -d --name hw11 nexus.rtru.tk:8123/hw11-app:${params.appVersion}"
                }
            }
        }
    }
}
