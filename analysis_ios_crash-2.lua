-- lua file system
local lfs = require('lfs')

local year, mon, day = 2013, 12, 15
local t_time = {year=year, month=mon, day=day, hour=0, min=0, sec=0}

local rootpath = 'D:\\zxy\\zxy_log\\logs'
local date_folder_name = os.date('%Y-%m-%d', os.time(t_time))

local function cout(...)
	print(...)
end

local function analysis_ios_crash_log(idx, filename)
	local file = io.open(filename, 'r')
	if not file then return end

	local content = file:read('*a')

	local _,_,content = string.find(content, 'Thread 0 Crashed:%s*%d+%s*%S+%s*0x%x+ ([^\n]+)')
	if content then
		cout(idx..'\t'..content)
	end
end

local function analysis_all(rootpath)
	local function analysis_dir(rootpath)
		for file in lfs.dir(rootpath) do
			if file ~= '.' and file ~= '..' then
				local path = rootpath .. '\\' .. file
				local attr = lfs.attributes(path)

				if attr.mode == 'directory' then
					if string.find(file, 'zxy_ios_crash') then
						local _,_,idx = string.find(file, '([^_]*)_%[(%d*)%]_%[(%d%d)_(%d%d)_(%d%d)%]')
						analysis_ios_crash_log(idx, path..'\\crash_readable.log')
					else
						analysis_dir(path)
					end
				elseif string.find(file, 'crash_readable') then
					--analysis_ios_crash_log(path)
				end
			end
		end
	end
	analysis_dir(rootpath)
end

--analysis_all(rootpath..'\\'..date_folder_name)
analysis_all(rootpath)
