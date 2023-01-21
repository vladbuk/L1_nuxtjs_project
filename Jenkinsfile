pipeline {
  agent { label: agent-ut-sonar }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-access-token')
    }
    stages {
        stage('Building') {
            steps {
                echo 'Building'
                cleanWs()
                //sh 'rm -rf dist node_modules'
                git branch: 'docker', url: 'https://github.com/vladbuk/L1_nuxtjs_project.git'
                sh 'docker build --platform linux/amd64 -t vladbuk/nuxt-docker:${BUILD_NUMBER} -f Dockerfile_deploy .'
            }
        }
        stage('Pushing') {
            steps {
                echo 'Pushing'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push vladbuk/nuxt-docker:${BUILD_NUMBER}'
            }
        }
        
        stage('Deploying') {
            steps {
                script{
                    command='''
                        mkdir -p ${HOME}/nuxt-docker && cd ${HOME}/nuxt-docker/
                        docker pull vladbuk/nuxt-docker:${BUILD_NUMBER}

                        CONTAINER_ID=$(docker ps -aqf name=nuxt-docker)
                        if [[ $CONTAINER_ID ]]
                        then
                            docker rm -f $CONTAINER_ID
                            echo "Container $CONTAINER_ID deleted and will be created again."
                            docker run -d -t --name nuxt-docker --restart always -p 8080:8080 vladbuk/nuxt-docker:${BUILD_NUMBER}
                        else
                            echo -e "Container does not exist. It will be created.\n"
                            docker run -d -t --name nuxt-docker --restart always -p 8080:8080 vladbuk/nuxt-docker:${BUILD_NUMBER}
                        fi
                        CONTAINER_ID=$CONTAINER_ID
                        echo -e "Container id = $CONTAINER_ID\n"
                        docker image prune -f
                    '''
              
                    // Copy file to remote server 
                    sshPublisher(publishers: [sshPublisherDesc(configName: 't2micro_ubuntu_test', verbose: 'true',
                    transfers: [ sshTransfer(flatten: false,
                        //remoteDirectory: '/',
                        //sourceFiles: 'dist.zip',
                        execCommand: command
                        )])
                    ])
                }
            }
        }
    }
    post {
        always {
            sh 'docker logout'
    }
  }
}
