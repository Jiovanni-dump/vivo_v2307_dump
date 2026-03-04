#=============================================================================
# Copyright (c) 2021 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#
# Copyright (c) 2012-2013, 2016-2020, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

# vivo wangjiewen add for zram writeback begin
# check osversion >=Funtouch11.5/>=vos2.1
function zwb_support_osversion() {
	Version=$1
	# products for china
	if [ `echo $Version 5.0  | awk '{print($1>$2)?"1":"0"}'` -eq "1" ]; then
		if [ `echo $Version 11.5 | awk '{print($1<$2)?"1":"0"}'` -eq "1" ]; then
			return 0
		fi
	# products for export
	else
		if [ `echo $Version 2.1 | awk '{print($1<$2)?"1":"0"}'` -eq "1" ]; then
			return 0
		fi
	fi
	return 1
}

function zwb_support() {
	if [ ! -f /sys/block/zram0/backing_dev ]; then
		return 1
	fi

	if [ "$ROMSizeKB" -le "33554432" ];then
		return 1
	fi

	return 0
}

function zwb_version() {
	ZWBVersion=`cat /sys/block/zram0/wb`
	if [ "$ZWBVersion" == "" ]; then
		ZWBVersion=1
	elif [ "$ZWBVersion" -le "3"  ]; then
		# RAM>=6G, ROM<=64G, keep v1
		if [ "$MemSizeKB" -gt "4194304" ] && [ "$ROMSizeKB" -lt "67108864" ]; then
			ZWBVersion=1
		elif [ "$MemSizeKB" -lt "3145728" ]; then
			ZWBVersion=1
		fi
	fi
}

function zwb_size_v1() {
	if [ $zRamSizeMB -ge 4096 ]; then
		BDSizeMB=3072
		ZWBV1Special=1
	elif [ $zRamSizeMB -ge 3072 ]; then
		BDSizeMB=1024
	elif [ $zRamSizeMB -ge 1536 ]; then
		BDSizeMB=512
	else
		BDSizeMB=`expr $zRamSizeMB / 3`
	fi
}

function zwb_size_v2() {
	if [ $zRamSizeMB -ge 4096 ]; then
		BDSizeMB=4096
		ZWBV2Special=1
	elif [ $zRamSizeMB -ge 3072 ]; then
		BDSizeMB=2048
		ZWBV2Special=2
	elif [ $zRamSizeMB -ge 2048 ]; then
		BDSizeMB=1024
	else
		BDSizeMB=`expr $zRamSizeMB / 3`
	fi
}

function zwb_size_v4() {
	zRamSizeOldMB=$zRamSizeMB
	zRamSizeMBShow=`expr $RamSizeGB \* 1024`
	if [ $zRamSizeMBShow -gt 8192 ]; then
		let zRamSizeMBShow=8192
	fi
	BDSizeMB=`expr $zRamSizeMBShow / 4`

	zRamSizeMB=$zRamSizeMBShow
	if [ $RamSizeGB -gt 8 ]; then
		#zRamSizeMB=12288
		zRamSizeMB=11264
	fi
}

function zwb_size()
{
	if [ "$ZWBVersion" -eq "1" ]; then
		zwb_size_v1
	elif [ "$ZWBVersion" -eq "2" ]; then
		zwb_size_v2
	elif [ "$ZWBVersion" -eq "4" ]; then
		zwb_size_v4
	fi

	if [ "$ZWBVersion" -eq "4" ]; then
		setprop persist.vendor.vivo.zramwb.size $zRamSizeMBShow
	else
		setprop persist.vendor.vivo.zramwb.size $BDSizeMB
	fi
}

function zwb_user_chioce() {
	# user choice
	ZWBTriggerUser=`getprop persist.vendor.vivo.zramwb.enable`
	if [ "$ZWBTriggerUser" == "" ]; then
		ZWBTriggerUser=`getprop ro.vivo.zramwb.default`
		if [ "$ZWBTriggerUser" != "1" ] && [ "$ZWBTriggerUser" != "0" ]; then
			ZWBTriggerUser=1
		fi
	fi
}

