pipeline {
    agent worker-node

    tools {
        maven 'mvn'
    }
    environment {
        REGISTRY = "docker.io/gangalakunta"
        IMAGE_TAG  = "latest"
        IMAGE_NAME = "my-java-app" 
        PROJECT_ID = 'project-820f02b7-4f02-4540-a71'
        CLUSTER_NAME = 'my-cluster'
        REGION = 'us-central1'
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
            steps {
                sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }
        stage('push image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                   sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                   sh "docker push ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }
        stage('connect to gke') {
            steps {
                sh "gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION"
            }
        }
        stage('deploy to gke') {
            steps {
                sh "kubectl apply -f Deployment.yaml"
            }
        }
    }
}
