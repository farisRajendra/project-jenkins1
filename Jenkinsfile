pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'laravel-app'
    }
    
    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/farisRajendra/project-jenkins1.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Menggunakan bat untuk Windows, bukan sh
                bat 'docker build -t %DOCKER_IMAGE% .'
            }
        }
        
        stage('Remove Existing Container') {
            steps {
                // Menghapus container yang sudah ada jika ada (ignore error jika tidak ada)
                bat 'docker stop laravel-container || true'
                bat 'docker rm laravel-container || true'
            }
        }
        
        stage('Run Docker Container') {
            steps {
                // Menggunakan bat untuk Windows, bukan sh
                bat 'docker run -d -p 8000:8000 --name laravel-container %DOCKER_IMAGE%'
            }
        }
    }
    
    post {
        failure {
            // Menampilkan logs Docker jika terjadi kegagalan
            bat 'docker logs laravel-container || true'
        }
    }
}