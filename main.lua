PROJECT = 'test'
VERSION = '2.0.0'
require 'log'
LOG_LEVEL = log.LOGLEVEL_TRACE
require 'sys'

one_uart = require("myuart")

sys.taskInit(one_uart.taskRead)

sys.init(0, 0)
sys.run()