function zwb_storage_chioce() {
	ZWBTrigger=$ZWBTriggerUser
	if [ "$ZWBTrigger" == "0" ]; then
		return
	fi

	# get life_time from ufs or emmc
	if [ -d /sys/ufs ]; then
		life_time_a=`cat /sys/ufs/life_time_a`
		life_time_b=`cat /sys/ufs/life_time_b`
	else
		life_time_a=`cat /sys/block/mmcblk0/device/dev_left_time_a`
		life_time_b=`cat /sys/block/mmcblk0/device/dev_left_time_b`
	fi

	# memory life > 5 then close zram writeback
	if [ "$life_time_a" != "0x00" ] && [ "$life_time_a" != "0x01" ] && [ "$life_time_a" != "0x02" ] && [ "$life_time_a" != "0x03" ] && [ "$life_time_a" != "0x04" ] && [ "$life_time_a" != "0x05" ]; then
		ZWBTrigger=0
	fi
	if [ "$life_time_b" != "0x00" ] && [ "$life_time_b" != "0x01" ] && [ "$life_time_b" != "0x02" ] && [ "$life_time_b" != "0x03" ] && [ "$life_time_b" != "0x04" ] && [ "$life_time_b" != "0x05" ]; then
		ZWBTrigger=0
	fi
}

# ZWBTriggerUser & ZWBTrigger
function zwb_chioce() {
	zwb_user_chioce
	zwb_storage_chioce
}

function zwb_storage_check() {
	ROMFreeSizeKB=`df -k | grep /data$ | awk '{print $4}'`
	if [ "$ROMSizeKB" -lt "33554432" ]; then
		return 1
	elif [ "$ROMSizeKB" -lt "67108864" ]; then
		if [ "$ROMFreeSizeKB" -lt "10240000" ]; then
			return 1
		fi
	elif [ "$ROMSizeKB" -lt "134217728" ]; then
		if [ "$ROMFreeSizeKB" -lt "16384000" ]; then
			return 1
		fi
	elif [ "$ROMSizeKB" -lt "536870912" ]; then
		if [ "$ROMFreeSizeKB" -lt "25600000" ]; then
			return 1
		fi
	else
		return 1
	fi

	return 0
}

function zwb_create_file() {
	BDPath="/data/vendor/swap/zram"
	if [ "$ZWBTriggerUser" -eq "0" ]; then
		rm $BDPath
		return
	fi

	FileSizeB=`stat -c "%s" $BDPath`
	BDSizeB=`expr $BDSizeMB \* 1048576`
	if [ "$BDSizeB" == "$FileSizeB" ] || ! zwb_storage_check ; then
		return
	fi

	rm $BDPath
	is_f2fs1=`df -t f2fs | grep /data$`
	is_f2fs2=`mount -r -t f2fs | grep " /data "`
	if [ "$is_f2fs1" == "" ] && [ "$is_f2fs2" == "" ]; then
		dd if=/dev/zero of=$BDPath bs=1m count=$BDSizeMB
	else
		touch $BDPath
		f2fs_io pinfile set $BDPath
		fallocate -l $BDSizeB -o 0 $BDPath
	fi
}

function zwb_v1_special() {
	if [ "$ZWBV1Special" -ne "1" ]; then
		return
	fi
	BDSizeMB=1536
}

function zwb_v2_special() {
	if [ "$ZWBV2Special" == "1" ]; then
		BDSizeMB=2048
	elif [ "$ZWBV2Special" == "2" ]; then
		BDSizeMB=1536
	fi
}

function zwb_v4_special() {
	if [ "$ZWBTrigger" -ne "1"  ]; then
		zRamSizeMB=$zRamSizeOldMB
	fi
}

function zwb_sp() {
	if [ "$ZWBVersion" -eq "1" ]; then
		zwb_v1_special
	elif [ "$ZWBVersion" -eq "2" ]; then
		zwb_v2_special
	elif [ "$ZWBVersion" -eq "4" ]; then
		zwb_v4_special
	fi
}

function zwb_core() {
	zwb_sp
	if [ "$ZWBTrigger" -eq "1" ]; then
		if [ "$ZWBVersion" -le "3" ]; then
			zRamSizeMB=`expr $BDSizeMB + $zRamSizeMB`
		fi
		echo $BDPath > /sys/block/zram0/backing_dev
	fi
}

