pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "laravel-app"
        DOCKER_TAG = "latest"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/farisRajendra/project-jenkins1.git'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    // Gunakan sh untuk Linux/Unix
                    sh 'docker run --rm -v $(pwd):/app -w /app composer:latest composer install --no-interaction --prefer-dist --optimize-autoloader'
                    sh 'docker run --rm -v $(pwd):/app -w /app node:16 npm install'
                    sh 'docker run --rm -v $(pwd):/app -w /app node:16 npm run prod'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
        }
        
        stage('Run Laravel') {
            steps {
                script {
                    sh 'docker-compose down || true'
                    sh 'docker-compose up -d --build'
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Laravel berhasil di-deploy!'
            echo '🌐 Buka http://localhost:8000 untuk mengakses aplikasi.'
        }
        failure {
            echo '❌ Deployment gagal. Periksa log untuk detail error.'
        }
    }
}