FROM ubuntu:16.04 AS build
# update system and install packages
RUN apt-get update -qq && apt-get install -yqq \
  default-jdk \
  git \
  maven
# clone from git and deploy war-file
RUN mkdir maven_build  && git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git maven_build
RUN cd maven_build && mvn package
FROM tomcat:8
# copy war-file to webapps dir
COPY --from=build /maven_build/target/hello-*.war /usr/local/tomcat/webapps/hello.war
# announcement working port
EXPOSE 8080
# run tomcat with war-file
CMD ["catalina.sh", "run"]