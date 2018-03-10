#!/bin/sh
cert=$CERT_PATH/proxy.crt
key=$CERT_PATH/proxy.key
bridge_port=80  
server_port=8080 

if [[ -f "$cert" || -f "$key" ]]; then 
	echo "using cert: ${cert} and using key:${key}" 
else
	echo "cert and key not exist ! generating ..." 
	./proxy keygen \
	&& mv proxy.key $key \
	&& mv proxy.crt $cert 
fi

echo "starting bridge ..." 
# 内网穿透,分为两个版本，“多链接版本”和“多路复用版本”，一般像web服务这种不是长时间连接的服务建议用“多链接版本”，
# 如果是要保持长时间连接建议使用“多路复用版本”。
# 多链接版本，对应的子命令是tserver，tclient，tbridge。
# 多路复用版本，对应的子命令是server，client，bridge。
# 多链接版本和多路复用版本的参数和使用方式完全一样。
# 多路复用版本的server，client可以开启压缩传输，参数是--c。
# server，client要么都开启压缩，要么都不开启，不能只开一个。
# 下面的教程以“多路复用版本”为例子，说明使用方法。
# 内网穿透由三部分组成:client端,server端,bridge端；client和server主动连接bridge端进行桥接.
# 当用户访问server端,流程是:

# 首先server端主动和bridge端建立连接；
# 然后bridge端通知client端连接bridge端和目标端口;
# 然后client端绑定“client端到bridge端”和“client端到目标端口”的连接；
# 然后bridge端把“client过来的连接”与“server端过来的连接”绑定；
# 整个通道建立完成；
# 启动桥接网络
./proxy bridge -p ":${bridge_prot}" -C ${cert} -K ${key} --log ./cert/runtime.log --forever --daemon
echo "starting server ..." 
# 启动server端. -r ":服务端的端口@本地转发的端口" -P "监听服务端的brideg地址：端口"
./proxy server -r ":${server_port}@:80" -P "0.0.0.0:${bridge_prot}" --log ./cert/runtime.log -C ${cert} -K ${key} --forever --daemon
