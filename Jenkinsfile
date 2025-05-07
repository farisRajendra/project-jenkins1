pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'laravel-app'
    }

    stages {
        stage('Check Docker Access') {
            steps {
                bat '''
                    echo "Checking Docker..."
                    docker --version || echo "Docker not found!"
                    where docker || echo "Docker not in PATH"
                '''
            }
        }

        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/farisRajendra/project-jenkins1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '''
                    echo "Building Docker image..."
                    docker build -t %DOCKER_IMAGE% . || echo "Build failed!"
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                bat '''
                    echo "Running container..."
                    docker stop laravel-container || exit 0
                    docker rm laravel-container || exit 0
                    docker run -d -p 8000:8000 --name laravel-container %DOCKER_IMAGE% || echo "Run failed!"
                '''
            }
        }
    }

    post {
        always {
            bat 'echo "Pipeline completed with status: %ERRORLEVEL%"'
        }
    }
}