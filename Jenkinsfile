pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup Environment') {
            steps {
                script {
                    if (!fileExists('.env')) {
                        sh 'cp .env.example .env || echo "No .env.example found"'
                        sh 'echo "APP_ENV=production" >> .env'
                        sh 'echo "APP_DEBUG=false" >> .env'
                    }
                }
            }
        }
        
        stage('Build Docker Images') {
            steps {
                sh 'docker-compose -f docker-compose.yml build'
            }
        }
        
        stage('Deploy Application') {
            steps {
                sh 'docker-compose -f docker-compose.yml up -d'
                sh 'docker exec laravel-app php artisan key:generate'
                sh 'docker exec laravel-app php artisan config:cache'
                sh 'docker exec laravel-app php artisan migrate --force || echo "No migrations to run"'
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
            sh 'docker-compose -f docker-compose.yml logs || true'
        }
        cleanup {
            // Cleanup workspace if needed
            cleanWs()
        }
    }
}