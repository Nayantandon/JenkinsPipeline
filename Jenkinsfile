pipeline {
    agent any
    environment {
                DOCKER_IMAGE = "nayandockerrepos/jenkinspipeline:${BUILD_NUMBER}"
            }
    stages {
        stage('Clean Reports') {
            steps {
                echo '********* Cleaning Workspace Stage Started **********'
                // Add steps to clean the workspace here
                echo '********* Cleaning Workspace Stage Finished **********'
            }
        }
    
        stage('Build Stage') {
            steps {
                echo '********* Build Stage Started **********'
                // Add steps to build the application here
                // sh 'python3 -m venv env'
               //  sh 'source env/bin/activate'
              //   sh 'pip install requests'
                 //sh 'pip install --use-pep517 xmlrunner'
                // sh 'pip install --use-pep517 Flask'
                 sh 'pyinstaller --onefile app.py'
                echo '********* Build Stage Finished **********'
            }
        }
        
        stage('Docker image creation and push') {
            
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                    def dockerImage = docker.image("${DOCKER_IMAGE}")
                    docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                        dockerImage.push()
                    }
                }
            }  
        }
        stage('Inject Docker Image into deployment.yaml') {
            steps {
                script {
                    // Define the path to your deployment.yaml file
                    def deploymentYamlFile = "deployment.yaml"

                    // Use sed to replace placeholder with DOCKER_IMAGE value
                    sh "sed -i 's|<your-docker-image>|${DOCKER_IMAGE}|g' ${deploymentYamlFile}"
                }
            }
        }
        
        stage('Deploy Stage') {
            steps {
                script {
                     sh "docker run -p 8081:5000 -d ${DOCKER_IMAGE}"
                }
            }
        }
    }
}
