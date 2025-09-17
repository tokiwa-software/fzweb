pipeline {
  agent { docker 'tokiwa-software/fuzion:main' }

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
        }
      }
    }
    stage('Build fuzion') {
      steps {
        dir('fuzion') {
          sh 'make'
        }
      }
    }
    stage('Build webserver.fum') {
      steps {
        dir('flang_dev') {
          sh "make DITAA='java -jar /usr/share/ditaa/ditaa.jar' ${env.WORKSPACE}/fuzion/build/modules/webserver.fum"
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
