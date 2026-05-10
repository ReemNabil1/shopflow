pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR = "034255117476.dkr.ecr.us-east-1.amazonaws.com/shopflow-app"
        TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ReemNabil1/shopflow.git'
            }
        }

        stage('Build') {
            steps {
                sh "docker build -t $ECR:$TAG -f app/Dockerfile app"
            }
        }

        stage('Login ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin 034255117476.dkr.ecr.us-east-1.amazonaws.com
                '''
            }
        }

        stage('Push') {
            steps {
                sh "docker push $ECR:$TAG"
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                aws autoscaling start-instance-refresh \
                --auto-scaling-group-name terraform-20260510103845170500000001
                '''
            }
        }
    }
}
