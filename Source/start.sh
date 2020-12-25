#!/bin/bash

# 配置冲突
if [[ ${SS_ONLY} == true ]] && [[ ${KCP_ONLY} == true ]];then
    echo "[ERROR] SS_ONLY and KCP_ONLY cannot be set to true at the same time!"
    exit 1
fi
if [[ ${SS_ONLY} == true ]] && [[ ${KCP2_ON} == true ]];then
    echo "[ERROR] SS_ONLY and KCP2_ON cannot be set to true at the same time!"
    exit 1
fi

# 默认配置
if [ ! -n "${SS_ONLY}" ] && [ ! -n "${KCP_ONLY}" ];then
    echo "[INFO] No SS_ONLY configured. The default parameters are being used."
    echo "===> SS_ONLY=true"
    echo ""
    SS_ONLY=true
    echo "[INFO] No KCP_ONLY configured. The default parameters are being used."
    echo "===> KCP_ONLY=false"
    echo ""
    KCP_ONLY=false

fi
if [ ! -n "${KCP_ONLY}" ];then
    echo "[INFO] No KCP_ONLY configured. The default parameters are being used."
    echo "===> KCP_ONLY=false"
    echo ""
    KCP_ONLY=false
fi
if [ ! -n "${SS_ONLY}" ] && [[ ${KCP_ONLY} == true ]];then
    echo "[INFO] No SS_ONLY configured. The default parameters are being used."
    echo "===> SS_ONLY=false"
    echo ""
    SS_ONLY=false
fi
if [ ! -n "${KCP2_ON}" ];then
    echo "[INFO] No KCP2_ON configured. The default parameters are being used."
    echo "===> KCP2_ON=false"
    echo ""
    KCP2_ON=false
fi



# 调整配置
# SS密码
if [ ! -n "${SS_PWD}" ] || [[ ${SS_PWD} == "" ]];then
    if [[ ${KCP_ONLY} == true ]];then
        if [ ! -n "${KCP_PWD}" ] || [[ ${KCP_PWD} == "" ]];then
            echo "[ERROR] KCP_ONLY Mode: No KCP or SS password configured. Please check container's environment variables."
            exit 1
        fi
    else
        echo "[ERROR] No SS password configured. Please check container's environment variables."
        exit 1
    fi
fi

# SS加密算法
if [ ! -n "${SS_CR}" ];then
    SS_CR="chacha20-ietf-poly1305"
fi

# SS超时时间
if [ ! -n "${SS_TIME}" ];then
    SS_TIME="60"
fi

# SS MTU
if [ ! -n "${SS_MTU}" ];then
    SS_MTU="1450"
fi


# KCP服务器地址
sed -i "s/KCP_SERVER/${KCP_SERVER}/g" /root/hmss/kcpc.json
sed -i "s/KCP_SERVER2/${KCP_SERVER2}/g" /root/hmss/kcpc2.json

# KCP密码
if [ ! -n "${KCP_PWD}" ] || [[ ${KCP_PWD} == "" ]];then
    echo "[INFO] No KCP password configured. Set KCP Password by SS password."
    sed -i "s/KCP_PWD/$SS_PWD/g" /root/hmss/kcpc.json
    sed -i "s/KCP_PWD/$SS_PWD/g" /root/hmss/kcpc2.json
else
    sed -i "s/KCP_PWD/$KCP_PWD/g" /root/hmss/kcpc.json
    sed -i "s/KCP_PWD/$KCP_PWD/g" /root/hmss/kcpc2.json
fi

# KCP加密方式
sed -i "s/KCP_CR/${KCP_CR:-"salsa20"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_CR/${KCP_CR:-"salsa20"}/g" /root/hmss/kcpc2.json

# KCP模式
sed -i "s/KCP_MODE/${KCP_MODE:-"normal"}/g" /root/hmss/kcpc.json

# KCP模式2
sed -i "s/KCP_MODE/${KCP_MODE2:-"fast"}/g" /root/hmss/kcpc2.json

# KCP MTU
sed -i "s/KCP_MTU/${KCP_MTU:-"1450"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_MTU/${KCP_MTU:-"1450"}/g" /root/hmss/kcpc2.json

# KCP发送窗口
sed -i "s/KCP_SW/${KCP_SW:-"1024"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_SW/${KCP_SW:-"1024"}/g" /root/hmss/kcpc2.json

