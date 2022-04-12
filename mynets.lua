require "net"

local myNets_Temp = {}
myNets_Temp.val_dBm=-69
val_Rssi = 28

function myNets_Temp.showRssi()
    val_Rssi = net.getRssi()
    myNets_Temp.val_dBm = 2*val_Rssi-113
    log.info("showRssi(dBm)", myNets_Temp.val_dBm)

end


return myNets_Temp
