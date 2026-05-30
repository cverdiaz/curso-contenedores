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
        stage('Segundo paso pipeline') { //permite correrotar comandos de node dentro del agente con docker instalado
            agent {
                label 'docker-container' // Asegúrate de que este label coincida con el nodo que tiene Docker instalado
            }
             steps {
                sh 'node --version'
            }
        }
        stage('Tercer paso pipeline') { //permite correr comandos de docker dentro del agente con label wsl
             steps {
                sh 'docker ps'
            }
        }
        stage('Cuarto paso pipeline') { //permite correr comandos de docker dentro del agente con label wsl
            agent {
                docker {
                    image 'node:22' // Usa la imagen de Docker que deseas ejecutar
                    label 'wsl'
                    //args '-v /var/run/docker.sock:/var/run/docker.sock' // Monta el socket de Docker para permitir la comunicación con el daemon de Docker
                }
            }
             steps {
                sh 'node --version' // Comando para verificar la versión de Node.js dentro del contenedor Docker
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