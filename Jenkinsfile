pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'laravel-app'
    }
    
    stages {
        stage('Test Basic Command') {
            steps {
                // Tes perintah Windows dasar
                powershell 'Write-Host "Testing PowerShell command"'
                powershell 'Write-Host $env:PATH'
            }
        }
        
        stage('Clone Repo') {
            steps {
                // Clone menggunakan sintaks powershell
                powershell 'git clone -b main https://github.com/farisRajendra/project-jenkins1.git .'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Gunakan powershell untuk memanggil Docker
                powershell 'docker build -t $env:DOCKER_IMAGE .'
            }
        }
        
        stage('Run Docker Container') {
            steps {
                // Hentikan dan hapus container yang mungkin sudah ada
                powershell 'docker stop laravel-container 2>$null; docker rm laravel-container 2>$null'
                
                // Jalankan container baru
                powershell 'docker run -d -p 8000:8000 --name laravel-container $env:DOCKER_IMAGE'
            }
        }
    }
    
    post {
        always {
            // Informasi status
            powershell 'Write-Host "Pipeline completed"'
        }
    }
}