# KCP接收窗口
sed -i "s/KCP_RW/${KCP_RW:-"1024"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_RW/${KCP_RW:-"1024"}/g" /root/hmss/kcpc2.json

# KCP数据包
sed -i "s/KCP_DS/${KCP_DS:-"10"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_DS/${KCP_DS:-"10"}/g" /root/hmss/kcpc2.json

# KCP校验包
sed -i "s/KCP_PS/${KCP_PS:-"3"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_PS/${KCP_PS:-"3"}/g" /root/hmss/kcpc2.json

# KCP DSCP
sed -i "s/KCP_SDSCP/${KCP_SDSCP:-"46"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_SDSCP/${KCP_SDSCP:-"46"}/g" /root/hmss/kcpc2.json

# KCP连接数
sed -i "s/KCP_CONN/${KCP_CONN:-"1"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_CONN/${KCP_CONN:-"1"}/g" /root/hmss/kcpc2.json

# KCP UDP连接自动过期时间
sed -i "s/KCP_KTIME/${KCP_KTIME:-"0"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_KTIME/${KCP_KTIME:-"0"}/g" /root/hmss/kcpc2.json

# KCP长连接过期时间
sed -i "s/KCP_TTIME/${KCP_TTIME:-"600"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_TTIME/${KCP_TTIME:-"600"}/g" /root/hmss/kcpc2.json

# KCP Socket缓冲
sed -i "s/KCP_BUF/${KCP_BUF:-"4194304"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_BUF/${KCP_BUF:-"4194304"}/g" /root/hmss/kcpc2.json

# KCP禁用压缩
sed -i "s/KCP_NCP/${KCP_NCP:-"false"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_NCP/${KCP_NCP:-"false"}/g" /root/hmss/kcpc2.json

# KCP心跳时间
sed -i "s/KCP_KAL/${KCP_KAL:-"10"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_KAL/${KCP_KAL:-"10"}/g" /root/hmss/kcpc2.json

# KCP模拟TCP连接
sed -i "s/KCP_TCP/${KCP_TCP:-"false"}/g" /root/hmss/kcpc.json
sed -i "s/KCP_TCP/${KCP_TCP:-"false"}/g" /root/hmss/kcpc2.json



# 启动SS
if [[ ${KCP_ONLY} == false ]];then
    /root/hmss/hmssc -f /root/hmss/hmssc.pid -u -s "${SS_SERVER}" -p ${SS_SERVERPORT} -l 2080 -b "0.0.0.0" -k "${SS_PWD}" -m "${SS_CR}" -t ${SS_TIME} --mtu ${SS_MTU}
    if [[ $? != 0 ]];then
        echo "[ERROR] SS cannot start. Please check container's environment variables."
        exit 1
    else
        echo "[INFO] HMSS Client Running..."
        echo ""
    fi
    /root/hmss/pv /root/hmss/pv-config
fi

# 启动KCP
if [[ ${SS_ONLY} == false ]];then
    /root/hmss/hmkcpc -c /root/hmss/kcpc.json 2>&1 &
    #/root/hmss/hmkcpc --localaddr ":2081" --remoteaddr "KCP_SERVER" --key "KCP_PWD" --crypt "KCP_CR" --mode "KCP_MODE" --conn KCP_CONN --acknodelay KCP_KTIME --scavengettl KCP_TTIME --mtu KCP_MTU --sndwnd KCP_SW --rcvwnd KCP_RW --datashard KCP_DS --parityshard KCP_PS --dscp KCP_SDSCP --sockbuf KCP_BUF --keepalive 10 --quiet 2>&1 &
    if [[ $? != 0 ]];then
        echo "[ERROR] KCP cannot start. Please check container's environment variables."
        exit 1
    else
        sleep 3
        echo "[INFO] HMKCP Client Running..."
        echo ""
        cat /root/hmss/kcpc.log
        echo ""
    fi
    if [[ ${KCP2_ON} == true ]];then
        /root/hmss/hmkcpc -c /root/hmss/kcpc2.json 2>&1 &
        if [[ $? != 0 ]];then
            echo "[ERROR] KCP cannot start. Please check container's environment variables."
            exit 1
        else
            sleep 3
            echo "[INFO] HMKCP Client2 Running..."
            echo ""
            cat /root/hmss/kcpc2.log
            echo ""
        fi
    fi
fi

# 容器保活
/root/hmss/keep
