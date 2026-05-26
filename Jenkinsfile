pipeline {
    agent any

    stages(){
        stage('Primer paso pipeline') {
             steps {
                sh 'echo Saludos desde el terminal'
            }
        }
        stage('Segundo paso pipeline') {
             steps {
                sh 'node --version'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                // Add your test commands here
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                // Add your deploy commands here
            }
        }
    }
}