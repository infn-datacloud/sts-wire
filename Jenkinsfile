pipeline {
  agent none
  
  stages {
        stage('Build') {
            agent {
                docker {
                  label 'jenkinsworker00'
                  image 'golang:1.21.0'
                  reuseNode true
                }
            }
            steps {
                script {
                  sh '''
                  apt update && apt install -y patch
                  make build-linux-with-rclone
                  '''
                }  
            }
        }
        
        stage('Upload to Nexus'){
          agent {
                node { label 'jenkinsworker00' }
            }
          options { skipDefaultCheckout() }
          steps{
            nexusArtifactUploader(
              nexusVersion: 'nexus3',
              protocol: 'https',
              nexusUrl: 'repo.cloud.cnaf.infn.it',
              version: '1.0.0',
              repository: 'sts-wire',
              groupId: '',
              credentialsId: 'nexus-credentials',
              artifacts: [ 
                  [ artifactId: 'sts-wire-linux', type: '', classifier: '', file: "sts-wire_linux" ]
              ]
            )
             
            }
            post {
               always {
                 cleanWs()
               }
             }
          }
  }
}