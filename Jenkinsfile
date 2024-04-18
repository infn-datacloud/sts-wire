pipeline {
  agent none
  
  stages {
        stage('Build') {
            agent {
                docker {
                  label 'jenkinsworker00'
                  image 'marica/golang:1.21.0-patch'
                  reuseNode true
                }
            }
            steps {
                script {
                  sh '''
                  export GOCACHE=$WORKSPACE/.cache/go-build
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