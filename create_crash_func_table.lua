-- lua file system
local lfs = require('lfs')

local t_offset_2_func = {}

local function collect_ios_crash_log(filename)
	local file = io.open(filename, 'r')
	local content = file:read('*a')
	local _,_,base_add = string.find(content, '(0x%x+) %-   0x%x+ %+zxy armv7')
	if base_add then
		base_add = tonumber(base_add)
		string.gsub(content, '%d%s*zxy%s*(0x%x+) ([^\n]*)',
			function(add, func)
				local offset = tonumber(add) - base_add
				t_offset_2_func[offset] = func
			end)
	end
end

local function collect_ios_crash_log2(filename)
	local file = io.open(filename, 'r')
	local content = file:read('*a')
	local _,_,base_add = string.find(content, '(0x%x+) %-%s*0x%x+%s*libsystem_kernel%.dylib armv7')
	if base_add then
		base_add = tonumber(base_add)
		string.gsub(content, '%d%s*libsystem_kernel%.dylib%s*(0x%x+) ([^\n]*)',
			function(add, func)
				local offset = tonumber(add) - base_add
				t_offset_2_func[offset] = func
			end)
	end
end

local function collect_all(rootpath)
	local function collect_dir(rootpath)
		for file in lfs.dir(rootpath) do
			if file ~= '.' and file ~= '..' then
				local path = rootpath .. '\\' .. file
				local attr = lfs.attributes(path)

				if attr.mode == 'directory' then
					collect_dir(path)
				elseif string.find(file, 'crash_readable') then
					collect_ios_crash_log2(path)
				end
			end
		end
	end
	collect_dir(rootpath)
end

local function create_crash_func_table(path)
	collect_all(path)

	print('local t = {')
	for i,v in pairs(t_offset_2_func) do
		print('\t['..i..'] = "'..v..'",')
	end
	print('}')
end

create_crash_func_table('D:\\zxy\\zxy_log\\ios')
