#!/vendor/bin/sh

#AI_FW_CmPerf

#if error occur, quiet at once and dont run continue
set -e

setprop persist.vendor.antdef.aiuiperfmode.log log_start
testfile=/vendor/bin/aiuiperfmode.sh
if [ -a $testfile ]
then
 perfExist=`/vendor/bin/getprop persist.vendor.antdef.aiuiperfmode.running`
    if [[ $perfExist == "1" ]]
    then
      #perf 1: PPM================disable PPM for cmPerf
      #rc:write /proc/ppm/enabled 0
      setprop persist.vendor.antdef.aiuiperfmode.log PERF_OPEN_disable_ppm
      echo 0 > /proc/ppm/enabled

      #perf 2: THER====================stop thermal
      #check:adb shell getprop vendor.thermal.manager.is_ht120
      setprop persist.vendor.antdef.aiuiperfmode.log PERF_OPEN_disable_thermal
      thermal_manager /vendor/etc/.tp/.ht120.mtc

      #perf 3: DDR=======================boost ddr for cmperf
      #check:adb shell "cat /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_dump | grep -e uv -e khz -e CONTROL -e VCORE_OPP -e DDR_OPP -e LEVEL -e RSV_9"
      #check:adb shell "cat /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_opp_table"
      #rc: write /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp 0
      setprop persist.vendor.antdef.aiuiperfmode.log PERF_OPEN_boost_ddr
      #echo 1 > /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp

     setprop persist.vendor.antdef.aiuiperfmode.log PERF_OPEN_ok
    else
      #restore 1: enable PPM for cmNormal
      #rc: write /proc/ppm/enabled 1
      setprop persist.vendor.antdef.aiuiperfmode.log PERF_CLOSE_enable_ppm
      echo 1 > /proc/ppm/enabled

      #restore 2: start powerhal and thermal
      /vendor/bin/setprop persist.vendor.antdef.aiuiperfmode.log PERF_OPEN_enable_thermal
      thermal_manager


      #restore 3: release ddr for cmNormal
      #rc: write /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp -1
      setprop persist.vendor.antdef.aiuiperfmode.log PERF_CLOSE_unboost_ddr
      #echo -1 > /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp

     setprop persist.vendor.antdef.aiuiperfmode.log PERF_CLOSE_to_normal
    fi

    if [[ $perfExist == "2" ]]
    then
      #perf 1: POWRRHAL=================stop powerhal
      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_OPEN_disable_powerhal
      setprop persist.vendor.powerhal.enable 0
      #stop power-hal-1-0
      #start power-hal-1-0

      #save 2: CPU=======================limit small cpu max to 1503 Mhz, limit big cpu max to 1140 Mhz
      #check:adb shell "cat /proc/ppm/dump_policy_list"
      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_OPEN_limit_cpu
      #echo 15 5 15 11 > /proc/perfmgr/boost_ctrl/cpu_ctrl/boot_freq
      #enable PPM_POLICY_SYS_BOOST
      echo 7 0 > /proc/ppm/policy_status
      echo 9 1 > /proc/ppm/policy_status
      #echo 0 <cluster> <min_freq_kHz> <max_freq_kHz>  > /proc/ppm/policy/sysboost_cluster_freq_limit
      echo 0 0 15 5 > /proc/ppm/policy/sysboost_cluster_freqidx_limit
      echo 0 1 15 11 > /proc/ppm/policy/sysboost_cluster_freqidx_limit

      #save 3: GPU========================limit gpu 580Mhz
      #check : adb shell "cat /proc/gpufreq/gpufreq_var_dump"
      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_OPEN_limit_gpu
      #echo 26 > /sys/kernel/ged/hal/custom_upbound_gpu_freq

      #save 4: DDR=========================limit ddr 1866Mhz
      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_OPEN_limit_ddr
      #echo 14 > /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp
      #echo 14 > /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp

      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_OPEN_ok
    else
      #restore 1: enable powerhal
      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_CLOSE_enable_powerhal
      setprop persist.vendor.powerhal.enable 1
      #stop power-hal-1-0
      #start power-hal-1-0

      #restore 2: cpu no thing to limit
      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_CLOSE_no_limit_cpu
      #echo -1 -1 -1 -1 > /proc/perfmgr/boost_ctrl/cpu_ctrl/boot_freq
      echo 0 0 15 0 > /proc/ppm/policy/sysboost_cluster_freqidx_limit
      echo 0 1 15 0 > /proc/ppm/policy/sysboost_cluster_freqidx_limit
      echo 9 0 > /proc/ppm/policy_status
      echo 7 1 > /proc/ppm/policy_status
      

      #restore 3: gpu no thing to limit
      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_CLOSE_no_limit_gpu
      #echo -1 > /sys/kernel/ged/hal/custom_upbound_gpu_freq

      #restore 4: ddr no thing to limit
      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_CLOSE_no_limit_ddr
      #echo -1 > /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp

      setprop persist.vendor.antdef.aiuiperfmode.savelog SAVE_CLOSE_to_normal
    fi

fi
