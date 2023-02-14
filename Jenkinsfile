pipeline {
    agent {
        label 'agent-ut-wpprod'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-access-token')
    }
    stages {
        stage('Building') {
            steps {
                echo 'Building stage'
                cleanWs()
                //sh 'rm -rf dist node_modules'
                git branch: 'test', credentialsId: 'vladbuk-github', url: 'git@github.com:vladbuk/L1_nuxtjs_project.git'
                sh '''
                  docker build -t vladbuk/nuxt-docker:test-${BUILD_NUMBER} -f Dockerfile_deploy .
                  docker tag vladbuk/nuxt-docker:test-${BUILD_NUMBER} vladbuk/nuxt-docker:latest
                  '''
            }
        }

        stage('Pushing') {
            steps {
                echo 'Pushing stage'
                sh '''
                  echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                  docker push vladbuk/nuxt-docker:test-${BUILD_NUMBER}
                  docker push vladbuk/nuxt-docker:latest
                  docker rmi -f $(docker images -q vladbuk/nuxt-docker)
                '''
                //sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                //sh 'docker push vladbuk/nuxt-docker:${BUILD_NUMBER}'
            }
        }

        stage('Deploying') {
            steps {
                script{
                    command='''
                        mkdir -p $HOME/nuxt-docker && cd $HOME/nuxt-docker/
                        docker pull vladbuk/nuxt-docker:test-${BUILD_NUMBER}
                        GET_ID="docker ps -aqf name=nuxt-docker"

                        CONTAINER_ID=$(eval $GET_ID)
                        if [[ $CONTAINER_ID ]]
                        then
                            docker rm -f $CONTAINER_ID
                            echo Container $CONTAINER_ID deleted and will be created again.
                            docker run -d -t --name nuxt-docker --restart always -p 8080:8080 vladbuk/nuxt-docker:test-${BUILD_NUMBER}
                        else
                            echo -e Container does not exist. It will be created.\n
                            docker run -d -t --name nuxt-docker --restart always -p 8080:8080 vladbuk/nuxt-docker:test-${BUILD_NUMBER}
                        fi
                        CONTAINER_ID=$(eval $GET_ID)
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

        stage('Testing') {
            steps {
                echo 'Testing container working'
                sh 'sleep 10'
                sh '''
                    SITEURL=test.vladbuk.site
                    ping -c 1 ${SITEURL} > /dev/null 2>&1; echo $?
                    CURLTEST="curl -s -L --head  --request GET https://${SITEURL} | grep '200' > /dev/null"
                    if $(eval ${CURLTEST})
                    then
                        echo "${SITEURL} is UP"
                    else
                        echo "${SITEURL} is DOWN"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        always {
            sh 'docker logout'
    }
  }
}
