pipeline {
    agent {
        docker {
            image 'nexus.rtru.tk:8123/hw11-builder:1.0'
            args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 120'
        }
    }

    stages {
        stage('Fetch and build') {
            steps {
                git 'https://github.com/LovingFox/boxfuse-sample-java-war-hello.git'
                sh "mvn package"
                sh """
                cat << _EOF_ > Dockerfile
                FROM adoptopenjdk/openjdk11:jre-11.0.6_10-alpine
                WORKDIR /opt/tomcat
                RUN wget -qO- https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.68/bin/apache-tomcat-9.0.68.tar.gz | tar xvz --strip-components 1
                COPY ./target/*.war /opt/tomcat/webapps/ROOT.war
                CMD ["/opt/tomcat/bin/catalina.sh", "run"]
                _EOF_
                """
                sh "docker build -t nexus.rtru.tk:8123/hw11-app:1.0 ."
            }
        }
    }
}
