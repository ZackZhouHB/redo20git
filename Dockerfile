# use openjdk:11 as 1st layer image 
FROM openjdk:11 AS BUILD_IMAGE
LABEL "Project"="e4"

# install sw and build artifact from 1st build image
RUN apt-get update && apt-get install maven -y
RUN git clone https://github.com/devopshydclub/vprofile-project.git
RUN cd vprofile-project && git checkout docker && mvn install

#  build from tomcat by copy above artifact to build 2nd layer image 
FROM tomcat:9-jre11
# replace artifact to default tomcat dir
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE vprofile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
# from tomcat doc to run
CMD ["catalina.sh", "run"]