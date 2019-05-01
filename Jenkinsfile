node {
	def server = Artifactory.server 'artifactory' 
    def rtMaven = Artifactory.newMavenBuild()
    def buildInfo
    def mvnHome
    jdk = tool name: 'JAVA8'
    env.JAVA_HOME = "${jdk}"
    
   stage ('Clone') {			
	git branch: 'master', url: "https://github.com/ChiragMakkar13/SpringBootWebApp.git"
		}
	stage ('Artifactory configuration') {
        mvnHome = tool 'mavenhome'
        rtMaven.tool = 'mavenhome' // Tool name from Jenkins configuration
        rtMaven.deployer releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local', server: server
        rtMaven.resolver releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        buildInfo = Artifactory.newBuildInfo()
        buildInfo.env.capture = true
    }		
	stage ('Maven Build') {
	    rtMaven.run pom: 'pom.xml', goals: 'clean package', buildInfo: buildInfo
    }
   
	stage('SonarQube analysis') {
        mvnHome = tool 'mavenhome'
		withSonarQubeEnv('sonar') {
        rtMaven.run pom: 'pom.xml', goals: '$SONAR_MAVEN_GOAL -Dsonar.host.url=$SONAR_HOST_URL', buildInfo: buildInfo
		}
	}
	stage('Results') {
      junit '**/target/surefire-reports/TEST-*.xml'
      archive 'target/*.jar'
   }	
 
	stage ('Artifactory Build Publish') {
     server.publishBuildInfo buildInfo
    }
	 
		stage('Docker Image Build'){
			sh "sudo docker build -t chiragmakkar13/springbootwebapp ."
	   //sh "sudo docker build chiragmakkar13/springbootwebapp ."
          }

    stage('Push Image') {
            withCredentials([usernamePassword(
            credentialsId: "dockerhub",
            usernameVariable: "USER",
            passwordVariable: "PASS"
        )]) {
            sh "sudo docker login -u $USER -p $PASS"
        }

        sh "sudo docker tag chiragmakkar13/springbootwebapp:latest chiragmakkar13/springbootwebapp:$BUILD_NUMBER"
        sh "sudo docker push chiragmakkar13/springbootwebapp:latest"
        sh "sudo docker push chiragmakkar13/springbootwebapp:$BUILD_NUMBER"
    }
	
	
 }
