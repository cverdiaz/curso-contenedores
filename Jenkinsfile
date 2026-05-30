pipeline {
    /*agent any*/  // Puedes usar 'any' para ejecutar en cualquier nodo disponible, o especificar un label para un nodo específico
    agent {
        label 'wsl' // Asegúrate de que este label coincida con el nodo que tiene Docker instalado
    }

    stages { // Aquí defines las etapas de tu pipeline|
        stage('Primer paso pipeline') { // Nombre de la etapa
             steps {  // Aquí defines los pasos que se ejecutarán en esta etapa
                sh 'echo Saludos desde el terminal'  // Comando para imprimir un mensaje en la terminal
            }
        }
        stage('Segundo paso pipeline') {
             steps {
                sh 'command -v node >/dev/null 2>&1 && node --version || echo "node no instalado en wsl"'
            }
        }
        stage('Tercer paso pipeline') {
             steps {
                sh 'docker ps'
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