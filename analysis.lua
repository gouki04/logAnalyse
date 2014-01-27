-- lua file system
local lfs = require('lfs')

local year, mon, day = 2014, 1, 1
local t_time = {year=year, month=mon, day=day, hour=0, min=0, sec=0}

local rootpath = 'D:\\zxy\\zxy_log\\logs'
local report_path = 'D:\\zxy\\zxy_log\\report\\report-2014-01-01.txt'
local date_folder_name = os.date('%Y-%m-%d', os.time(t_time))

local report_file = io.open(report_path, 'w+')
local function cout(...)
	--print(...)
	report_file:write(...)
	report_file:write('\n')
end

local function table_cnt(t)
	local sum = 0
	for i,v in pairs(t) do
		sum = sum + 1
	end
	return sum
end

local function toPercent(num, sum)
	return ''..num..'\t'..math.floor(num / sum * 100)..'%'
end

-- 统计一下基本信息
local function statistics_base(rootpath)
	local t_crash_info = {}

	local function collect_base_info(rootpath)
		local t_tmp_date = {year=year, month=mon, day=day, hour=0, min=0, sec=0}

		for file in lfs.dir(rootpath) do
			if file ~= '.' and file ~= '..' then
				local path = rootpath .. '\\' .. file
				local attr = lfs.attributes(path)

				if attr.mode == 'directory' then
					local _,_,idx,id,hour,min,sec = string.find(file, '([^_]*)_%[(%d*)%]_%[(%d%d)_(%d%d)_(%d%d)%]')
					idx = tonumber(idx)

					t_tmp_date.hour = hour
					t_tmp_date.min = min
					t_tmp_date.sec = sec

					local info = {idx=idx, id=id, crash_time=os.time(t_tmp_date)}
					t_crash_info[idx] = info
				end
			end
		end
	end

	collect_base_info(rootpath..'/android')
	collect_base_info(rootpath..'/ios')

	cout('crash数量：'..table_cnt(t_crash_info))

	local t_player_cnt = {}
	for idx,info in pairs(t_crash_info) do
		t_player_cnt[info.id] = true
	end
	cout('crash人数：'..table_cnt(t_player_cnt))

	local base_time = os.time(t_time)
	local t_crash_time = {}
	for idx,info in pairs(t_crash_info) do
		local diff_time = os.difftime(info.crash_time, base_time)
		local hour = math.floor((diff_time) / 3600)
		if t_crash_time[hour] == nil then
			t_crash_time[hour] = 1
		else
			t_crash_time[hour] = t_crash_time[hour] + 1
		end
	end

	--[[
	cout('crash上传时间段：')
	for hour = 0, 23 do
		cout('['..hour..'] : '..(t_crash_time[hour] or 0))
	end]]
end

