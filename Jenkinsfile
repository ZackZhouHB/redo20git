def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

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
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner' 
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

        stage('Sonar Analisys') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                    echo 'understand sonarscanner for jenkins'
                    echo 'search google sonar scanner with jenkins'
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                    -Dsonar.projectName=vprofile \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                    -Dsonar.junit.reportsPath=target/surefire-reports/ \
                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }

        stage("Upload Artifact") {
            steps {
                echo 'version and upload artifact to nexus'
                echo 'use plugin nexusArtifactUploader with timestamp rename .war every new build'
                echo 'google nexusArtifactUploader plugin for example code for jenkins pipeline change bellow'
                echo 'create folder QA, use defalet jenkins built-in vars in version'
                echo ''
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                    groupId: 'QA',
                    version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                    repository: "${RELEASE_REPO}",
                    credentialsId: "${NEXUS_LOGIN}",
                    artifacts: [
                        [artifactId: 'vproapp',
                        classifier: '',
                        file: 'target/vprofile-v2.war',
                        type: 'war']
                        ]
                    )
            }
        }        
    }
    post {
        always {
            echo 'Slack Notification.'
            echo 'enable slack workspace "zackci" and slack channel "#cidi" '
            echo 'configure slack to enable jenkinsci app, get token store in jenkins system, test'
            echo 'use jenkins global var "currentBuild" and "currentResult" to define result of pipeline'
            echo 'use def on top for color '
            slackSend channel: '#cidi',
            color: COLOR_MAP[currentBuild.currentResult],
            message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }
}