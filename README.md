# CXTCNAA
## 楚雄师范学院校园网自动认证脚本
openwrt/linux 校园网自动认证脚本
## 使用方法
1. 准备一台支持刷入openwrt/linux的路由器(可以去网上搜索刷机方法，本人测试所用为红米AC2100)
2. 刷入适合当前设备的openwrt系统(测试所用为BleachWrt)
4. (下载需要网络)下载必要软件包:bash(参考`opkg update && opkg install bash`)(其余软件一般系统会内置安装)
5. 从仓库下载neo_script.sh,使用文本编辑器在脚本中的username和password中分别填入你的认证用户名和密码
6. 在openwrt管理页面 系统>文件传输中上传脚本，将脚本移动至合适目录(以下以根目录为例,参考`mv /tmp/upload/neo_script.sh /`)
7. 为脚本添加执行权限 chmod +x 你脚本的位置(参考`chmod 777 /neo_script.sh`)
8. 在openwrt管理界面中 系统>启动项>本地启动脚本,在exit 0前填入脚本路径(我这里为/neo_script.sh >> /tmp/auth.log &)
## 登出说明
1. 此脚本一般不需要登出，如果需要登出功能，可以通过获取输出日志中认证成功返回的paramstr值进行登出
2. 上一条的操作流程：使用ssh或ttyd登录到openwrt，执行`source /neo_script.sh && logout 你的paramStr值`
## 对于使用方法第三条的扩充
1. 可以通过网线将路由器WAN口与光猫LAN口连接，再将电脑的网线接口与路由器LAN口连接，使用原本的认证页面临时认证，使得bash安装顺利进行
2. 也可以通过一台能上网的设备直接通过原本界面认证后在网上下载bash.ipk，然后该设备连接至路由器，通过管理界面上传文件并直接安装
## 其他
* 校园网登录界面
* 修改登录脚本中的账号密码
* 上传脚本文件
* 脚本文件位置
* 启动项修改
* 认证成功的日志
