cd generated
#  echo "*** Running STA on " $testCase
testCase=GPIO
sta -no_init -no_splash -exit ../synth/GPIO.sta.tcl | tee ./timing.rpt
timing=`grep slack ./timing.rpt`
if [ -e ../timing_slack.rpt ]; then 
    rm -f ../timing_slack.rpt
fi
echo -e "$testCase = \t $timing" >> ./timing_slack.rpt 
cd ../synth 