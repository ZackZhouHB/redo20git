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
        registry = "zackz001/redo20-e4-app"
        registryCredential = 'dockerhub'        
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

        stage('UNIT Test') {
            steps {
                sh 'mvn -s settings.xml test'
            }
        }

        stage('INTEGRATION TEST'){
            steps {
                sh 'mvn -s settings.xml verify -DskipUnitTests'
            }
        }

        stage('Checkstyle analysis') {
            steps {
                echo 'using maven shell cmd to run checkstyle'
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'Generated Analysis Result'
                }
            }            
        }

        stage('Building image') {
            steps{
              script {
                dockerImage = docker.build registry + ":$BUILD_NUMBER"
              }
            }
        }

        stage('Deploy Image') {
          steps{
            script {
              docker.withRegistry( '', registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
        }

        stage('Remove Unused docker image') {
          steps{
            sh "docker rmi $registry:$BUILD_NUMBER"
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

        stage('Kubernetes Deploy') {
	      agent { label 'KOPS' }
            steps {
                    sh "helm upgrade --install --force vproifle-stack helm/vprofilecharts --set appimage=${registry}:${BUILD_NUMBER} --namespace prod"
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