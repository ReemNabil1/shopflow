pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ACCOUNT_ID = "034255117476"
        ECR_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/shopflow-app"
        TAG = "latest"
        ASG_NAME = "terraform-20260510103845170500000001"
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
                sh """
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                """
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
                sh """
                aws autoscaling start-instance-refresh \
                --auto-scaling-group-name $ASG_NAME
                """
            }
        }
    }

    post {
        success {
            echo "🚀 Deployment Successful"
        }

        failure {
            echo "❌ Pipeline Failed"
        }
    }
}
