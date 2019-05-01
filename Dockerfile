
FROM java
WORKDIR /
ADD target/gs-spring-boot-0.1.0.jar //
CMD java - jar target/gs-spring-boot-0.1.0.jar