-- 统计所有log里的游戏信息
local function statistics_game_info(rootpath, dir_filter, filter)
	local t_tmp_date = {year=year, month=0, day=0, hour=0, min=0, sec=0}

	-- 统计一个文件的信息
	local function statistics_single_file(filename)
		local min_time = nil
		local max_time = nil

		local t_last_mapid = nil
		local t_last_panel = nil

		local isConnectCS = false
		local isConnectGS = false

		local file = io.open(filename, 'r')
		for line in file:lines() do
			local i,j,mon,day,hour,min,sec,content = string.find(line, '(%d%d)-(%d%d) (%d%d):(%d%d):(%d%d) : %[%w+%] (.*)')
			if i ~= nil and j ~= nil then
				t_tmp_date.month = tonumber(mon)
				t_tmp_date.day = tonumber(day)
				t_tmp_date.hour = tonumber(hour)
				t_tmp_date.min = tonumber(min)
				t_tmp_date.sec = tonumber(sec)

				local line_time = os.time(t_tmp_date)

				-- statistics duration
				if min_time == nil then
					min_time = line_time
				elseif min_time > line_time then
					min_time = line_time
				end

				if max_time == nil then
					max_time = line_time
				elseif max_time < line_time then
					max_time = line_time
				end

				-- statistics mapid
				local _,_,mapid = string.find(content, 'mapid = (%d+)')
				if mapid ~= nil then
					mapid = tonumber(mapid)
					if t_last_mapid == nil then
						t_last_mapid = {time=line_time, mapid=mapid}
					elseif t_last_mapid.time < line_time then
						t_last_mapid.time = line_time
						t_last_mapid.mapid = mapid
					end
				end

				-- statistics panel
				local _,_,panel = string.find(content, '%[Panel%]:(.*)')
				if panel ~= nil and panel ~= 'NpcTaskDialog' --[[and panel ~= 'ChengjiuPanel' and panel ~= 'Map']] then
					if t_last_panel == nil then
						t_last_panel = {time=line_time, panel=panel}
					elseif t_last_panel.time < line_time then
						t_last_panel.time = line_time
						t_last_panel.panel = panel
					end
				end

				local _,_,_isConnectCS = string.find(content, '(连接公共线服务器成功鸟)')
				if _isConnectCS ~= nil then
					isConnectCS = true
				end

				local _,_,_isConnectGS = string.find(content, '(连接游戏服务器成功鸟)')
				if _isConnectGS ~= nil then
					isConnectGS = true
				end
			end
		end

		return min_time, max_time, t_last_mapid, t_last_panel, isConnectCS, isConnectGS
	end

	-- 遍历所有log进行统计
	local t_durations, t_crash_times, t_mapids, t_panels = {}, {}, {}, {}
	local welcomeDlg_connect_cs, welcomeDlg_not_connect_cs = 0, 0

	local function statistics_dir(rootpath)
		for file in lfs.dir(rootpath) do
			if file ~= '.' and file ~= '..' then
				local path = rootpath .. '\\' .. file
				local attr = lfs.attributes(path)

				if attr.mode == 'directory' then
					if not dir_filter or dir_filter(path) then
						statistics_dir(path)
					end
				elseif file == 'zxy_log.txt' then
					if not filter or filter(path) then
						local min_time, max_time, mapid, panel, isConnectCS, isConnectGS = statistics_single_file(path)
						if max_time then
							table.insert(t_crash_times, max_time)
							if min_time then
								table.insert(t_durations, max_time - min_time)
							end
						end

						local isInArean = false
						if max_time then
							local base_time = os.time(t_time) + 20.5 * 3600
							local diff_time = os.difftime(max_time, base_time)
							if diff_time > 0 and diff_time <= 30*60 then
								isInArean = true
							end
						end

						if true or isInArean then
							if mapid then
								mapid = mapid.mapid
								if t_mapids[mapid] == nil then
									t_mapids[mapid] = {mapid=mapid, cnt=1}
								else
									t_mapids[mapid].cnt = t_mapids[mapid].cnt + 1
								end
							end

							if panel then
								panel = panel.panel
								if t_panels[panel] == nil then
									t_panels[panel] = {panel=panel, cnt=1}
								else
									t_panels[panel].cnt = t_panels[panel].cnt + 1
								end
							end
						end
					end
				end
			end
		end
	end

	statistics_dir(rootpath)

	cout('welcomeDlg_connect_cs : '..welcomeDlg_connect_cs)
	cout('welcomeDlg_not_connect_cs : '..welcomeDlg_not_connect_cs)
	cout('\n')

	-- 打印crash时间的统计
	local base_time = os.time(t_time)
	local t_crash_time_cnt = {}
	for _,crash_time in ipairs(t_crash_times) do
		local diff_time = os.difftime(crash_time, base_time)
		local hour = math.floor((diff_time) / 3600)
		if t_crash_time_cnt[hour] == nil then
			t_crash_time_cnt[hour] = { hour=hour, cnt=1 }
		else
			t_crash_time_cnt[hour].cnt = t_crash_time_cnt[hour].cnt + 1
		end
	end

	local t_crash_time_cnt_2 = {}
	for _,v in pairs(t_crash_time_cnt) do
		table.insert(t_crash_time_cnt_2, v)
	end

	table.sort(t_crash_time_cnt_2,
		function(a, b)
			return a.cnt > b.cnt
		end)

	local totalCrash = #t_crash_times
	local cout_cnt = 10
	cout('crash时间段：')
	for k,v in pairs(t_crash_time_cnt_2) do
		cout('['..v.hour..'] : '..toPercent(v.cnt, totalCrash))

		cout_cnt = cout_cnt - 1
		if cout_cnt <= 0 then
			break
		end
	end
	cout('\n')

	-- 打印游戏时长的统计
	local t_duration_cnt = {0,0,0,0,0,0,0}
	for _,v in ipairs(t_durations) do
		if v < 60 then
			t_duration_cnt[1] = t_duration_cnt[1] + 1
		elseif v < 60 * 10 then
			t_duration_cnt[2] = t_duration_cnt[2] + 1
		elseif v < 60 * 30 then
			t_duration_cnt[3] = t_duration_cnt[3] + 1
		elseif v < 60 * 60 then
			t_duration_cnt[4] = t_duration_cnt[4] + 1
		elseif v < 60 * 60 * 2 then
			t_duration_cnt[5] = t_duration_cnt[5] + 1
		elseif v < 60 * 60 * 3 then
			t_duration_cnt[6] = t_duration_cnt[6] + 1
		else
			t_duration_cnt[7] = t_duration_cnt[7] + 1
		end
	end

	local totalCrash = #t_durations

	cout('游戏时长：')
	cout('一分钟内：'..toPercent(t_duration_cnt[1], totalCrash))
	cout('十分钟内：'..toPercent(t_duration_cnt[2], totalCrash))
	cout('半小时内：'..toPercent(t_duration_cnt[3], totalCrash))
	cout('一小时内：'..toPercent(t_duration_cnt[4], totalCrash))
	cout('两小时内：'..toPercent(t_duration_cnt[5], totalCrash))
	cout('三小时内：'..toPercent(t_duration_cnt[6], totalCrash))
	cout('三小时后：'..toPercent(t_duration_cnt[7], totalCrash))
	cout('\n')

	-- 打印crash时所在场景的统计
	local totalCrash = 0
	local t_mapid_cnt = {}
	for _,v in pairs(t_mapids) do
		table.insert(t_mapid_cnt, v)
		totalCrash = totalCrash + v.cnt
	end

	table.sort(t_mapid_cnt,
		function(a, b)
			return a.cnt > b.cnt
		end)

	local cout_cnt = 10
	cout('崩溃时所在场景：')
	for k,v in pairs(t_mapid_cnt) do
		cout('['..v.mapid..'] : '..toPercent(v.cnt, totalCrash))

		cout_cnt = cout_cnt - 1
		if cout_cnt <= 0 then
			break
		end
	end
	cout('\n')


	-- 打印crash时最后打开的面板的统计
	local totalCrash = 0
	local t_panel_cnt = {}
	for _,v in pairs(t_panels) do
		table.insert(t_panel_cnt, v)
		totalCrash = totalCrash + v.cnt
	end

	table.sort(t_panel_cnt,
		function(a, b)
			return a.cnt > b.cnt
		end)

	local cout_cnt = 15
	cout('崩溃时最后打开的面板：')
	for k,v in pairs(t_panel_cnt) do
		cout('['..v.panel..'] : '..toPercent(v.cnt, totalCrash))

		cout_cnt = cout_cnt - 1
		if cout_cnt <= 0 then
			break
		end
	end
