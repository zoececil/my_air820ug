require "misc"

local myAdc_Temp = {}

-- myAdc_Temp.Adc_ID = 1
myAdc_Temp.adc_vatinfo = 100

function myAdc_Temp.vbatt()
    myAdc_Temp.adc_vatinfo = misc.getVbatt() / 45
    if myAdc_Temp.adc_vatinfo>=100 then
        myAdc_Temp.adc_vatinfo = 100
    elseif myAdc_Temp.adc_vatinfo<=0 then
        myAdc_Temp.adc_vatinfo=0
    end

    log.info("vbatt.read(mV)",myAdc_Temp.adc_vatinfo)
end

-- sys.timerLoopStart(myAdc_Temp.vbatt,1000)

return myAdc_Temp
