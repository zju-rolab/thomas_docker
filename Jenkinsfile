build_badge = addEmbeddableBadgeConfiguration(id: 'build', subject: 'Build')

pipeline {

    agent any

    stages {

        stage('Build') {

            steps {
                script {
                    build_badge.setStatus('building')
                    try {
                        build_badge.setStatus('passing')
                    } catch (Exception err) {
                        build_badge.setStatus('failing')
                        error 'Build failed'
                    }
                }
            }
        }
    }
}

