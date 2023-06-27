FROM maven:3.9.0-amazoncorretto-17@sha256:0c16cfc1441f280729ec466343d391ae9a059da19637737b04844c73408cf076 as builder
RUN mkdir /eureka
COPY . /eureka
WORKDIR /eureka
RUN mvn clean install -DskipTests

FROM amazoncorretto:17@sha256:623aba07a14716b8739dc586240ad5678acee6c002454b5f19fb5781670868cc
RUN mkdir /eureka
RUN curl -L -s -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
    && chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
COPY --from=builder /eureka/target/eureka-server-0.0.1-SNAPSHOT.jar /eureka/eureka-server-0.0.1-SNAPSHOT.jar
CMD dumb-init java -jar -Xms512m -Xmx4096m /eureka/eureka-server-0.0.1-SNAPSHOT.jar
