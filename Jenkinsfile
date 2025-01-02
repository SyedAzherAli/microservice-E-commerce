pipeline {
    agent any
    environment {
        NVD_API_KEY = credentials('NVD_API_KEY') 
        SONARQUBE_HOME = tool 'sonar-scanner'
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '654654355718'
        AWS_ECR_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        SERVICES = "adservice,cartservice,checkoutservice,currencyservice,emailservice,frontend,loadgenerator,paymentservice,productcatalogservice,recommendationservice,shippingservice"
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/SyedAzherAli/microservice-E-commerce.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                dir('src') {
                    withSonarQubeEnv('sonar') {
                        sh '''
                        $SONARQUBE_HOME/bin/sonar-scanner -Dsonar.projectName=microservice-application \
                        -Dsonar.projectKey=microservice-application -Dsonar.sources=. -Dsonar.java.binaries=adservice/gradle/wrapper
                        '''
                    }
                }
            }
        }
        stage("Quality Check") {
            steps {
                script {
                    def qualityGate = waitForQualityGate(credentialsId: 'sonar-token', id: 'microservice-application')
                    if (qualityGate.status != 'OK') {
                        error "Pipeline aborted due to quality gate failure: ${qualityGate.status}"
                    }
                }
            }
        }

        stage("OWASP Dependency Check") {
            steps { 
                dir('src') {
                    script {
                        def microservices = [
                            [name: 'frontend', path: './frontend'],
                            [name: 'productcatalogservice', path: './productcatalogservice'],
                            [name: 'shippingservice', path: './shippingservice'],
                            [name: 'checkoutservice', path: './checkoutservice'],
                            [name: 'emailservice', path: './emailservice'],
                            [name: 'recommendationservice', path: './recommendationservice'],
                            [name: 'shoppingassistantservice', path: './shoppingassistantservice'],
                            [name: 'loadgenerator', path: './loadgenerator'],
                            [name: 'currencyservice', path: './currencyservice'],
                            [name: 'paymentservice', path: './paymentservice'],
                            [name: 'adservice', path: './adservice'],
                            [name: 'cartservice', path: './cartservice/src']
                        ]

                        for (service in microservices) {
                            echo "Running Dependency Check for ${service.name}"
                            dependencyCheck additionalArguments: '--format ALL --failOnCVSS 7', 
                                            odcInstallation: 'DPcheck', 
                                            scanPath: service.path
                        }
                    }
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                }
            }
        }
        stage('Docker Build and Tag') {
            steps {
                dir('src') {
                    script {
                        def services = env.SERVICES.split(",") // Split the SERVICES variable into a list
                        services.each { service ->
                            sh """
                            sed -i 's|${AWS_ECR_URL}/${service}:.*|${AWS_ECR_URL}/${service}:v1.${env.BUILD_NUMBER}|g' docker-compose.yaml
                            """
                        }
                        sh 'docker-compose build'
                    }
                }
            }
        }
        stage("Trivy Scan") {
            steps {
                script {
                    def services = env.SERVICES.split(",") 
                    services.each { service ->
                        sh """
                        trivy image --exit-code 0 --severity HIGH,CRITICAL --format table -o ${service}.html ${AWS_ECR_URL}/${service}:v1.${BUILD_NUMBER}
                        """
                    }
                }
            }
        }
        stage('Docker Push') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR_URL}
                    cd src
                    docker-compose push
                    """
                }
            }
        }
        stage("GitOps Repository Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/SyedAzherAli/GitOps-manifest-files.git'
            }
        }
        stage('Update Kubernetes Manifests') {
            steps {
                dir('microservice-E-commerce') {
                    script {
                        withCredentials([string(credentialsId: 'git-token', variable: 'GITHUB_TOKEN')]) {
                            def services = env.SERVICES.split(",") 
                            services.each { service ->
                                sh """
                                sed -i 's|${AWS_ECR_URL}/${service}:.*|${AWS_ECR_URL}/${service}:v1.${env.BUILD_NUMBER}|g' kubernetes-manifests.yaml
                                """
                            }
                            sh '''
                            git config user.email "syedazherali01@gmail.com"
                            git config user.name "syedazherali"
                            git add kubernetes-manifests.yaml
                            git commit -m "Update deployment images to v1.${BUILD_NUMBER}"
                            git push https://${GITHUB_TOKEN}@github.com/SyedAzherAli/GitOps-manifest-files.git HEAD:main
                            '''
                        }
                    }
                }
            }
        }
    }
}
