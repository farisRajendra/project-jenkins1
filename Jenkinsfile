pipeline {
    // Gunakan node laravel-builder yang sudah dikonfigurasi
    agent {
        label 'master'
    }
    
    environment {
        DOCKER_IMAGE = "laravel-app"
        DOCKER_TAG = "${BUILD_NUMBER}-${GIT_COMMIT.substring(0,7)}"
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
                    sh '''
                        if [ ! -f .env ]; then
                            cp .env.example .env || echo "No .env.example found, creating new .env file"
                            echo "APP_ENV=testing" >> .env
                        fi
                    '''
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    sh '''
                        docker run --rm -v ${PWD}:/app -w /app composer:latest composer install --no-interaction --prefer-dist --optimize-autoloader
                        
                        # Generate Laravel APP_KEY jika belum ada
                        if ! grep -q "APP_KEY=" .env || grep -q "APP_KEY=$" .env; then
                            docker run --rm -v ${PWD}:/app -w /app php:8.1-cli php artisan key:generate --force
                        fi
                        
                        # Install dan build assets
                        docker run --rm -v ${PWD}:/app -w /app node:16 npm install
                        docker run --rm -v ${PWD}:/app -w /app node:16 npm run prod || docker run --rm -v ${PWD}:/app -w /app node:16 npm run build
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                    sh 'docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest'
                }
            }
        }
        
        stage('Deploy Application') {
            steps {
                script {
                    sh '''
                        # Matikan container yang sedang berjalan (jika ada)
                        docker-compose down || true
                        
                        # Jalankan container baru
                        docker-compose up -d --build
                        
                        # Tunggu aplikasi siap
                        echo "Menunggu aplikasi siap..."
                        sleep 10
                        
                        # Bersihkan cache dan optimasi (jika diperlukan)
                        docker-compose exec -T app php artisan cache:clear || echo "Cache clear failed"
                        docker-compose exec -T app php artisan config:cache || echo "Config cache failed"
                        docker-compose exec -T app php artisan route:cache || echo "Route cache failed"
                        docker-compose exec -T app php artisan view:cache || echo "View cache failed"
                    '''
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    sh '''
                        # Periksa status container
                        docker-compose ps
                        
                        # Verifikasi aplikasi berjalan
                        curl -s -I http://localhost:8000 | grep "HTTP/" || echo "Application may not be responding"
                        
                        # Tampilkan logs singkat
                        docker-compose logs --tail=20 app
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