pipeline {
    agent none // No se asigna un agente global, cada etapa puede definir su propio agente

    stages {
        stage('CI - nuestra aplicacion de contenedores') {
            agent {
                docker {
                    /*
                    si quisiera instalar las dependencias npm dentro de un contenedor docker, tendría que usar esta configuración para montar el socket de docker y así poder ejecutar comandos de docker dentro del contenedor, pero para esto es necesario aumentar el número de ejecuciones a 2 o más en el nodo con label wsl para que se ejecute en un nodo diferente al del tercer paso
                    image 'node:24' // Usa la imagen de Docker que deseas ejecutar
                    label 'wsl' // Asegúrate de que este label coincida con el nodo que tiene Docker instalado
                    args '-v /var/run/docker.sock:/var/run/docker.sock' // Monta el socket de Docker para permitir la comunicación con el daemon de Docker
                    */
                    image 'ghcr.io/pnpm/pnpm:latest' // Usa la imagen de Docker que deseas ejecutar
                    label 'docker' // Asegúrate de que este label coincida con el nodo que tiene Docker instalado
                }
            }
            stages {
                stage('CI - Configuracion de pnpm y node') {
                    steps {
                        sh '''
                            echo "Instalando dependencias..."
                            pnpm runtime set node 24 -g
                            pnpm --version
                        '''
                    }
                }
                stage('CI - Instalacion de dependencias') {
                    steps {
                        sh '''
                            pnpm install
                        '''
                    }
                }
                stage('CI - Revisión de Linter') {
                    steps {
                        sh '''
                            echo "Revisando linter..."
                            pnpm run lint
                        '''
                    }
                }
                stage('CI - Ejecución de Build') {
                    steps {
                        sh '''
                            echo "Ejecutando build..."
                            pnpm run build
                        '''
                    }
                }
            }
        }
    }
}