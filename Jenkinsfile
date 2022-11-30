pipeline {
    agent {
        docker { image 'node:16' }
    }
    //agent { dockerfile true }
    //agent any

    stages {
        stage('Preparing') {
            steps {
                echo 'Preparing'
                dir('$WORKSPACE') {
                    deleteDir()
                }
                //cleanWs()
                //sh 'cd $WORKSPACE'
                //sh 'rm -rf dist'
                git branch: 'main', url: 'https://github.com/vladbuk/L1_nuxtjs_project.git'
                //sh 'chown -R 113:119 .npm'
                //sh 'npm init --yes'
                sh 'yarn install'
            }
        }
        stage('Building') {
            steps {
                echo 'Building'
                sh 'yarn build'
                sh 'yarn generate'
            }
        }        
        stage('Archiving') {
            steps {
		echo 'Archiving'
                archiveArtifacts artifacts: 'dist/**/*', followSymlinks: false
            }
        }
        
        stage('Deploying') {
            steps {
                script{
                    sh "zip -r dist.zip dist/*"
                    echo 'Local files.....'
                    sh 'ls -l'
                    
                    command='''
                        cd /var/www/html
                        rm -rf dist/
                        unzip -o -d ./ dist.zip
                        ls -l
                        date
                    '''
                    
                    // Set access owner
                    //sshPublisher(publishers: [sshPublisherDesc(configName: 't2micro_ubuntu_test', verbose: 'true',
                    //    transfers: [ sshTransfer(execCommand: 'sudo chown ubuntu:ubuntu /var/www/html' )])])
                    
                    // Copy file to remote server 
                    sshPublisher(publishers: [sshPublisherDesc(configName: 't2micro_ubuntu_test', verbose: 'true',
                    transfers: [ sshTransfer(flatten: false,
                        //remoteDirectory: '/',
                        sourceFiles: 'dist.zip',
                        execCommand: command
                        )])
                    ])

                    // Execute commands
                    //sshPublisher(publishers: [sshPublisherDesc(configName: 't2micro_ubuntu_test',
                    //    transfers: [ sshTransfer(execCommand: command )])])
                }
            }
        }
    }
}
