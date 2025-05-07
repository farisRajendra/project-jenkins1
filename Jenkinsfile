pipeline {
    agent any
    
    environment {
        // Sesuaikan dengan nama image Docker Anda
        DOCKER_IMAGE = "laravel-app"
        DOCKER_TAG = "latest"
    }
    
    stages {
        // Stage 1: Clone repository
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/username/repo-laravel.git'
            }
        }
        
        // Stage 2: Install dependencies Laravel
        stage('Install Dependencies') {
            steps {
                script {
                    bat 'composer install --no-interaction --prefer-dist --optimize-autoloader'
                    bat 'npm install'
                    bat 'npm run prod'
                }
            }
        }
        
        // Stage 3: Build Docker image
        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .'
                }
            }
        }
        
        // Stage 4: Jalankan Laravel di Docker
        stage('Run Laravel') {
            steps {
                script {
                    // Hentikan container lama jika ada
                    bat 'docker-compose down || true'
                    
                    // Jalankan container baru
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