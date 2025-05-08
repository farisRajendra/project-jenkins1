pipeline {
    // Gunakan node laravel-builder yang sudah dikonfigurasi
    agent {
        label 'laravel-builder'
    }
    
    environment {
        DOCKER_IMAGE = "laravel-app"
        DOCKER_TAG = "latest"
        COMPOSE_PROJECT_NAME = "laravel"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Prepare Environment') {
            steps {
                // Buat .env dari contoh jika belum ada
                script {
                    // Linux
                    sh '''
                        if [ ! -f .env ]; then
                            cp .env.example .env || echo "No .env.example found"
                            echo "APP_ENV=testing" >> .env
                        fi
                    '''
                    
                    // Windows (hapus komentar jika diperlukan)
                    /*
                    powershell '''
                        if (-not (Test-Path .env)) {
                            if (Test-Path .env.example) {
                                Copy-Item .env.example .env
                            } else {
                                Write-Output "No .env.example found"
                            }
                            Add-Content .env "APP_ENV=testing"
                        }
                    '''
                    */
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    // Linux
                    sh '''
                        docker run --rm -v ${PWD}:/app -w /app composer:latest composer install --no-interaction --prefer-dist --optimize-autoloader
                        docker run --rm -v ${PWD}:/app -w /app node:16 npm install
                        docker run --rm -v ${PWD}:/app -w /app node:16 npm run prod
                    '''
                    
                    // Windows (hapus komentar jika diperlukan)
                    /*
                    powershell '''
                        docker run --rm -v ${PWD}:/app -w /app composer:latest composer install --no-interaction --prefer-dist --optimize-autoloader
                        docker run --rm -v ${PWD}:/app -w /app node:16 npm install
                        docker run --rm -v ${PWD}:/app -w /app node:16 npm run prod
                    '''
                    */
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Linux
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                    
                    // Windows (hapus komentar jika diperlukan)
                    // powershell 'docker build -t ${env:DOCKER_IMAGE}:${env:DOCKER_TAG} .'
                }
            }
        }
        
        stage('Deploy Application') {
            steps {
                script {
                    // Linux
                    sh '''
                        docker-compose down || true
                        docker-compose up -d --build
                        
                        # Tunggu aplikasi siap
                        sleep 10
                        
                        # Jalankan migrasi database (opsional)
                        docker-compose exec -T app php artisan migrate --force || echo "Migration not needed or failed"
                        
                        # Hapus cache (opsional)
                        docker-compose exec -T app php artisan cache:clear || echo "Cache clear not needed"
                    '''
                    
                    // Windows (hapus komentar jika diperlukan)
                    /*
                    powershell '''
                        docker-compose down
                        docker-compose up -d --build
                        
                        # Tunggu aplikasi siap
                        Start-Sleep -s 10
                        
                        # Jalankan migrasi database (opsional)
                        docker-compose exec -T app php artisan migrate --force
                        
                        # Hapus cache (opsional)
                        docker-compose exec -T app php artisan cache:clear
                    '''
                    */
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    // Linux
                    sh '''
                        # Periksa status container
                        docker-compose ps
                        
                        # Tampilkan logs singkat
                        docker-compose logs --tail=20 app
                    '''
                    
                    // Windows (hapus komentar jika diperlukan)
                    /*
                    powershell '''
                        # Periksa status container
                        docker-compose ps
                        
                        # Tampilkan logs singkat
                        docker-compose logs --tail=20 app
                    '''
                    */
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
            
            // Tampilkan logs jika terjadi kegagalan
            script {
                sh 'docker-compose logs app || true'
            }
        }
        always {
            // Bersihkan workspace (opsional)
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true)
        }
    }
}