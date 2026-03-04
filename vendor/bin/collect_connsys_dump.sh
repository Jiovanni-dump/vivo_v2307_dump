#!/vendor/bin/sh

TAG="collect_connsys_dump"
DUMP_HASH_CMM="// ## Firmware version\n\
// ## ----------------\n\
// ## VIVO|11102016|xiaolei.du|QCOM_1.0.1\n\
// ## Description: "

# Starts here
log -t ${TAG} "Start ${1} connsys dump..."

if [ "$1" == "clear" ]; then
    rm -rf /data/vendor/ramdump/*
    return
fi

platform=`getprop ro.vivo.product.platform`
if [ "$platform" = "SM8350" ]; then
    TargetFiles=("ramdump_wlan")
    KeyWord="\[mhi_process_sfr\] "
elif [ "$platform" = "SM7325" ]; then
    TargetFiles=("ramdump_wpss" "ramdump_wcss")
    KeyWord="wpss subsystem failure reason:"
elif [ "$platform" = "SM8250" ]; then
    TargetFiles=("ramdump_wlan")
    KeyWord="Asserted in"
else
    TargetFiles=("ramdump_wlan")
    KeyWord="Asserted in"
fi
log -t $TAG "platform=${platform} ,TargetFiles=${TargetFiles} ,Keyword=${KeyWord} "

# Reset last dump path
setprop "vendor.wifidump.prop.last_dump_path" ""

timestamp=`date '+%Y_%m_%d_%H_%M_%S'`
# Copy dumps to cache dir
dump_dir="moredump_${timestamp}"
mkdir /data/vendor/ramdump/${dump_dir}
chmod 777 /data/vendor/ramdump/${dump_dir}

for dumpfile in ${TargetFiles[@]}; do
    if [[ `ls /data/vendor/ramdump | grep -c $dumpfile` != 0 ]]; then
        echo "There is an elf file exit in /data/vendor/ramdump"
        mv /data/vendor/ramdump/${dumpfile}*.elf /data/vendor/ramdump/${dump_dir}
    else
        latest_elf=`ls -t /data/vendor/ssr_fulldump/${dumpfile}*.elf | head -n1`
        cp ${latest_elf} /data/vendor/ramdump/${dump_dir}
        log -t $TAG "copy ramdump file ${latest_elf} "
    fi
done

# Save dmesg
dmesg > /data/vendor/ramdump/${dump_dir}/kernel.log
# Calculate hash and write hash file
#stack_trace=`cat /data/vendor/ramdump/${dump_dir}/kernel.log | grep -i mhi_process_sfr | tail -1 | cut -d \"\[mhi_process_sfr\] \" -F 2`

last_ocur=`cat /data/vendor/ramdump/${dump_dir}/kernel.log | grep -i "${KeyWord}" | tail -1`
echo $last_ocur
stack_trace=`echo $last_ocur | cut -d "${KeyWord}" -F 2`

echo $stack_trace
if [ -z "$stack_trace" ]; then
    log -t $TAG "stack track is not found!!"
    echo "stack track is not found!!"
    return
fi

log -t $TAG $platform$stack_trace
hash=($(echo -n $platform$stack_trace | md5sum))
echo $hash
echo "${DUMP_HASH_CMM}${stack_trace} (0x11102016)\n// ## Arguments:    ${hash}" > /data/vendor/ramdump/${dump_dir}/moredump_${timestamp}.cmm

# debug
cat /data/vendor/ramdump/${dump_dir}/moredump_${timestamp}.cmm
tar_file_path=/data/vendor/ramdump/moredump_${timestamp}.tar.gz
tar -czf $tar_file_path --exclude=./bluetooth -C /data/vendor/ramdump/ .
chmod 777 $tar_file_path
setprop "vendor.wifidump.prop.last_dump_path" ${tar_file_path}
#/system/bin/am broadcast -a "com.vivo.intent.action.CLOUD_DIAGNOSIS" --ei "attr" 3 --ei "module" 3300 --es "data" "{\"moduleid\":\"3300\",\"eventId\":\"00059|012\",\"logpath\":\"${tar_file_path}\"}" com.bbk.iqoo.logsystem
