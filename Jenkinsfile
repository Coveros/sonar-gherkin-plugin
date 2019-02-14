def branch
def pullRequest
def refspecs

node {
    cleanWs()
    ansiColor('xterm') {
        branch = env.BRANCH_NAME.replaceAll(/\//, "-")
        env.PROJECT = "sonar-gherkin-plugin"
        def branchCheckout
        pullRequest = env.CHANGE_ID
        if (pullRequest) {
            branchCheckout = "pr/${pullRequest}"
            refspecs = '+refs/pull/*/head:refs/remotes/origin/pr/*'
        } else {
            branchCheckout = env.BRANCH_NAME
            refspecs = '+refs/heads/*:refs/remotes/origin/*'
        }
        stage('Checkout Selenified') {
            // Get the test code from GitHub repository
            checkout([
                    $class           : 'GitSCM',
                    branches         : [[name: "*/${branchCheckout}"]],
                    userRemoteConfigs: [[
                                                url    : 'https://github.com/Coveros/sonar-gherkin-plugin.git',
                                                refspec: "${refspecs}"
                                        ]]
            ])
        }
        try {
            withCredentials([
                    string(
                            credentialsId: 'sonar-token',
                            variable: 'sonartoken'
                    ),
                    string(
                            credentialsId: 'sonar-github',
                            variable: 'SONAR_GITHUB_TOKEN'
                    )
            ]) {
                stage('Build, Test, Package, Analyze') {
                    def sonarCmd = "mvn clean verify sonar:sonar -Dsonar.login=${env.sonartoken} -Dsonar.junit.reportPaths='gherkin-checks/target/surefire-reports,gherkin-frontend/target/surefire-reports,sonar-gherkin-plugin/target/surefire-reports' -Dsonar.jacoco.reportPaths=target/jacoco.exec"
                    if (branch == 'develop' || branch == 'master') {
                        sh "${sonarCmd} -Dsonar.branch=${branch}"
                    } else {
                        if (pullRequest) {
                            sh "${sonarCmd} -Dsonar.analysis.mode=preview -Dsonar.branch=${branch} -Dsonar.github.pullRequest=${pullRequest} -Dsonar.github.repository=Coveros/${env.PROJECT} -Dsonar.github.oauth=${SONAR_GITHUB_TOKEN}"
                        } else {
                            sh "${sonarCmd} -Dsonar.analysis.mode=preview"
                        }
                    }
                }
            }
        } finally {
            stage('Publish Coverage Results') {
                archiveArtifacts artifacts: 'gherkin-checks/target/surefire-reports/**'
                archiveArtifacts artifacts: 'gherkin-frontend/target/surefire-reports/**'
                archiveArtifacts artifacts: 'sonar-gherkin-plugin/target/surefire-reports/**'
                archiveArtifacts artifacts: 'sonar-gherkin-plugin/target/sonar-gherkin-plugin-1.8-SNAPSHOT.jar'
                junit 'gherkin-checks/target/surefire-reports/TEST-*.xml,gherkin-frontend/target/surefire-reports/TEST-*.xml,sonar-gherkin-plugin/target/surefire-reports/TEST-*.xml'
                jacoco()
            }
        }
    }
}
