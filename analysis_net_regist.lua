local lfs = require "lfs"
local outFileName = "D:\\zxy\\zxy_log\\analysisReport.txt"

string.split = function (str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + string.len(split_char), #str);
    end

    return sub_str_tab;
end

string.trim = function(s)
  return s:match'^%s*(.*%S)' or ''
end

function writeInFile(t_regist, t_unregist, fileName)
	if #t_regist <= 0 and #t_unregist <= 0 then
		return
	end

	local outFile  = io.open(outFileName, "a+")
	local errorNum = 0
	if outFile ~= nil then
		outFile:write(fileName .. "\n")
		outFile:write('regist:' .. "\n")
		for _, r in pairs(t_regist) do
			outFile:write(r.id .. "\t" .. r.func .. "\t" .. tostring(r.once) .. "\n")
		end

		outFile:write('unregist:' .. "\n")
		for _, r in pairs(t_unregist) do
			outFile:write(r.id .. "\t" .. r.func .. "\n")
		end
		outFile:write("\n")
		outFile:flush()
		print("success " .. outFileName)
		outFile:close()
	else
		print("fail " .. outFileName)
	end
end

local function findRegistMsg(filename)
	local t_regist = {}
	local t_unregist = {}

	local file = io.open(filename, 'r')
	local content = file:read('*a')

	content = string.gsub(content, '%-%-%[%[[^%]*]%]%][%-]*', function() return '' end )
	content = string.gsub(content, '%-%-[^\n]*', function() return '' end )

	string.gsub(content, 'gNetRegistMsg%s*%((%d+)%s*,%s*([^%)]*)',
		function(id, func)
			id = tonumber(id)
			local t = string.split(func, ',')
			func = t[1]

			local once = false
			if #t == 2 then
				if string.find(t[2], 'true') then
					once = true
				end
			end

			table.insert(t_regist, {id = id, func = func, once = once})
		end)

	string.gsub(content, 'gNetRemoveMsg*%((%d+)%s*,%s*([^%)]*)',
		function(id, func)
			id = tonumber(id)
			func = func

			table.insert(t_unregist, {id = id, func = func})
		end)

	writeInFile(t_regist, t_unregist, filename)
end

function attrdir(path, func)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local f = path..'/'..file
			local attr = lfs.attributes (f)

            if attr.mode == 'file' then
                func(f)
			elseif attr.mode == 'directory' then
				attrdir(f, func)
            end
		end
	end
end

attrdir('D:\\ZXY\\_ZXY__\\branches\\0.7.x\\Resource\\scripts', findRegistMsg)
--findRegistMsg('D:\\zxy\\_ZXY__\\branches\\0.7.x\\Resource\\scripts\\logic\\battle.lua')
