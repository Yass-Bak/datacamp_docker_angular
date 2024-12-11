pipeline {
    agent any
    environment {
        DOCKER_TAG = getVersion()
    }
    stages {
        stage('Clone Stage') {
            steps {
                git 'https://github.com/Yass-Bak/datacamp_docker_angular.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        sh 'docker build -t yasinbk/angular-app:${DOCKER_TAG} .'
                    } catch (Exception e) {
                        error("Docker build failed: ${e.message}")
                    }
                }
            }
        }
        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASSWORD')]) {
                        try {
                            sh 'echo $DOCKER_PASSWORD | docker login -u yasinbk --password-stdin'
                            sh 'docker tag yasinbk/angular-app:${DOCKER_TAG} yasinbk/angular-app:${DOCKER_TAG}'
                            sh 'docker push yasinbk/angular-app:${DOCKER_TAG}'
                        } catch (Exception e) {
                            error("Failed to push Docker image: ${e.message}")
                        }
                    }
                }
            }
        }
        stage('Deploy to VM') {
            steps {
                script {
                    sshagent(['VM_SSH']) {
                        try {
                            // Test SSH connection
                            sh "ssh -o StrictHostKeyChecking=no -p 2222 vm3@127.0.0.1 'echo Connected successfully'"
                            
                            // Deploy the Docker image to VM
                            sh """
                            ssh -o StrictHostKeyChecking=no -p 2222 vm3@127.0.0.1 'docker pull yasinbk/angular-app:${DOCKER_TAG}'
                            ssh -o StrictHostKeyChecking=no -p 2222 vm3@127.0.0.1 'docker stop angular-app || true'
                            ssh -o StrictHostKeyChecking=no -p 2222 vm3@127.0.0.1 'docker rm angular-app || true'
                            ssh -o StrictHostKeyChecking=no -p 2222 vm3@127.0.0.1 'docker run -d --name angular-app -p 8080:80 yasinbk/angular-app:${DOCKER_TAG}'
                            """
                        } catch (Exception e) {
                            error("Deployment to VM failed: ${e.message}")
                        }
                    }
                }
            }
        }
    }
}

def getVersion() {
    return sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
}
