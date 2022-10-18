


#cpu 温度
CPUTEMP=$(sudo cat /sys/class/hwmon/hwmon0/temp1_input)
CPUTEMP=$(($CPUTEMP / 1000))
echo "cpu temperature: " $CPUTEMP

#各个硬盘温度
echo "hdd temperature: "
for _device in /sys/block/*/device; do
    
    if echo $(readlink -f $_device) | egrep -q "ata"; then
        name=$(echo $_device | cut -f4 -d/)
        dev="/dev/$name"

        if [ X"$dev" != "Xnull" -a X"$dev" != "X" ]; then
            STATUS0=$(hdparm -C $dev | sed -n '3p' | awk '{print $4}')
            if [ X"$STATUS0" != "Xstandby" ]; then
                echo $dev": " $(smartctl -A $dev | sed -n '/Temperature_Celsius/p' | awk '{print $10}')
                
            else
                echo $dev "standby"
            fi
        fi

    fi
done

#风扇转速
echo "fan1: " $(fan-ctl -g -i 1)
echo "fan2: " $(fan-ctl -g -i 2)
