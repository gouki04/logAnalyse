local lfs = require "lfs"

--正则表达式
Regexp = "%[LUA ERROR%] .+"
OutFileName = "Log1.txt"

local tEnscriptFile = {}
local function preprocess()
	local inFile = io.open(ensriptFile, "r")
	
	if inFile ~= nil then
		for line in inFile:lines() do
			local key = string.match(line, "fn=([%w%p]+.lua)")
			local value = nil
			if key then
				value = string.match(line, "eifn=([%w_]+)")
				tEnscriptFile[key] = value
			end
		end
	end
	print("preprocess finish")
end


local cache = {}

function exec(fileName, folderName)
	local word = string.sub(fileName, string.len(fileName) - 10)
	if word ~= "zxy_log.txt" then return end
	
	local inFileName = fileName
	local outFileName = OutFileName
	local text   = ""
	local inFile = io.open(inFileName, "r")

	if inFile ~= nil then
		for line in inFile:lines() do
			local sBegin, sEnd = string.find(line, Regexp)
			if sBegin ~= nil then
				
				local txt = string.sub(line, sBegin, sEnd)
				--查询有没该txt
				local t   = cache[txt]
				
				if t == nil then
					t = {}
					cache[txt] = t
					
					--查找EnsriptFile
					local temp = string.match (txt, "%[string \"([%w%p]+)\"%]")
					
					if temp then
						temp 	   = string.gsub(temp, "[%w%p]+/", "")
						--去除...
						temp       = string.gsub(temp, "%.%.%.", "")
						cache[txt]["target"] = temp
					end
				end
				
				table.insert(t, folderName)
			end
		end
	end
	
	print("success write to cache" .. fileName)
	inFile:close()	
end

function attrdir(path, folderName, func)
	for file in lfs.dir(path) do   
		if file ~= "." and file ~= ".." then  
			local f = path..'/'..file           
			local attr = lfs.attributes (f)        

            if attr.mode == 'file' then
                func(f, folderName)
			elseif attr.mode == 'directory' then
				attrdir(f, file, func)
            end
		end
	end
end

function writeInFile(outFileName)
	local outFile  = io.open(outFileName, "w+")
	local errorNum = 0
	if outFile ~= nil then
		for k,v in pairs(cache) do
			outFile:write(k .. "\n")
			
			if v then
				local targetTxt = v["target"]
				if targetTxt then
					--查找对应未加密文件名
					for k,v in pairs(tEnscriptFile) do
						if string.find(v, targetTxt) then
							outFile:write("\t\t" .. k .. "\n")
						end
					end
					
				end
				
				for _,v in ipairs(v) do
					outFile:write("\t\t\t" .. v .. "\n")
				end
			end
			
			errorNum = errorNum + 1
			outFile:flush()
			print("success write error number:" .. errorNum)
		end
		
		print("success " .. outFileName)
		outFile:close()
	else
		print("fail " .. outFileName)
	end
end

preprocess()
attrdir(filePath .. FolderName .. "/", FolderName, exec)
writeInFile(filePath .. "log" .. FolderName .. ".txt")