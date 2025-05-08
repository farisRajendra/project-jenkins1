pipeline {
    agent {
        docker {
            image 'docker:dind'  // Docker-in-Docker untuk build Docker
            args '-v /var/run/docker.sock:/var/run/docker.sock --privileged'
            label 'master || built-in'  # Fallback ke node master jika label tidak ada
        }
    }

    environment {
        DOCKER_IMAGE = "laravel-app"
        DOCKER_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
    }

    stages {
        stage('Checkout & Setup') {
            steps {
                checkout scm
                sh '''
                    cp .env.example .env || true
                    echo "APP_ENV=production" >> .env
                '''
            }
        }

        stage('Build Laravel') {
            steps {
                sh '''
                    docker run --rm -v ${PWD}:/app composer install --no-interaction
                    docker run --rm -v ${PWD}:/app node:16 npm install && npm run prod
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker-compose down || true
                    docker-compose up -d
                """
            }
        }
    }

    post {
        always {
            sh 'docker system prune -f || true'  # Bersihkan Docker
        }
    }
}