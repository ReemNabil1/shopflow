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

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $ECR:$TAG -f app/Dockerfile app"
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([[
                    $class: 'UsernamePasswordMultiBinding',
                    credentialsId: 'aws-ecr-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws configure set region $AWS_REGION

                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin 034255117476.dkr.ecr.us-east-1.amazonaws.com
                    '''
                }
            }
        }

        stage('Push to ECR') {
            steps {
                sh "docker push $ECR:$TAG"
            }
        }

        stage('Deploy - ASG Refresh') {
            steps {
                sh '''
                aws autoscaling start-instance-refresh \
                --auto-scaling-group-name terraform-20260510103845170500000001
                '''
            }
        }
    }
}
