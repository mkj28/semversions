FROM java:openjdk-8-jdk-alpine

ADD HelloWorld.java HelloWorld.java

RUN javac HelloWorld.java

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "HelloWorld"]
