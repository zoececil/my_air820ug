module(...,package.seeall)

local enable = true
local i2cslaveaddr = 0x18
local i2cid = 2

-- 初始化i2c
local function i2cInit()
    if i2c.setup(i2cid,i2c.SLOW) ~= i2c.SLOW then
        log.error("I2c.init","fail")
        return
    end
end

-- 读i2c
local function i2cRead(addr,len)
    i2c.send(i2cid,i2cslaveaddr,addr)
    return i2c.recv(i2cid,i2cslaveaddr,len)
end

-- 写i2c
local function i2cWrite(addr,...)
    return i2c.send(i2cid,i2cslaveaddr,{addr,...})
end

-- 初始化
local function sensorInit()
    i2cWrite(0x1E,0x05)--打开操作权限，0x1E 寄存器写 0x05
    local sl_val = i2cRead(0x57,1) --读取 0x57 寄存器当前配置
    if #sl_val > 0 then
        log.info("sl_val", sl_val:toHex())
        sl_val = bit.bor(string.byte(sl_val),0x40) --I2C_PU 置 1
        i2cWrite(0x57,sl_val)

        --设置参数
        i2cWrite(0x20,0x37)
        i2cWrite(0x21,0x11)
        i2cWrite(0x22,0x40)
        i2cWrite(0x23,0x88)
    else
        enable = false
    end
end

local function update()
    if not enable then
        log.error("板载加速度计无效")
        return
    end
    local data = i2cRead(0xa8,6)
    log.info("read i2c",data:toHex())
    if #data ~= 6 then return end
    --Convert the data to 10 bits
    data = string.char(
        data:byte(1)%8,data:byte(2),
        data:byte(3)%8,data:byte(4),
        data:byte(5)%8,data:byte(6)
    )
    _,xa,ya,za = pack.unpack(data,">HHH")
    if xa > 127 then xa = xa - 256 end
    if ya > 127 then ya = ya - 256 end
    if za > 127 then za = za - 256 end
    log.info("xyz",xa,ya,za)
end

sys.taskInit(function ()
    sys.wait(5000)
    i2cInit()
    sensorInit()
    while true do
        sys.wait(1000)
        update()
    end
end)