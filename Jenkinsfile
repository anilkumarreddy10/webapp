pipeline {
    agent any

    tools {
        maven 'mvn'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }
        stage('Checkout') {
            steps {
                git credentialsId: 'git',
                    url: 'git@github.com:anilkumarreddy10/webapp.git'
            }
        }

        stage('Build') {
            steps {
                configFileProvider([
                    configFile(fileId: 'maven-settings', variable: 'SETTINGS')]) {

                    sh """
                    mvn -B release:clean release:prepare release:perform \
                    -Dmaven.test.failure.ignore=true \
                    -s ${SETTINGS}
                    """
                }
            }
        }
        stage('sonarqube') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('docker') {
            environment {
                REGISTRY = "docker.io/gangalakunta"
                IMAGE_TAG  = "latest"
                IMAGE_NAME = "my-java-app" 
            }
            steps {
                sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }
    }
}
