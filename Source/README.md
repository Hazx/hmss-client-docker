# hmss-1.7
## 客户端版本

- shadowsocks: 3.3.4
- kcptun: 20200201
- privoxy: 3.0.28


## 内部监听端口

组件 | 端口 | 协议
---|---|---
Privoxy | 2079 | TCP - HTTP
Shadowsocks | 2080 | TCP - SOCKS5
Shadowsocks | 2080 | UDP - SOCKS5
KCPTUN | 2081 | TCP - KCPTUN
KCPTUN | 2081 | UDP - KCPTUN
KCPTUN (2) | 2082 | TCP - KCPTUN
KCPTUN (2) | 2082 | UDP - KCPTUN


## 构建镜像前的准备工作

　　运行 dl.sh 下载软件源码包。（或可自己搜索下载指定版本的服务端的源码包，并修改 Dockerfile 中相关的文件名。）

## 构建镜像
```
docker build -t 新镜像名称 .
```


## 启动镜像
```shell
docker run -d -p SS端口:2080 -p SS端口:2080/udp -p KCP端口:2081 -p KCP端口:2081/udp -p KCP端口2:2082 -p KCP端口2:2082/udp --name 容器名称 -e SS_SERVER="服务器IP" -e SS_SERVERPORT="服务器SS端口" -e SS_PWD="SS密码" -e SS_CR="SS加密算法" --restart unless-stopped hazx/hmss-client:1.7
```
默认情况下会启动一个SS，另有两个KCP客户端可选开启，共监听4个端口（SS与KCPTUN的3个端口均使用TCP和UDP两个协议），可按需开启和配置。SS的协议为SOCKS5，若需要HTTP协议，可配置监听2079端口。


## 可使用的环境变量

使用方法：-e SS_PWD="xxxxx" -e SS_CR="xxxx" -e KCP_CR="xxxx"

环境变量 | 功能 | 默认值
---|---|---
SS_SERVER | SS服务器地址
SS_SERVERPORT | SS服务器端口
SS_PWD | SS密码
SS_CR | SS加密算法 | chacha20-ietf-poly1305
SS_TIME | SS超时时间 | 60
SS_MTU | SS MTU | 1450
SS_ONLY | 只使用SS，关闭KCP | true
KCP_SERVER | KCP服务器地址:端口
KCP_PWD | KCP密码 | （同SS_PWD）
KCP_CR | KCP加密算法 | salsa20
KCP_MODE | KCP模式 | normal
KCP_MODE2 | KCP模式2 | fast
KCP_MTU | KCP MTU| 1450
KCP_SW | KCP发送窗口 | 1024
KCP_RW | KCP接收窗口 | 1024
KCP_DS | KCP数据包 | 10
KCP_PS | KCP校验包 | 3
KCP_SDSCP | DSCP | 46（101110）
KCP_CONN | KCP连接数 | 1
KCP_KTIME | KCP的UDP连接自动过期时间 | 0（0关闭，单位秒）
KCP_TTIME | 长连接过期时间 | 600（-1关闭，单位秒）
KCP_BUF | Socket缓冲 | 4194304（单位字节）
KCP2_ON | 启用双KCP | false
KCP_ONLY | 只使用KCP，关闭SS | false

- SS_CR参考值：rc4-md5, aes-128-gcm, aes-192-gcm, aes-256-gcm, aes-128-cfb, aes-192-cfb, aes-256-cfb, aes-128-ctr, aes-192-ctr, aes-256-ctr, camellia-128-cfb, camellia-192-cfb, camellia-256-cfb, bf-cfb, chacha20-ietf-poly1305, xchacha20-ietf-poly1305, salsa20, chacha20 and chacha20-ietf
- KCP_CR参考值：aes, aes-128, aes-192, salsa20, blowfish, twofish, cast5, 3des, tea, xtea, xor, sm4, none
- KCP_MODE参考值：fast3, fast2, fast, normal, manual