pipeline {
  agent { docker 'tokiwa-software/fuzion:main' }

  environment {
    FUZION_BIN = '/fuzion/bin'
    FUZION_BUILD = '/fuzion'
    FLANG_DEV = "${env.WORKSPACE}/flang_dev"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm

        dir('flang_dev') {
          checkout scmGit(
            branches: [[name: 'main']],
            userRemoteConfigs: [[credentialsId: '7a3054c1-90e8-4a0c-a4ec-1304a6c2c38f',
              url: 'https://git.tokiwa.software/tokiwa/flang_dev.git']])
        }
      }
    }
    stage('Build webserver.fum') {
      steps {
        dir('flang_dev') {
          sh 'make /fuzion/modules/webserver.fum'
        }
      }
    }
    stage('Build webserver C binary') {
      steps {
        sh 'make webserver'
      }
    }
  }
}
