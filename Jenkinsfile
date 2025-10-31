pipeline {
  agent any
  options {
    disableConcurrentBuilds()
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm

        dir('fuzion') {
          checkout scmGit(
            branches: [[name: 'main']],
            userRemoteConfigs: [[url: 'https://github.com/tokiwa-software/fuzion.git']])
        }

        dir('flang_dev') {
          checkout scmGit(
            branches: [[name: 'main']],
            userRemoteConfigs: [[credentialsId: '7a3054c1-90e8-4a0c-a4ec-1304a6c2c38f',
              url: 'https://git.tokiwa.software/tokiwa/flang_dev.git']])

          dir('rrd-antlr4') {
            checkout scmGit(
              branches: [[name: 'af15d7d9151ce30a9b26bc8782a16643c93e3d6d']],
              userRemoteConfigs: [[url: 'https://github.com/bkiers/rrd-antlr4.git']])
          }
        }
      }
    }
    stage('Build and deploy Docker image') {
      steps {
        // deployment missing
        script {
          docker.build("tokiwa-software/fzweb:${env.BRANCH_NAME}")

          if (env.BRANCH_NAME == 'main') {
            sshagent(credentials: ['5b49490a-ba7a-49be-af2f-1f5a7de4b8b9']) {
              sh "docker image save tokiwa-software/fzweb:${env.BRANCH_NAME} | gzip | ssh jenkins@fuzion-lang.dev docker image load"
            }
          }
        }
      }
    }
  }
}
