FROM alpine:3.7

ENV PROXY_PATH /goproxy
ENV CERT_PATH $PROXY_PATH/cert

COPY ./start.sh /start.sh
RUN mkdir -p $CERT_PATH
COPY ./cert $CERT_PATH
WORKDIR $PROXY_PATH 

RUN  apk update \
	&& apk add openssl \
	&& wget https://github.com/snail007/goproxy/releases/download/v4.4/proxy-linux-amd64.tar.gz  \
	&& tar -zxvf proxy-linux-amd64.tar.gz \
	&& rm -rf proxy-linux-amd64.tar.gz 

EXPOSE 80
EXPOSE 8080
CMD ["/start.sh"]