function zwb_parameter_v1() {
	BDSizePage=`expr $BDSizeMB \* 256`
	if [ "$ZWBV1Special" == "1" ]; then
		echo $BDSizePage > /sys/block/zram0/zram_wb/bd_size_limit
	fi

	# bd_reclaim_min should be min watermark diff at least
	if [ -f /sys/block/zram0/zram_wb/bd_reclaim_min ]; then
		# (1536 << 10 / 4) * 2%
		if [ "$MemSizeKB" -lt "3145728" ]; then
			echo 7900 > /sys/block/zram0/zram_wb/bd_reclaim_min
		# (2048 << 10 / 4) * 2%
		elif [ "$MemSizeKB" -lt "4194304" ]; then
			echo 10500 > /sys/block/zram0/zram_wb/bd_reclaim_min
		# (3072 << 10 / 4) * 2%
		elif [ "$MemSizeKB" -lt "6291456" ];then
			echo 15800 > /sys/block/zram0/zram_wb/bd_reclaim_min
		# (4096 << 10 / 4) * 2%
		else
			echo 24000 > /sys/block/zram0/zram_wb/bd_reclaim_min
		fi
	fi
}

function zwb_parameter_v2() {
	BDSizePage=`expr $BDSizeMB \* 256`
	if [ "$ZWBV2Special" == "1" ] || [ "$ZWBV2Special" == "2" ]; then
		echo $BDSizePage > /sys/block/zram0/zram_wb/bd_size_limit
	fi

	if [ "$MemSizeKB" -lt "4194304" ]; then
		echo 80 > /sys/block/zram0/zram_wb/dswappiness_low
		echo 110 > /sys/block/zram0/zram_wb/dswappiness_high
	elif [ "$MemSizeKB" -lt "6291456" ]; then
		echo 80 > /sys/block/zram0/zram_wb/dswappiness_low
		echo 120 > /sys/block/zram0/zram_wb/dswappiness_high
	else
		echo 40 > /sys/block/zram0/zram_wb/dswappiness_low
		echo 80 > /sys/block/zram0/zram_wb/dswappiness_high
	fi
}

function zwb_parameter() {
	if [ ! -d /sys/block/zram0/zram_wb ]; then
		return
	fi

	if [ "$ZWBVersion" -eq "1" ]; then
		zwb_parameter_v1
	elif [ "$ZWBVersion" -eq "2" ]; then
		zwb_parameter_v2
	fi
}

function zwb_init() {
	if ! zwb_support ; then
		return
	fi

	zwb_size
	zwb_chioce
	zwb_create_file
	zwb_core
}

function zram_size_init_old() {
	let zRamSizeMB="( $RamSizeGB * 1024 ) / 2"
	# use MB avoid 32 bit overflow
	if [ $zRamSizeMB -gt 4096 ]; then
		let zRamSizeMB=4096
	fi
}

function zram_size_init_v4() {
	if [ "$RamSizeGB" -le "3" ];then
		zRamSizeMB=1536
	elif [ "$RamSizeGB" -le "4" ];then
		zRamSizeMB=2048
	elif [ "$RamSizeGB" -le "6" ];then
		zRamSizeMB=3072
	elif [ "$RamSizeGB" -le "8" ];then
		zRamSizeMB=6144
	else
		zRamSizeMB=8192
	fi
}

function zram_size_init() {
	if [ "$ZWBVersion" -eq "4" ] ; then
		zram_size_init_v4
	else
		zram_size_init_old
	fi
}

function base_info() {
	MemSizeKB=$MemTotal
	# RamSizeGB in configure_zram_parameters
	ROMSizeKB=`df -k | grep /data$ | awk '{print $2}'`
	zwb_version
}
# vivo wangjiewen add for zram writeback end

