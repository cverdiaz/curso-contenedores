pipeline {
    agent any

    stages(){
        stage('Primer paso pipeline') {
             steps {
                sh 'Saludos desde el terminal'
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