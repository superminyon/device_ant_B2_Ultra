#!/vendor/bin/sh

#AI_FW_CmPerf

#if error occur, quiet at once and dont run continue
set -e

testfile=/vendor/bin/aiuiboot.sh
if [ -a $testfile ]
then

    boostt=`/vendor/bin/getprop persist.vendor.antdef.aiuiboost.highest`
    if [[ $boostt == "1" ]]
    then
        echo 0 0 > /proc/ppm/policy/ut_fix_freq_idx
        setprop persist.vendor.antdef.aiuiboost.result on
    else
        echo -1 -1 > /proc/ppm/policy/ut_fix_freq_idx
        setprop persist.vendor.antdef.aiuiboost.result off
    fi

fi
