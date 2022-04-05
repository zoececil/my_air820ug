require "net"

local myNets_Temp = {}

function myNets_Temp.showRssi()
    val_Rssi = net.getRssi()
    val_dBm = 2*val_Rssi-113
    log.info("showRssi(dBm)", val_dBm)

end


return myNets_Temp