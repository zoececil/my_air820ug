--- 模块功能：矩阵键盘测试
-- @module powerKey
-- @author openLuat
-- @license MIT
-- @copyright openLuat
-- @release 2018.06.13

require"sys"
module(..., package.seeall)

page_num = 1

local function keyMsg(msg)
    --msg.key_matrix_row：行
    --msg.key_matrix_col：列
    --msg.pressed：true表示按下，false表示弹起
    local keysum = msg.key_matrix_row + msg.key_matrix_col*2
    -- log.info("keyMsg",msg.key_matrix_row,msg.key_matrix_col,msg.pressed)
    if keysum==3 then   
        if msg.pressed then
            log.info("keyMsg","SW4")  

        else

        end
    elseif keysum==1 then
        if msg.pressed then
            log.info("keyMsg","SW5")   --up
            page_num=page_num+1
            if page_num>=5 then
                page_num=1
            end
        else

        end
    elseif keysum==4 then
        if msg.pressed then
            log.info("keyMsg","SW6")   --down
            page_num=page_num-1
            if page_num<=1 then
                page_num=5
            end
        else

        end
    elseif keysum==2 then
        if msg.pressed then
            log.info("keyMsg","SW7")
        else

        end
    end

end


--注册按键消息处理函数
rtos.on(rtos.MSG_KEYPAD,keyMsg)
--初始化键盘阵列
--第一个参数：固定为rtos.MOD_KEYPAD，表示键盘
--第二个参数：目前无意义，固定为0
--第三个参数：表示键盘阵列keyin标记，例如使用了keyin0、keyin1、keyin2、keyin3，则第三个参数为1<<0|1<<1|1<<2|1<<3 = 0x0F
--第四个参数：表示键盘阵列keyout标记，例如使用了keyout0、keyout1、keyout2、keyout3，则第四个参数为1<<0|1<<1|1<<2|1<<3 = 0x0F
rtos.init_module(rtos.MOD_KEYPAD,0,0x0F,0x0F)