function configure_zram_parameters() {
	MemTotalStr=`cat /proc/meminfo | grep MemTotal`
	MemTotal=${MemTotalStr:16:8}

	# Zram disk - 75% for < 2GB devices .
	# For >2GB devices, size = 50% of RAM size. Limit the size to 4GB.

	let RamSizeGB="( $MemTotal / 1048576 ) + 1"
	diskSizeUnit=M
	base_info
	if [ $RamSizeGB -le 2 ]; then
		let zRamSizeMB="( $RamSizeGB * 1024 ) * 3 / 4"
	else
		zram_size_init
		# let zRamSizeMB="( $RamSizeGB * 1024 ) / 2"
	fi

	# use MB avoid 32 bit overflow
	#if [ $zRamSizeMB -gt 4096 ]; then
		#let zRamSizeMB=4096
	#fi

	if [ -f /sys/block/zram0/disksize ]; then
		if [ -f /sys/block/zram0/use_dedup ]; then
			echo 1 > /sys/block/zram0/use_dedup
		fi
		# vivo wangjiewen add for zram writeback begin
		zwb_init
		# vivo wangjiewen add for zram writeback end
		echo "$zRamSizeMB""$diskSizeUnit" > /sys/block/zram0/disksize
		# vivo wangjiewen add for zram writeback begin
		zwb_parameter
		# vivo wangjiewen add for zram writeback end

		# ZRAM may use more memory than it saves if SLAB_STORE_USER
		# debug option is enabled.
		if [ -e /sys/kernel/slab/zs_handle ]; then
			echo 0 > /sys/kernel/slab/zs_handle/store_user
		fi
		if [ -e /sys/kernel/slab/zspage ]; then
			echo 0 > /sys/kernel/slab/zspage/store_user
		fi

		mkswap /dev/block/zram0
		swapon /dev/block/zram0 -p 32758
	fi
}

