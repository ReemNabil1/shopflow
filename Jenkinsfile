pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ACCOUNT_ID = "034255117476"
        ECR = "034255117476.dkr.ecr.us-east-1.amazonaws.com/shopflow-app"
        TAG = "latest"
        ASG_NAME = "terraform-20260510103845170500000001"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ReemNabil1/shopflow.git'
            }
        }

        stage('Build') {
            steps {
                sh """
                docker build -t ${ECR}:${TAG} -f app/Dockerfile app
                """
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region us-east-1 | \
                docker login --username AWS --password-stdin 034255117476.dkr.ecr.us-east-1.amazonaws.com
                """
            }
        }

        stage('Push') {
            steps {
                sh """
                docker push ${ECR}:${TAG}
                """
            }
        }

        stage('Deploy') {
            steps {
                sh """
                aws autoscaling start-instance-refresh \
                --auto-scaling-group-name ${ASG_NAME}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful"
        }
        failure {
            echo "❌ Pipeline Failed"
        }
    }
}
