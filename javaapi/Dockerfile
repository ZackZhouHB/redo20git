# 1st build with openjdk8, need maven to build java artifact
# set work dir, copy all from current to work dir
# then mvn build for java artifact 
FROM openjdk:8 AS BUILD_IMAGE
WORKDIR /usr/src/app/
RUN apt update && apt install maven -y
COPY ./ /usr/src/app/
RUN mvn install -DskipTests

FROM openjdk:8
# copy 1st build artifact from bellow to
# curent workdir 
WORKDIR /usr/src/app/
COPY --from=BUILD_IMAGE /usr/src/app/target/book-work-0.0.1-SNAPSHOT.jar ./book-work-0.0.1.jar

EXPOSE 9000
# run java app
ENTRYPOINT ["java","-jar","book-work-0.0.1.jar"]
# Test