end

-- 统计手机信息
local function statistics_phone_info(rootpath)
	local function statistics_single_file(filename)
		local file = io.open(filename, 'r')
		local content = file:read('*a')
		local _,_,phone_info_content = string.find(content, 'native error :%s%[(.*)%]')
		if phone_info_content then
			local _,_,Model = string.find(phone_info_content, 'Model:([^\n]*)')
			local _,_,Manufacturer = string.find(phone_info_content, 'Manufacturer:([^\n]*)')
			return Model,Manufacturer
		end

		return nil
	end

	local t_models = {}
	local function statistics_dir(rootpath)
		for file in lfs.dir(rootpath) do
			if file ~= '.' and file ~= '..' then
				local path = rootpath .. '\\' .. file
				local attr = lfs.attributes(path)

				if attr.mode == 'directory' then
					statistics_dir(path)
				elseif file == 'zxy_log.txt' then
					local model,manufacturer = statistics_single_file(path)

					if model then
						if t_models[model] == nil then
							t_models[model] = {model=model, manufacturer=manufacturer, cnt=1}
						else
							t_models[model].cnt = t_models[model].cnt + 1
						end
					end
				end
			end
		end
	end

	statistics_dir(rootpath)

	local t_phone_cnt = {}
	for _,v in pairs(t_models) do
		table.insert(t_phone_cnt, v)
	end

	table.sort(t_phone_cnt,
		function(a, b)
			return a.cnt > b.cnt
		end)

	-- 打印手机信息
	cout('手机信息：')
	for _,v in pairs(t_phone_cnt) do
		cout('['..v.manufacturer..']['..v.model..'] : '..v.cnt)
	end
end

statistics_base(rootpath..'/'..date_folder_name)
cout('\n')

local function dir_filter(dir)
	local _,_,idx,id = string.find(dir, '([^_]*)_%[(%d*)%]_%[(%d%d)_(%d%d)_(%d%d)%]')
	if not id then
		return true
	else
		return id == '10103432'
	end
end

local function ios_filter(dir)
	if string.find(dir, 'ios') then
		return true
	else
		return false
	end
end

local function file_filter(filename)
	local file = io.open(filename, 'r')
	local content = file:read('*a')
	local _,_,phone_info_content = string.find(content, 'native error :%s%[(.*)%]')
	if phone_info_content then
		local _,_,Model = string.find(phone_info_content, 'Model:([^\n]*)')
		local _,_,Manufacturer = string.find(phone_info_content, 'Manufacturer:([^\n]*)')
		return Model == 'M040'
	end

	return false
end

local function arena_filter(filename)
	local file = io.open(filename, 'r')
	local content = file:read('*a')
	local _,_,phone_info_content = string.find(content, 'native error :%s%[(.*)%]')
	if phone_info_content then
		local _,_,Model = string.find(phone_info_content, 'Model:([^\n]*)')
		local _,_,Manufacturer = string.find(phone_info_content, 'Manufacturer:([^\n]*)')
		return Model == 'M040'
	end

	return false
end

statistics_game_info(rootpath..'/'..date_folder_name, nil)
cout('\n')

statistics_phone_info(rootpath..'/'..date_folder_name..'/android')
cout('\n')

report_file:flush()
