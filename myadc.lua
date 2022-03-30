require "misc"

local myAdc_Temp = {}

-- myAdc_Temp.Adc_ID = 1

function myAdc_Temp.vbatt()
    log.info("vbatt.read",misc.getVbatt())
end


return myAdc_Temp
