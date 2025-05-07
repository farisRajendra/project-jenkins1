pipeline {
    // Gunakan agent dengan label docker-windows
    agent {
        label 'docker-windows'
    }
    
    environment {
        DOCKER_IMAGE = "laravel-app"
        DOCKER_TAG = "latest"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    // Gunakan PowerShell untuk menjalankan perintah Docker
                    powershell '''
                        docker run --rm -v ${PWD}:/app -w /app composer:latest composer install --no-interaction --prefer-dist --optimize-autoloader
                        docker run --rm -v ${PWD}:/app -w /app node:16 npm install
                        docker run --rm -v ${PWD}:/app -w /app node:16 npm run prod
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    powershell 'docker build -t ${env:DOCKER_IMAGE}:${env:DOCKER_TAG} .'
                }
            }
        }
        
        stage('Run Laravel') {
            steps {
                script {
                    powershell '''
                        docker-compose down
                        docker-compose up -d --build
                    '''
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