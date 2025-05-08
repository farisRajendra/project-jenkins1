pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "laravel-app"
        DOCKER_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
    }

    stages {
        stage('Checkout & Setup') {
            steps {
                checkout scm
                script {
                    if (isUnix()) {
                        sh '''
                            if [ ! -f .env ]; then
                                cp .env.example .env || echo "No .env.example found"
                                echo "APP_ENV=production" >> .env
                            fi
                        '''
                    } else {
                        bat '''
                            if not exist .env (
                                copy .env.example .env || echo No .env.example found
                                echo APP_ENV=production >> .env
                            )
                        '''
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            docker run --rm -v ${PWD}:/app -w /app composer install --no-interaction
                            docker run --rm -v ${PWD}:/app -w /app node:16 npm install
                            docker run --rm -v ${PWD}:/app -w /app node:16 npm run prod || docker run --rm -v ${PWD}:/app -w /app node:16 npm run build
                        '''
                    } else {
                        bat '''
                            docker run --rm -v "%cd%":/app -w /app composer install --no-interaction
                            docker run --rm -v "%cd%":/app -w /app node:16 npm install
                            docker run --rm -v "%cd%":/app -w /app node:16 npm run prod || docker run --rm -v "%cd%":/app -w /app node:16 npm run build
                        '''
                    }
                }
            }
        }

        stage('Build & Deploy') {
            steps {
                script {
                    if (isUnix()) {
                        sh """
                            docker build -t ${env.DOCKER_IMAGE}:${env.DOCKER_TAG} .
                            docker-compose down || true
                            docker-compose up -d --build
                            sleep 10
                        """
                    } else {
                        bat """
                            docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .
                            docker-compose down || echo "No containers to stop"
                            docker-compose up -d --build
                            timeout /t 10 /nobreak > NUL
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                if (isUnix()) {
                    sh 'docker-compose down || true'
                    sh 'docker system prune -f || true'
                } else {
                    bat 'docker-compose down || echo "Cleanup failed"'
                    bat 'docker system prune -f || echo "Prune failed"'
                }
            }
        }
    }
}