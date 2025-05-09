pipeline {
    agent any
    
    environment {
        // Variabel lingkungan
        APP_NAME = "laravel_app"
        // WSL path untuk Docker
        WSL_PATH = "\\\\wsl.localhost\\docker-desktop"
    }
    
    stages {
        stage('Checkout Kode') {
            steps {
                // Checkout kode dari repositori Git
                checkout scm
                
                // Cek Docker tersedia
                bat 'docker --version || echo "Docker tidak tersedia"'
                bat 'docker-compose --version || echo "Docker Compose tidak tersedia"'
            }
        }
        
        stage('Persiapan Lingkungan') {
            steps {
                // Buat file .env dari .env.example
                script {
                    if (fileExists('.env.example')) {
                        bat 'copy .env.example .env'
                        
                        // Sesuaikan file .env untuk Windows menggunakan PowerShell
                        powershell '''
                            (Get-Content .env) | 
                            ForEach-Object { $_ -replace "DB_HOST=127.0.0.1", "DB_HOST=db" } |
                            ForEach-Object { $_ -replace "DB_DATABASE=laravel", "DB_DATABASE=laravel_app" } |
                            ForEach-Object { $_ -replace "DB_USERNAME=root", "DB_USERNAME=laravel_user" } |
                            ForEach-Object { $_ -replace "DB_PASSWORD=", "DB_PASSWORD=laravel_password" } |
                            Set-Content .env
                        '''
                    } else {
                        error "File .env.example tidak ditemukan!"
                    }
                }
                
                // Generate application key menggunakan Docker dengan WSL path
                script {
                    try {
                        // Konversi Windows path ke WSL path
                        def workspacePath = pwd().replace("\\", "/").replace("C:", "/mnt/c")
                        bat "docker run --rm -v \"${workspacePath}:/var/www\" php:8.2-cli php /var/www/artisan key:generate"
                    } catch (Exception e) {
                        echo "Error saat generate key dengan path standar: ${e.message}"
                        echo "Mencoba dengan alternatif path WSL..."
                        
                        // Alternatif mounting untuk WSL
                        bat "docker run --rm -v \"%CD%:/var/www\" php:8.2-cli php /var/www/artisan key:generate"
                    }
                }
            }
        }
        
        stage('Build dan Deploy') {
            steps {
                // Build dan jalankan kontainer
                script {
                    try {
                        // Gunakan opsi -f jika docker-compose.yml tidak di root
                        if (fileExists('docker-compose.yml')) {
                            bat 'docker-compose build'
                            bat 'docker-compose up -d'
                        } else if (fileExists('docker/docker-compose.yml')) {
                            bat 'docker-compose -f docker/docker-compose.yml build'
                            bat 'docker-compose -f docker/docker-compose.yml up -d'
                        } else {
                            error "docker-compose.yml tidak ditemukan!"
                        }
                        
                        echo 'Aplikasi Laravel berhasil di-deploy dan berjalan pada http://localhost'
                    } catch (Exception e) {
                        error "Gagal melakukan build dan deploy: ${e.message}"
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline berhasil dijalankan!'
        }
        failure {
            // Jika pipeline gagal, coba matikan kontainer Docker
            script {
                try {
                    if (fileExists('docker-compose.yml')) {
                        bat 'docker-compose down || echo "Tidak dapat menjalankan docker-compose down"'
                    } else if (fileExists('docker/docker-compose.yml')) {
                        bat 'docker-compose -f docker/docker-compose.yml down || echo "Tidak dapat menjalankan docker-compose down"'
                    }
                } catch (Exception e) {
                    echo "Gagal menjalankan docker-compose down: ${e.message}"
                }
            }
            echo 'Pipeline gagal! Mencoba mematikan kontainer Docker.'
        }
        always {
            // Bersihkan workspace
            cleanWs()
            
            // Menampilkan Docker container yang sedang berjalan
            bat 'docker ps || echo "Tidak dapat menampilkan container yang berjalan"'
        }
    }
}