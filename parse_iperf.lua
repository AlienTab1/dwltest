#!/usr/bin/lua

local cjson = require "cjson"

local f = io.stdin
local json = f:read("*all")
f:close()

text = cjson.decode(json)

if text ~= nil and text["error"] ~= nil then
 os.exit(2)
end 


download = text["end"]["sum_received"]["bits_per_second"] 
transfered = text["end"]["sum_received"]["bytes"]
timestamp = text["start"]["timestamp"]["timesecs"]
date = text["start"]["timestamp"]["time"]

print(string.format("%s %d %.2f %s", timestamp, transfered, (download/(1024*1024)), date))

os.exit()
