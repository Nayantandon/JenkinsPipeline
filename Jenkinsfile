pipeline {
    agent any
    stages {
        stage('Clean Reports') {
            steps {
                echo '********* Cleaning Workspace Stage Started **********'
                
                echo '********* Cleaning Workspace Stage Finished **********'
            }
        }
    
        stage('Build Stage') {
            steps {
                echo '********* Build Stage Started **********'
                sh 'python3 -m venv venv'
                sh '.\\venv\\Scripts\\activate'
                sh 'pip install -r requirements.txt'
                sh 'pyinstaller --onefile app.py'
                echo '********* Build Stage Finished **********'
            }
        }
        
        stage('Docker image creation and push') {
            environment {
                DOCKER_IMAGE = "nayandockerrepos/jenkinspipeline:${BUILD_NUMBER}"
            }
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
        
        stage('Deploy Stage') {
            steps {
                script {
                    def deployYaml = '''
                        apiVersion: apps/v1
                        kind: Deployment
                        metadata:
                          name: myapp
                          labels:
                            app: myapp
                        spec:
                          replicas: 3
                          selector:
                            matchLabels:
                              app: myapp
                          template:
                            metadata:
                              labels:
                                app: myapp
                            spec:
                              containers:
                              - name: myapp
                                image: ${DOCKER_IMAGE}
                                ports:
                                - containerPort: 8080  # Application listens on port 8080 within the container
                        ---
                        apiVersion: v1
                        kind: Service
                        metadata:
                          name: myapp
                          labels:
                            app: myapp
                        spec:
                          ports:
                          - port: 8081  # Expose port 8081 on the host
                            targetPort: 8080
                          selector:
                            app: myapp
                    '''
                    writeFile file: 'deploy.yaml', text: deployYaml
                    sh "kubectl apply -f deploy.yaml"
                }
            }
        }
    }
}
