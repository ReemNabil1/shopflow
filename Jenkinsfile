pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO = "034255117476.dkr.ecr.us-east-1.amazonaws.com/shopflow-app"
        TAG = "latest"
        ASG_NAME = "terraform-20260510115643060300000007"
    }

    stages {

        stage('Checkout Code') {
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

        stage('Login to Amazon ECR') {
            steps {
                sh """
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin $ECR_REPO
                """
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh """
                docker push $ECR_REPO:$TAG
                """
            }
        }

        stage('Deploy - Instance Refresh') {
            steps {
                sh """
                aws autoscaling start-instance-refresh \
                --auto-scaling-group-name $ASG_NAME \
                --region $AWS_REGION
                """
            }
        }
    }

    post {
        success {
            echo "Deployment Successful - Pipeline Completed"
        }
        failure {
            echo "Pipeline Failed - Check Logs"
        }
    }
}
