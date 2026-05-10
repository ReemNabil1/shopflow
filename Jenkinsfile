pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO = "034255117476.dkr.ecr.us-east-1.amazonaws.com/shopflow-app"
        TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ReemNabil1/shopflow.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t $ECR_REPO:$TAG -f app/Dockerfile app
                """
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-ecr-creds']]) {
                    sh """
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin 034255117476.dkr.ecr.us-east-1.amazonaws.com
                    """
                }
            }
        }

        stage('Push to ECR') {
            steps {
                sh """
                docker push $ECR_REPO:$TAG
                """
            }
        }

        stage('Deploy - ASG Refresh') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-ecr-creds']]) {
                    sh """
                    aws autoscaling start-instance-refresh \
                    --auto-scaling-group-name terraform-20260510103845170500000001 \
                    --region $AWS_REGION
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline Succeeded"
        }
        failure {
            echo "Pipeline Failed"
        }
    }
}
