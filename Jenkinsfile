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
        
        stage('Install Dependencies & Build') {
            steps {
                script {
                    // Gunakan Docker untuk instalasi dependencies
                    bat '''
                        docker run --rm -v %CD%:/app -w /app composer:latest composer install --no-interaction --prefer-dist --optimize-autoloader
                        docker run --rm -v %CD%:/app -w /app node:latest npm install
                        docker run --rm -v %CD%:/app -w /app node:latest npm run prod
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .'
                }
            }
        }
        
        stage('Run Laravel') {
            steps {
                script {
                    bat 'docker-compose down || true'
                    bat 'docker-compose up -d --build'
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