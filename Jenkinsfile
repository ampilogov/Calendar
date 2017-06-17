pipeline {
  agent any
  stages {
    stage('Check out') {
      steps {
        git(url: 'https://github.com/ivampir/Calendar.git', branch: 'master')
      }
    }
  }
}