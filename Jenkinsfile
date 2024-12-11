pipeline {
    agent any

    environment {
        DOCKER_TAG = getVersion()
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git 'https://github.com/Yass-Bak/datacamp_docker_angular.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t yasinbk/angular-app:${DOCKER_TAG} .'
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u yasinbk --password-stdin'
                }
                sh 'docker tag yasinbk/angular-app:${DOCKER_TAG} yasinbk/angular-app:${DOCKER_TAG}'
                sh 'docker push yasinbk/angular-app:${DOCKER_TAG}'
            }
        }

        stage('Deploy to VM') {
            steps {
                script {
                    // Commandes SSH pour déployer l'image Docker sur la VM
                    sh "ssh -o StrictHostKeyChecking=no -p 2222 vm3@127.0.0.1 'docker pull yasinbk/angular-app:${DOCKER_TAG}'"
                    sh "ssh -o StrictHostKeyChecking=no -p 2222 vm3@127.0.0.1 'docker stop angular-app || true'"
                    sh "ssh -o StrictHostKeyChecking=no -p 2222 vm3@127.0.0.1 'docker rm angular-app || true'"
                    sh "ssh -o StrictHostKeyChecking=no -p 2222 vm3@127.0.0.1 'docker run -d --name angular-app -p 8080:80 yasinbk/angular-app:${DOCKER_TAG}'"
                }
            }
        }
    }
}

// Fonction pour récupérer la version de l'image Docker basée sur le commit Git
def getVersion() {
    return sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
}
