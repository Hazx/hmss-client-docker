FROM centos:7.8.2003

LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="1.8"

COPY  * /root/hmss/

RUN yum install wget -y ;\
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo ;\
    yum makecache -y ;\
    yum install -y gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto c-ares-devel libev-devel libsodium-devel mbedtls-devel ;\
    cd /root/hmss ;\
    gcc keep.c -o keep ;\
    rm -fr keep.c ;\
    tar zxvf privoxy-3.0.28-stable-src.tar.gz ;\
    cd privoxy-3.0.28-stable ;\
    autoheader && autoconf && ./configure ;\
    make ;\
    mv /root/hmss/privoxy-3.0.28-stable/privoxy /root/hmss/pv ;\
    cd /root/hmss ;\
    rm -fr privoxy* ;\
    tar zxvf shadowsocks-libev-3.3.4.tar.gz ;\
    cd shadowsocks-libev-3.3.4 ;\
    ./configure --prefix="/root/hmss/ssexe" ;\
    make ;\
    make install ;\
    mv /root/hmss/ssexe/bin/ss-local /root/hmss/hmssc ;\
    cd /root/hmss ;\
    rm -fr shadowsocks* ;\
    rm -fr ssexe ;\
    tar zxvf kcptun-linux-amd64-20200701.tar.gz ;\
    mv client_linux_amd64 hmkcpc ;\
    rm -fr kcptun* server* dl.sh;\
    chmod a+x /root/hmss/start.sh /root/hmss/hmssc /root/hmss/hmkcpc /root/hmss/keep /root/hmss/pv ;\
    yum remove -y gcc autoconf automake make wget ;\
    yum clean all ;\
    rm -rf /var/cache/yum

CMD  /root/hmss/start.sh

