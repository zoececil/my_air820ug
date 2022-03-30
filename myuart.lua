
-- local my_util = require("utils")
require 'utils'
local my_pm = require("pm")

local myUart_Temp = {}

myUart_Temp.Uart_ID = 1

function myUart_Temp.taskRead()
    local cacheData,frameCnt = "",0
    while true do
        local s = uart.read(myUart_Temp.Uart_ID,"*l")
        if s == "" then            
            if not sys.waitUntil("UART_RECEIVE",100) then
                --uart接收数据，如果100毫秒没有收到数据，则打印出来所有已收到的数据，清空数据缓冲区，等待下次数据接收
                --注意：
                --串口帧没有定义结构，仅靠软件延时，无法保证帧的完整性，如果对帧接收的完整性有严格要求，必须自定义帧结构（参考testUart.lua）
                --因为在整个GSM模块软件系统中，软件定时器的精确性无法保证，例如本demo配置的是100毫秒，在系统繁忙时，实际延时可能远远超过100毫秒，达到200毫秒、300毫秒、400毫秒等
                --设置的延时时间越短，误差越大
                if cacheData:len()>0 then
                    log.info("testUartTask.taskRead","100ms no data, received length",cacheData:len())
                    --数据太多，如果全部打印，可能会引起内存不足的问题，所以此处仅打印前1024字节
                    log.info("testUartTask.taskRead","received data",cacheData:sub(1,1024))
                    cacheData = ""
                    frameCnt = frameCnt+1
                    myUart_Temp.write("received "..frameCnt.." frame")
                end
            end
        else
            cacheData = cacheData..s            
        end
    end

end

function myUart_Temp.write(s)
    log.info("testUartTask.write",s)
    uart.write(myUart_Temp.Uart_ID,s.."\r\n")
end

local function myUart_Temp.writeOk()
    log.info("testUartTask.writeOk")
end

my_pm.wake("testUartTask")
--注册串口的数据发送通知函数
uart.on(myUart_Temp.Uart_ID,"sent",myUart_Temp.writeOk)
uart.on(myUart_Temp.Uart_ID,"receive",function() sys.publish("UART_RECEIVE") end)
--配置并且打开串口
uart.setup(myUart_Temp.Uart_ID,115200,8,uart.PAR_NONE,uart.STOP_1)
--如果需要打开“串口发送数据完成后，通过异步消息通知”的功能，则使用下面的这行setup，注释掉上面的一行setup
--uart.setup(UART_ID,115200,8,uart.PAR_NONE,uart.STOP_1,nil,1)

return myUart_Temp
