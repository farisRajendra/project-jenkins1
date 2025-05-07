pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'laravel-app'
    }

    stages {
        stage('Test Basic Command') {
            steps {
                sh 'echo "Testing Shell command"'
                sh 'echo $PATH'
            }
        }

        stage('Clone Repo') {
            steps {
                sh 'git clone -b main https://github.com/farisRajendra/project-jenkins1.git .'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                    docker stop laravel-container || true
                    docker rm laravel-container || true
                    docker run -d -p 8000:8000 --name laravel-container $DOCKER_IMAGE
                '''
            }
        }
    }

    post {
        always {
            sh 'echo "Pipeline completed"'
        }
    }
}
