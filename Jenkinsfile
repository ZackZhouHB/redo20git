pipeline {
    agent any
    tools { 
        maven "MAVEN3"
        jdk "OracleJDK8"
    } 

    environment {
        SNAP_REPO = 'vprofile-snapshot'
        NEXUS_USER = 'admin'
        NEXUS_PASS = 'admin123'
        RELEASE_REPO = 'vprofile-release'
        CENTRAL_REPO = 'vpro-maven-central'
        NEXUSIP = "172.31.11.87"
        NEXUSPORT = "8081"
        NEXUS_LOGIN = "nexuslogin"
        NEXUS_GRP_REPO = 'vpro-maven-group' 
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
                echo 'this stage run maven install to pass setting from pom.xml and settings.xml'
                echo 'then we need maven to dl dependency from nexus repo defined earlier'
                echo 'which specified in pom.xml'
                echo 'use var to define nexus repo id, port, ip'
                echo 'in setting.xml we have nsxus server details : each repo, user & passwd '
            }
            post {
                success {
                    echo "good job, use this archiveArtifacts plugin already installd"
                    echo "to achive everything ends with .war "
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage('Test') {
            steps {
                sh 'mvn -s settings.xml test'
            }
        }

        stage('Checkstyle analysis') {
            steps {
                echo 'using maven shell cmd to run checkstyle'
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
        }
    }
}