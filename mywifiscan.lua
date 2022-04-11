require"wifiScan"

sys.taskInit(function()
    while true do
        sys.wait(5000)
        
        wifiScan.request(function(result,cnt,tInfo)
            log.info("testWifi.scanCb",result,cnt)
            sys.publish("WIFI_SCAN_IND",result,cnt,tInfo)
        end)
        
        local _,result,cnt,tInfo = sys.waitUntil("WIFI_SCAN_IND")
        if result then
            for k,v in pairs(tInfo) do
                log.info("testWifi.scanCb",k,v)
            end
        end
    end
end)