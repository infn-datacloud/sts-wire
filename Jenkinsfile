def getReleaseVersion(String tagName) {
    if (tagName) {
        return tagName.replaceAll(/^v/, '')
    } else {
        return null
    }
}


pipeline {
  agent none

  environment {
    // Set RELEASE_VERSION only if TAG_NAME is set
    RELEASE_VERSION = getReleaseVersion(TAG_NAME)
  }
  
  stages {

        stage('Cleanup Workspace') {
          agent {
                node { label 'jenkinsworker00' }
            }
            options { skipDefaultCheckout() }
            steps {
                cleanWs()
            }
        }
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
          when { tag "v*" }
          agent {
                node { label 'jenkinsworker00' }
            }
          options { skipDefaultCheckout() }
          steps{
            nexusArtifactUploader(
              nexusVersion: 'nexus3',
              protocol: 'https',
              nexusUrl: 'repo.cloud.cnaf.infn.it',
              version: RELEASE_VERSION,
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