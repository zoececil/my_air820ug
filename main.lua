PROJECT = 'test'
VERSION = '2.0.0'

PRODUCT_KEY = "v32xEAKsGTIEQxtqgwCldp5aPlcnPs3K"

require 'log'
LOG_LEVEL = log.LOGLEVEL_TRACE
require 'sys'

require "net"
net.startQueryAll(60000, 60000)    --每1分钟查询一次GSM信号强度和基站信息

--此处关闭RNDIS网卡功能
--否则，模块通过USB连接电脑后，会在电脑的网络适配器中枚举一个RNDIS网卡，电脑默认使用此网卡上网，导致模块使用的sim卡流量流失
--如果项目中需要打开此功能，把ril.request("AT+RNDISCALL=0,1")修改为ril.request("AT+RNDISCALL=1,1")即可
--注意：core固件：V0030以及之后的版本、V3028以及之后的版本，才以稳定地支持此功能
ril.request("AT+RNDISCALL=0,1")

--加载控制台调试功能模块（此处代码配置的是uart2，波特率115200）
--此功能模块不是必须的，根据项目需求决定是否加载
--使用时注意：控制台使用的uart不要和其他功能使用的uart冲突
--使用说明参考demo/console下的《console功能使用说明.docx》
--require "console"
--console.setup(2, 115200)

--加载网络指示灯和LTE指示灯功能模块
--根据自己的项目需求和硬件配置决定：1、是否加载此功能模块；2、配置指示灯引脚
--合宙官方出售的Air720U开发板上的网络指示灯引脚为pio.P0_1，LTE指示灯引脚为pio.P0_4
require "netLed"
pmd.ldoset(2,pmd.LDO_VLCD)
netLed.setup(true,pio.P0_1,pio.P0_4)
--网络指示灯功能模块中，默认配置了各种工作状态下指示灯的闪烁规律，参考netLed.lua中ledBlinkTime配置的默认值
--如果默认值满足不了需求，此处调用netLed.updateBlinkTime去配置闪烁时长
--LTE指示灯功能模块中，配置的是注册上4G网络，灯就常亮，其余任何状态灯都会熄灭

--加载错误日志管理功能模块【强烈建议打开此功能】
--如下2行代码，只是简单的演示如何使用errDump功能，详情参考errDump的api
require "errDump"
errDump.request("udp://dev_msg1.openluat.com:12425", nil, true)

--加载远程升级功能模块【强烈建议打开此功能，如果使用了阿里云的OTA功能，可以不打开此功能】
--如下3行代码，只是简单的演示如何使用update功能，详情参考update的api以及demo/update
--PRODUCT_KEY = "v32xEAKsGTIEQxtqgwCldp5aPlcnPs3K"
--require "update"
--update.request()
-------------------------------------------------------------------------------------
--加载uart功能
local one_uart = require("myuart")
sys.taskInit(one_uart.taskRead)
--加载ADC电压采集功能
local one_adc = require("myadc")
sys.timerLoopStart(one_adc.vbatt,1000)
--加载基站定位及信号强度获取
local one_lbsLoc = require("mylbsLoc")
one_lbsLoc.reqLbsLoc()
--获取设备信号强度
local one_nets = require("mynets")
sys.timerLoopStart(one_nets.showRssi,5000)
--获取设备wifi扫描信息
require "mywifiscan"
--加载UI功能测试模块
require"lcd"
require"logo"
---------------------------------------------------------------------------------------
sys.init(0, 0)
sys.run()