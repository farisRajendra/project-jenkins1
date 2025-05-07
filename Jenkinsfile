pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'laravel-app'
    }
    
    stages {
        stage('Diagnostics') {
            steps {
                // Periksa environment
                bat 'echo %PATH%'
                bat 'where docker || echo Docker tidak ditemukan di PATH'
                bat 'systeminfo | findstr /B /C:"OS Name" /C:"OS Version"'
                
                // Periksa status Docker
                bat '"C:\\Program Files\\Docker\\Docker\\resources\\bin\\docker" --version || echo Docker tidak dapat diakses'
                bat '"C:\\Program Files\\Docker\\Docker\\resources\\bin\\docker" info || echo Docker daemon tidak berjalan'
            }
        }
        
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/farisRajendra/project-jenkins1.git'
            }
        }
        
        stage('Check Dockerfile') {
            steps {
                // Verifikasi Dockerfile ada
                bat 'dir'
                bat 'type Dockerfile || echo Dockerfile tidak ditemukan'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Coba build dengan berbagai sintaks
                bat '''
                echo === Mencoba Build Docker ===
                "C:\\Program Files\\Docker\\Docker\\resources\\bin\\docker" build -t %DOCKER_IMAGE% . || echo Build gagal dengan sintaks 1
                '''
            }
        }
    }
}