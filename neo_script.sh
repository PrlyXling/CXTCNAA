#!/bin/bash
###UserInfo
username=
password=
###Settings
test_url=http://www.msftconnecttest.com/redirect
pass_url=https://www.msn.cn/zh-cn
auth_url=http://106.60.4.60:8016
period=3
###Function
function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
#
function log() {
    time=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "\n[$time] $*\n"
}
#
function login() {
    redirect_url=$(curl -Ls -w "%{url_effective}" -o /dev/null "$test_url")
    if [[ ! $redirect_url =~ ^$pass_url ]];then
        if [[ $redirect_url =~ ^$auth_url ]];then
            paramstr=$(urldecode "$(curl -Ls "$redirect_url" | sed -n 's/.*paramStr=\([^"]*\).*/\1/p')")
            redirect_url=$(curl -Ls -w "%{url_effective}" -o /dev/null -X POST "$auth_url/authServlet" --data-urlencode "paramStr=$paramstr" --data-urlencode "UserName=$username" --data-urlencode "PassWord=$password")
            if [[ "$redirect_url" == *"logon.jsp"* ]];then
                log "Auth Pass" "paramstr=$paramstr"  
                return 0
            fi
            log "Auth Fail"
            return 1
        fi
        log "Fail"
        return 2
    fi
    log "Pass"
    return 0
}
#
function logout() {
    curl -Ls -w "%{url_effective}" -o /dev/null -F "paramStr=$1" "$auth_url/logoutServlet"
    redirect_url=$(curl -Ls -w "%{url_effective}" -o /dev/null "$test_url")
    if [[ ! $redirect_url =~ ^$pass_url ]];then
        log "Logout Successful"
        return 0
    fi
    log "Logout Fail"
    return 1
}
###Login
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    fail_count=0
    max_retries=10

    while true; do
        login
        login_result=$?

        case $login_result in
            0)
                exit 0
            ;;
            *)
                ((fail_count++))
                if [ $fail_count -ge $max_retries ];then
                    log "Manbaout"
                    exit 1
                fi
            ;;
        esac

        sleep $period
    done
fi
