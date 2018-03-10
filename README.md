# 基于goproxy的内网穿透Docker镜像
## Usage 
docker  build -t goproxy . 


* 内部8080端口为server端口 80为桥接端口 
docker run -v ./cert:/goproxy/cert -p "8080:8080" -p "8081:80" 
### cert 目录下的文件可以用 ./proxy keygen 生成 
```
 比如服务器上绑定了域名 `www.youdomain.com` nginx 反向代理到本机的8081端口. 
 本地启动客户端 执行
 ./proxy.exe client -P "服务器的ip地址:8081" -C proxy.crt -K proxy.key
 然后使用 www.youdomain.com 访问即可. 
```
