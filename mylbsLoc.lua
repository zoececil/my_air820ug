require "lbsLoc"

local myLbsLoc_Temp = {}

--[[
功能  ：发送查询位置请求
参数  ：无
返回值：无
]]
function myLbsLoc_Temp.reqLbsLoc()   
    lbsLoc.request(myLbsLoc_Temp.getLocCb)
end

--[[
功能  ：获取基站对应的经纬度后的回调函数
参数  ：
		result：number类型，0表示成功，1表示网络环境尚未就绪，2表示连接服务器失败，3表示发送数据失败，4表示接收服务器应答超时，5表示服务器返回查询失败；为0时，后面的3个参数才有意义
		lat：string类型，纬度，整数部分3位，小数部分7位，例如031.2425864
		lng：string类型，经度，整数部分3位，小数部分7位，例如121.4736522
返回值：无
]]
function myLbsLoc_Temp.getLocCb(result,lat,lng,addr,time,locType)
    log.info("testLbsLoc.getLocCb",result,lat,lng)
    --获取经纬度成功
    if result==0 then
        log.info("服务器返回的时间", time:toHex())
        log.info("定位类型，基站定位成功返回0", locType)
    --失败
    else
    end
    sys.timerStart(myLbsLoc_Temp.reqLbsLoc,20000)
end

return myLbsLoc_Temp
-- myLbsLoc_Temp.reqLbsLoc()


