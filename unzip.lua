-- lua file system
local lfs = require('lfs')

local year, mon, day = 2014, 1, 23
local t_time = {year=year, month=mon, day=day, hour=0, min=0, sec=0}

local rootpath = 'D:\\zxy\\zxy_log'
local date_folder_name = os.date('%Y-%m-%d', os.time(t_time))

-- 解压文件
local function extractFileFromZip(file, outDir)
	os.execute('7z x "'..file..'" -y -aos -o"'..outDir..'"')
end

-- 将2个log的zip包解压出来
local function prepare(rootpath, log_date)
	local tar_name_1 = rootpath..'/'..log_date..'.tar'
	local tar_gz_name_1 = tar_name_1..'.gz'
	local tar_name_2 = rootpath..'/'..log_date..' (1).tar'
	local tar_gz_name_2 = tar_name_2..'.gz'

	extractFileFromZip(tar_gz_name_1, rootpath)
	extractFileFromZip(tar_name_1, rootpath..'/logs')
	extractFileFromZip(tar_gz_name_2, rootpath)
	extractFileFromZip(tar_name_2, rootpath..'/logs')

	os.remove(tar_name_1)
	os.remove(tar_name_2)

	rootpath = rootpath..'/'..log_date
end

-- 将所有log的zip解压并分到安卓或ios文件夹里
local function extractAndSplitToAndroid_ios(rootpath)
	local ios_rootpath = rootpath..'/ios'
	local android_rootpath = rootpath..'/android'

	lfs.mkdir(ios_rootpath)
	lfs.mkdir(android_rootpath)

	for file in lfs.dir(rootpath) do
        if file ~= '.' and file ~= '..' then
            local path = rootpath .. '\\' .. file
			local attr = lfs.attributes(path)

			if attr.mode == 'file' then
				local _,_,folder = string.find(file, '([^%.]*)')
				if string.find(file, 'ios_crash') then
					lfs.mkdir(ios_rootpath..'/'..folder)
					extractFileFromZip(path, ios_rootpath..'/'..folder)
				else
					lfs.mkdir(android_rootpath..'/'..folder)
					extractFileFromZip(path, android_rootpath..'/'..folder)
				end

				os.remove(path)
			end
        end
    end
end

local function analysisAndroidDmp(rootpath)
	for file in lfs.dir(rootpath) do
        if file ~= '.' and file ~= '..' then
            local path = rootpath .. '\\' .. file
			local attr = lfs.attributes(path)

			if attr.mode == 'file' then
				os.execute('')
			end
        end
    end
end

local function getTheCrashThreadStack(rootpath)
	for file in lfs.dir(rootpath) do
        if file ~= '.' and file ~= '..' then
            local path = rootpath .. '\\' .. file
			local attr = lfs.attributes(path)

			if attr.mode == 'directory' then
				getTheCrashThreadStack(path)
			elseif attr.mode == 'file' then
				if string.find(file, '_ret.txt') then
					local f = io.open(path, 'r')
					local o_f = io.open(rootpath .. '\\crashStack.txt', 'w')

					local content = f:read('*a')
					local _,_,crashContent = content:find('Thread %d* %(crashed%)(.*)Thread')
					if crashContent then
						print('handle '..path)
						crashContent:gsub('%d+%s*libzxy.so!.-\n',
							function(c)
								o_f:write(c)
							end)
					end

					o_f:flush()
					o_f:close()
				end
			end
        end
    end
end

--prepare(rootpath, date_folder_name)

--extractAndSplitToAndroid_ios(rootpath..'/logs/'..date_folder_name)
getTheCrashThreadStack(rootpath)
