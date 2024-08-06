pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "akshay2001a/nodejs-app"
        DOCKER_CREDENTIALS_ID = "dockerhub-credentials"
        GIT_CREDENTIALS_ID = "36ff0bcd-3a76-47d6-a5a7-7315f966b7ba"
        GIT_REPO = "https://github.com/akshayviola/nodejs-app-helm-flux.git"
        HELM_CHART_PATH = "charts/nodejs-app"
        DOCKERFILE_PATH = "nodejs-app/Dockerfile"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        def app = docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}", "-f ${DOCKERFILE_PATH} nodejs-app")
                        app.push("latest") 
                        app.push("${env.BUILD_ID}") 
                    }
                }
            }
        }
        stage('Update Helm Chart') {
            steps {
                script {
                    sh "sed -i 's/tag:.*/tag: \"${env.BUILD_ID}\"/' ${HELM_CHART_PATH}/values.yaml"
                    
                    sh "git config --global user.email 'akshaysunil201@gmail.com'"
                    sh "git config --global user.name 'akshayviola'"
                    
                    withCredentials([usernamePassword(credentialsId: GIT_CREDENTIALS_ID, usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                        sh "git remote set-url origin https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/akshayviola/nodejs-app-helm-flux.git"
                        sh "git add ${HELM_CHART_PATH}/values.yaml"
                        sh "git commit -m 'Update Helm chart image tag to ${env.BUILD_ID}'"
                        sh "git push origin HEAD:main"
                    }
                }
            }
        }
        stage('Restart Kubernetes Deployment') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                    script {
                        sh "kubectl --kubeconfig=${KUBECONFIG_FILE} rollout restart deployment nodejs-app -n flux-system"
                    }
                }
            }
        }
    }
}
