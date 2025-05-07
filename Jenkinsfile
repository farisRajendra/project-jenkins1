pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'laravel-app'
    }

    stages {
        stage('Test Basic Command') {
            steps {
                bat 'echo "Testing Windows command"'
                bat 'echo %PATH%'
            }
        }

        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/farisRajendra/project-jenkins1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %DOCKER_IMAGE% .'
            }
        }

        stage('Run Docker Container') {
            steps {
                bat '''
                    docker stop laravel-container || exit 0
                    docker rm laravel-container || exit 0
                    docker run -d -p 8000:8000 --name laravel-container %DOCKER_IMAGE%
                '''
            }
        }
    }

    post {
        always {
            bat 'echo "Pipeline completed"'
        }
    }
}