--- 模块功能：待机界面
-- @author openLuat
-- @module ui.idle
-- @license MIT
-- @copyright openLuat
-- @release 2018.03.27

module(...,package.seeall)

require"misc"
require"ntp"
require"common"
require"testKeypad"

--appid：窗口id
local appid

--[[
函数名：refresh
功能  ：窗口刷新处理
参数  ：无
返回值：无
]]
local function refresh()
    --清空LCD显示缓冲区

    disp.clear()
    local oldColor = lcd.setcolor(0xF100)
    -- disp.puttext(common.utf8ToGb2312("待机界面"),lcd.getxpos(common.utf8ToGb2312("待机界面")),0)
    if testKeypad.page_num==1 then
            disp.puttext(testKeypad.page_num,119,45)
            local lcdvabtt = one_adc.adc_vatinfo
            local vabttstr = "E:"..string.format("%03d",lcdvabtt).."%"
            disp.puttext(vabttstr,0,2)
            disp.puttext(common.utf8ToGb2312("  -"),103,1)
            disp.puttext(common.utf8ToGb2312("  -"),103,2)
            disp.puttext(common.utf8ToGb2312("  -"),103,3)
            disp.puttext(common.utf8ToGb2312(" --"),103,4)
            disp.puttext(common.utf8ToGb2312(" --"),103,5)
            disp.puttext(common.utf8ToGb2312(" --"),103,6)
            disp.puttext(common.utf8ToGb2312("---"),103,7)
            disp.puttext(common.utf8ToGb2312("---"),103,8)
            disp.puttext(common.utf8ToGb2312("---"),103,9)
            disp.puttext(common.utf8ToGb2312("----------------"),0,11)

            -- local wifiinfo = wifiScan_tinfo
            -- local wifiinfostr = string.format("%03d",wifiinfo[0]).."dB"
            -- disp.puttext(wifiinfostr,64,2)
            local wifiinfo = one_nets.val_dBm
            local wifiinfostr = string.format("%03d",one_nets.val_dBm).."dBm"
            disp.puttext(wifiinfostr,54,2)

            local tm = misc.getClock()
            local datestr = string.format("%04d",tm.year).."-"..string.format("%02d",tm.month).."-"..string.format("%02d",tm.day)
            local timestr = string.format("%02d",tm.hour)..":"..string.format("%02d",tm.min)..":"..string.format("%02d",tm.sec)
            --显示日期
            lcd.setcolor(0x07E0)
            disp.puttext(datestr,lcd.getxpos(datestr),30)

            -- disp.puttext(common.utf8ToGb2312("----------------"),lcd.getxpos(common.utf8ToGb2312("----------------")),37)
            --显示时间
            lcd.setcolor(0x001F)
            disp.puttext(timestr,lcd.getxpos(timestr),44)
            disp.puttext(common.utf8ToGb2312("----------------"),0,59)
    elseif testKeypad.page_num==2 then
        disp.puttext(testKeypad.page_num,119,45)
        disp.puttext(common.utf8ToGb2312("学生行为观测"),lcd.getxpos(common.utf8ToGb2312("学生行为观测")),2)
        disp.puttext(common.utf8ToGb2312("----------------"),0,11)
    elseif testKeypad.page_num==3 then
        disp.puttext(testKeypad.page_num,119,45)
        disp.puttext(common.utf8ToGb2312("学生定位"),lcd.getxpos(common.utf8ToGb2312("学生定位")),2)
        disp.puttext(common.utf8ToGb2312("----------------"),0,11)
    
    elseif testKeypad.page_num==4 then
        disp.puttext(testKeypad.page_num,119,45)
        disp.puttext(common.utf8ToGb2312("拍照功能"),lcd.getxpos(common.utf8ToGb2312("拍照功能")),2)
        disp.puttext(common.utf8ToGb2312("----------------"),0,11)
    
    elseif testKeypad.page_num==5 then
        disp.puttext(testKeypad.page_num,119,45)
        disp.puttext(common.utf8ToGb2312("本地对讲"),lcd.getxpos(common.utf8ToGb2312("本地对讲")),2)
        disp.puttext(common.utf8ToGb2312("----------------"),0,11)
    end
    --刷新LCD显示缓冲区到LCD屏幕上
    disp.update()
    lcd.setcolor(oldColor)
end

--窗口类型的消息处理函数表
local winapp =
{
    onUpdate = refresh,
}

--[[
函数名：clkind
功能  ：时间更新处理
参数  ：无
返回值：无
]]
local function clkind()
    if uiWin.isActive(appid) then
        refresh()
    end    
end

--[[
函数名：open
功能  ：打开待机界面窗口
参数  ：无
返回值：无
]]
function open()
    appid = uiWin.add(winapp)
end

ntp.timeSync()
sys.timerLoopStart(clkind,1000)
sys.subscribe("TIME_UPDATE_IND",clkind)
