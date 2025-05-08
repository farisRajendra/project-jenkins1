pipeline {
    agent any
    
    environment {
        // Variabel lingkungan
        APP_NAME = "laravel_app"
        DOCKER_COMPOSE_VERSION = "1.29.2"
    }
    
    stages {
        stage('Checkout Kode') {
            steps {
                // Checkout kode dari repositori Git
                checkout scm
            }
        }
        
        stage('Persiapan Lingkungan') {
            steps {
                // Buat file .env dari .env.example
                script {
                    if (fileExists('.env.example')) {
                        sh 'cp .env.example .env'
                        // Update nilai-nilai variabel lingkungan sesuai kebutuhan
                        sh '''
                            sed -i 's/DB_HOST=127.0.0.1/DB_HOST=db/g' .env
                            sed -i 's/DB_DATABASE=laravel/DB_DATABASE=laravel_app/g' .env
                            sed -i 's/DB_USERNAME=root/DB_USERNAME=laravel_user/g' .env
                            sed -i 's/DB_PASSWORD=/DB_PASSWORD=laravel_password/g' .env
                        '''
                    } else {
                        error "File .env.example tidak ditemukan!"
                    }
                }
                
                // Generate application key
                sh 'docker run --rm -v ${PWD}:/var/www php:8.2-cli php /var/www/artisan key:generate'
            }
        }
        
        stage('Build dan Up Docker') {
            steps {
                // Pastikan Docker berjalan
                sh 'docker --version'
                
                // Build dan jalankan kontainer
                sh 'docker-compose build'
                sh 'docker-compose up -d'
            }
        }
        
        stage('Migrasi Database') {
            steps {
                // Jalankan migrasi database di dalam kontainer
                sh 'docker-compose exec -T app php artisan migrate --force'
            }
        }
        
        stage('Install Dependencies dan Build Assets') {
            steps {
                // Install PHP dependencies
                sh 'docker-compose exec -T app composer install --no-interaction --no-dev --optimize-autoloader'
                
                // Install Node.js dependencies dan build assets
                sh 'docker-compose exec -T app npm install'
                sh 'docker-compose exec -T app npm run build'
            }
        }
        
        stage('Cache Config dan Routes') {
            steps {
                // Optimasi Laravel
                sh 'docker-compose exec -T app php artisan config:cache'
                sh 'docker-compose exec -T app php artisan route:cache'
                sh 'docker-compose exec -T app php artisan view:cache'
            }
        }
        
        stage('Tests') {
            steps {
                // Jalankan pengujian Laravel
                sh 'docker-compose exec -T app php artisan test'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Aplikasi Laravel berhasil di-deploy dan berjalan pada http://localhost'
                
                // Opsional: tambahkan langkah-langkah deployment ke server produksi
                // Misalnya menggunakan rsync, scp, atau metode lainnya
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline berhasil dijalankan!'
        }
        failure {
            // Jika pipeline gagal, matikan kontainer Docker
            sh 'docker-compose down'
            echo 'Pipeline gagal! Kontainer Docker telah dimatikan.'
        }
        always {
            // Bersihkan workspace
            cleanWs()
        }
    }
}