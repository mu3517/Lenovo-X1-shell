#!/bin/sh

ver="0.0.1"
# ==============================================================================
# by mu3517
# 
# 本脚本修改及程序移植于 X1 系统。 仅供学习参考。（由于没有其他机型硬件，应该X1s也是可以用的）
#
# 状态灯部分：
# 1. 取消了硬盘错误状态监测， 盘位更新各种监测。
# 2. 只检测盘位是否正常加载。 后续慢慢更新！
# 3. 网络部分完全正常，正常白灯拔掉网线蓝灯闪烁。只是反应没那么即时。
#
# 风扇部分：
# 1. 完整移植了 X1 内部控制算法，但是与群晖的界面控制还是不兼容。
# 2. 具体温度控制可以参考
#
# 电源部分：
# 暂时只是copy了 power-ctl 通过脚本可以使长按电源3s关机生效。 这里没加入后续更新。
#
# 喇叭提示部分：
# 由于群晖需要编译驱动暂时没研究搭建编译（有点懒，主要是群晖系统太麻烦了各种缺少文件。）
#
# ==============================================================================


cp ./bin/led-ctl /bin/
cp ./bin/fan-ctl /bin/
cp ./bin/power-ctl /bin/
chmod 0755 /bin/led-ctl
chmod 0755 /bin/fan-ctl
chmod 0755 /bin/power-ctl
echo "copy ctl-files seccuss. \n"

cp ./usr/bin/fan-monitor /usr/bin/
cp ./usr/bin/led-monitor /usr/bin/
chmod 0755 /usr/bin/fan-monitor
chmod 0755 /usr/bin/led-monitor
echo "copy monitor-files seccuss. \n"

if [ ! -d “/lib/systemd/system” ];then
    mkdir -p /lib/systemd/system
fi
cp ./lib/systemd/system/led-monitor.service /lib/systemd/system/
cp ./lib/systemd/system/fan-monitor.service /lib/systemd/system/
chmod 0755 /lib/systemd/system/led-monitor.service
chmod 0755 /lib/systemd/system/fan-monitor.service
echo "copy service-files seccuss. \n"

sleep 1

systemctl enable led-monitor
systemctl enable fan-monitor
echo "添加到服务完成. \n"

sleep 1

systemctl start led-monitor.service
systemctl start fan-monitor.service
echo "启动完成. \n"