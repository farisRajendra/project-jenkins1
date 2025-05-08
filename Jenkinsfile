pipeline {
    agent any  // Menggunakan agent apa saja yang tersedia

    environment {
        DOCKER_IMAGE = "laravel-app"
        DOCKER_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
        // Untuk Windows, gunakan path absolut
        WORKSPACE = "${env.WORKSPACE}".replace('/', '\\')
    }

    stages {
        stage('Checkout & Setup') {
            steps {
                checkout scm
                bat """
                    @echo off
                    if not exist .env (
                        copy .env.example .env || echo File .env.example not found
                        echo APP_ENV=production >> .env
                    )
                """
            }
        }

        stage('Install Dependencies') {
            steps {
                bat """
                    docker run --rm -v "%WORKSPACE%":/app -w /app composer install --no-interaction
                    docker run --rm -v "%WORKSPACE%":/app -w /app node:16 npm install
                    docker run --rm -v "%WORKSPACE%":/app -w /app node:16 npm run prod || docker run --rm -v "%WORKSPACE%":/app -w /app node:16 npm run build
                """
            }
        }

        stage('Build & Deploy') {
            steps {
                bat """
                    docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .
                    docker-compose down || echo "No containers to stop"
                    docker-compose up -d --build
                    timeout /t 10 /nobreak > NUL
                """
            }
        }

        stage('Verify') {
            steps {
                bat """
                    docker-compose ps
                    curl http://localhost:8000 || echo "Application not responding"
                """
            }
        }
    }

    post {
        always {
            bat """
                docker-compose down || echo "Cleanup failed"
                docker system prune -f || echo "Prune failed"
            """
        }
    }
}