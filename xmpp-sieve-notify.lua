-- 
local io=require "io"
local http=require "socket.http"
local ltn12=require "ltn12"
local mime=require "mime"

require "config"

-- vars

local jid=config.jid
local passwd=config.passwd
local url=config.url

-- arg check
if #arg ~= 1 then
    error("wrong number of arguments")
end

if not string.match(arg[1],"^%w+@%w+%.%w+") or not string.match(arg[1],"^%w+@%w+%.%w+/%w+$") then
    error("argument "..arg[1].." is not a jid")
end

local receiver=arg[1]
local body=io.read("*all")

local _,c = http.request{url=url.."/"..receiver, method="POST", headers={["Content-Type"] = "text/plain", ["Content-Length"] = body:len(), ["Authorization"] = "Basic "..(mime.b64(jid..":"..passwd)) }, source=ltn12.source.string(body) }

if c == 201 then
    do return end
else
    error("invalid status code")
end