function configure_read_ahead_kb_values() {
	MemTotalStr=`cat /proc/meminfo | grep MemTotal`
	MemTotal=${MemTotalStr:16:8}

	dmpts=$(ls /sys/block/*/queue/read_ahead_kb | grep -e dm -e mmc)

	# Set 128 for <= 3GB &
	# set 512 for >= 4GB targets.
	if [ $MemTotal -le 3145728 ]; then
		ra_kb=128
	else
		ra_kb=512
	fi
	if [ -f /sys/block/mmcblk0/bdi/read_ahead_kb ]; then
		echo $ra_kb > /sys/block/mmcblk0/bdi/read_ahead_kb
	fi
	if [ -f /sys/block/mmcblk0rpmb/bdi/read_ahead_kb ]; then
		echo $ra_kb > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
	fi
	for dm in $dmpts; do
		echo $ra_kb > $dm
	done
}

function configure_memory_parameters() {
	# Set Memory parameters.

	# Set swappiness to 100 for all targets
	echo 100 > /proc/sys/vm/swappiness

	# Disable wsf for all targets beacause we are using efk.
	# wsf Range : 1..1000 So set to bare minimum value 1.
	echo 1 > /proc/sys/vm/watermark_scale_factor
	configure_zram_parameters
	#configure_read_ahead_kb_values

	#Spawn 2 kswapd threads which can help in fast reclaiming of pages
	echo 2 > /proc/sys/vm/kswapd_threads
}

# Core control parameters for silver
echo 0 0 0 0 1 1 > /sys/devices/system/cpu/cpu0/core_ctl/not_preferred
echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
echo 60 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
echo 40 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
echo 100 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
echo 8 > /sys/devices/system/cpu/cpu0/core_ctl/task_thres

# Enable Core control for Silver
echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/enable

# Disable Core control on gold
echo 0 > /sys/devices/system/cpu/cpu6/core_ctl/enable

# Setting b.L scheduler parameters
echo 65 > /proc/sys/kernel/sched_downmigrate
echo 71 > /proc/sys/kernel/sched_upmigrate
echo 85 > /proc/sys/kernel/sched_group_downmigrate
echo 100 > /proc/sys/kernel/sched_group_upmigrate
echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks
echo 0 > /proc/sys/kernel/sched_coloc_busy_hysteresis_enable_cpus
echo 0 > /proc/sys/kernel/sched_busy_hysteresis_enable_cpus
echo 5 > /proc/sys/kernel/sched_ravg_window_nr_ticks

# disable unfiltering
echo 20000000 > /proc/sys/kernel/sched_task_unfilter_period

# cpuset parameters
echo 0-5 > /dev/cpuset/background/cpus
echo 0-5 > /dev/cpuset/system-background/cpus

# Turn off scheduler boost at the end
echo 0 > /proc/sys/kernel/sched_boost

# configure governor settings for silver cluster
echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
echo 1113600 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
echo 576000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq

# configure governor settings for gold cluster
echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
echo 0 > /sys/devices/system/cpu/cpufreq/policy6/schedutil/down_rate_limit_us
echo 0 > /sys/devices/system/cpu/cpufreq/policy6/schedutil/up_rate_limit_us
echo 1228800 > /sys/devices/system/cpu/cpufreq/policy6/schedutil/hispeed_freq
echo 691200 > /sys/devices/system/cpu/cpufreq/policy6/scaling_min_freq

# Colocation V3 settings
echo 680000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/rtg_boost_freq
echo 0 > /sys/devices/system/cpu/cpufreq/policy6/schedutil/rtg_boost_freq
echo 51 > /proc/sys/kernel/sched_min_task_util_for_boost
echo 35 > /proc/sys/kernel/sched_min_task_util_for_colocation

# sched_load_boost as -6 is equivalent to target load as 85. It is per cpu tunable.
echo -6 > /sys/devices/system/cpu/cpu6/sched_load_boost
echo -6 > /sys/devices/system/cpu/cpu7/sched_load_boost
echo 85 > /sys/devices/system/cpu/cpufreq/policy6/schedutil/hispeed_load

# configure input boost settings
echo "0:1113600" > /sys/devices/system/cpu/cpu_boost/input_boost_freq
echo 120 > /sys/devices/system/cpu/cpu_boost/input_boost_ms

# Enable bus-dcvs
for device in /sys/devices/platform/soc
do
	for cpubw in $device/*cpu-cpu-ddr-bw/devfreq/*cpu-cpu-ddr-bw
	do
		cat $cpubw/available_frequencies | cut -d " " -f 1 > $cpubw/min_freq
		echo "bw_hwmon" > $cpubw/governor
		echo "762 1144 1720 2086 2597 2929 3879 5161 5931 6881 7980" > $cpubw/bw_hwmon/mbps_zones
		echo 4 > $cpubw/bw_hwmon/sample_ms
		echo 68 > $cpubw/bw_hwmon/io_percent
		echo 20 > $cpubw/bw_hwmon/hist_memory
		echo 0 > $cpubw/bw_hwmon/hyst_length
		echo 80 > $cpubw/bw_hwmon/down_thres
		echo 0 > $cpubw/bw_hwmon/guard_band_mbps
		echo 250 > $cpubw/bw_hwmon/up_scale
		echo 1600 > $cpubw/bw_hwmon/idle_mbps
		echo 40 > $cpubw/polling_interval
	done

	# configure compute settings for silver latfloor
	for latfloor in $device/*cpu0-cpu*latfloor/devfreq/*cpu0-cpu*latfloor
	do
		cat $latfloor/available_frequencies | cut -d " " -f 1 > $latfloor/min_freq
		echo 8 > $latfloor/polling_interval
	done

	# configure compute settings for gold latfloor
	for latfloor in $device/*cpu6-cpu*latfloor/devfreq/*cpu6-cpu*latfloor
	do
		cat $latfloor/available_frequencies | cut -d " " -f 1 > $latfloor/min_freq
		echo 8 > $latfloor/polling_interval
	done

	# configure mem_latency settings for DDR scaling
	for memlat in $device/*lat/devfreq/*lat
	do
		cat $memlat/available_frequencies | cut -d " " -f 1 > $memlat/min_freq
		echo 8 > $memlat/polling_interval
		echo 400 > $memlat/mem_latency/ratio_ceil
	done

	#Gold CPU6 L3 ratio ceil
	for l3gold in $device/*cpu6-cpu-l3-lat/devfreq/*cpu6-cpu-l3-lat
	do
		echo 4000 > $l3gold/mem_latency/ratio_ceil
		echo 25000 > $l3gold/mem_latency/wb_filter_ratio
		echo 60 > $l3gold/mem_latency/wb_pct_thres
	done

	#Gold CPU7 L3 ratio ceil
	for l3gold in $device/*cpu7-cpu-l3-lat/devfreq/*cpu7-cpu-l3-lat
	do
		echo 4000 > $l3gold/mem_latency/ratio_ceil
		echo 25000 > $l3gold/mem_latency/wb_filter_ratio
		echo 60 > $l3gold/mem_latency/wb_pct_thres
	done

done

echo N > /sys/module/lpm_levels/parameters/sleep_disabled

configure_memory_parameters

setprop vendor.post_boot.parsed 1
