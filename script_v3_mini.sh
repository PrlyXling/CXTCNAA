#!/bin/bash
username=
password=
test_url=http://www.msftconnecttest.com/redirect
pass_url=https://www.msn.cn/zh-cn
auth_url=http://106.60.4.60:8016

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

function log() {
    time=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "\n[$time] $*\n"
}

function login() {
    redirect_url=$(curl -Ls -w "%{url_effective}" -o /dev/null "$test_url")
    if [[ ! $redirect_url =~ ^$pass_url ]];then
        if [[ $redirect_url =~ ^$auth_url ]];then
            paramstr=$(urldecode "$(curl -Ls "$redirect_url" | sed -n 's/.*paramStr=\([^"]*\).*/\1/p')")
            response=$(curl -Ls -w "%{url_effective}" -X POST "$auth_url/authServlet" --data-urlencode "paramStr=$paramstr" --data-urlencode "UserName=$username" --data-urlencode "PassWord=$password")
            if [[ "$response" == *"logon.jsp"* ]];then
                #
                # ntpd -S /usr/sbin/ntpd-hotplug -p ntp1.aliyun.com
                # sleep 3
                #
                log "Auth Pass" "paramstr=$paramstr"
                return 0;
            fi
            error_message=$(echo $response | sed -n "s/.*window.portalconfig={\'show\':\'\([^']*\).*/\1/p")
            log $error_message
            return -1;
        fi
        log Fail
        return -2;
    fi
    #
    # ntpd -S /usr/sbin/ntpd-hotplug -p ntp1.aliyun.com
    # sleep 3
    #
    log Pass
    return 1;
}

login
