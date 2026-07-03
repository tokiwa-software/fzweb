pipeline {
  agent any
  options {
    disableConcurrentBuilds()
    timeout(time: 30, unit: 'MINUTES')
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
            extensions: [submodule(parentCredentials: true, recursiveSubmodules: true)],
            userRemoteConfigs: [[credentialsId: '7a3054c1-90e8-4a0c-a4ec-1304a6c2c38f',
              url: 'https://git.tokiwa.software/tokiwa/flang_dev.git']])
        }
      }
    }
    stage('Build and deploy Docker image') {
      steps {
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
  post {
    failure {
      script {
        // Send the email using the extracted email
        emailext(
            subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: """
                Build failed. Check the console output:
                ${env.BUILD_URL}
            """,
            recipientProviders: [developers(), requestor()]
        )
      }
    }
  }
}
