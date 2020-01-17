build_badge = addEmbeddableBadgeConfiguration(id: 'build', subject: 'Build')

pipeline {

    agent any

    parameters {
        string(defaultValue: "", description: 'Param to indicate who trigger this build', name: 'TRIGGER_SOURCE')
    }

    stages {

        stage('Build') {

            parallel {
                stage("Full") {
                    when { expression { params.TRIGGER_SOURCE != "thomas_drivers" } }
                    steps {
                        script {
                            build_badge.setStatus('building')
                            try {
                                sh 'cd dockerfiles && ./build.sh'
                                build_badge.setStatus('passing')
                            } catch (Exception err) {
                                build_badge.setStatus('failing')
                                error 'Build failed'
                            }
                        }
                    }
                }

                stage("Patial") {
                    when { expression { params.TRIGGER_SOURCE == "thomas_drivers" } }
                    steps {
                        script {
                            build_badge.setStatus('building')
                            try {
                                sh 'cd dockerfiles && ./build.sh'
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
    }
}

