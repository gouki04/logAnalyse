local lfs = require('lfs')

local rootpath = 'D:\\zxy\\_ZXY__\\美工\\npcStroyFace\\'

local t = {
	['10104.png'] = true,
	['f1.png'] = true,
	['f10000.png'] = true,
	['f10104.png'] = true,
	['f10401.png'] = true,
	['f123.png'] = true,
	['f1301.png'] = true,
	['f1302.png'] = true,
	['f1401.png'] = true,
	['f1501.png'] = true,
	['f1701.png'] = true,
	['f1802.png'] = true,
	['f2.png'] = true,
	['f20108.png'] = true,
	['f21.png'] = true,
	['f2101.png'] = true,
	['f2201.png'] = true,
	['f2301.png'] = true,
	['f2401.png'] = true,
	['f2402.png'] = true,
	['f2501.png'] = true,
	['f2502.png'] = true,
	['f2601.png'] = true,
	['f2602.png'] = true,
	['f2701.png'] = true,
	['f2901.png'] = true,
	['f3.png'] = true,
	['f3001.png'] = true,
	['f30042.png'] = true,
	['f3101.png'] = true,
	['f3201.png'] = true,
	['f4.png'] = true,
	['f40022.png'] = true,
	['f40023.png'] = true,
	['f4201.png'] = true,
	['f4601.png'] = true,
	['f4701.png'] = true,
	['f5002.png'] = true,
	['f51.png'] = true,
	['f5301.png'] = true,
	['f5401.png'] = true,
	['f5501.png'] = true,
	['f56404.png'] = true,
	['f56604.png'] = true,
	['f56704.png'] = true,
	['f5701.png'] = true,
	['f57604.png'] = true,
	['f5801.png'] = true,
	['f6001.png'] = true,
	['f71.png'] = true,
	['f801.png'] = true,
}

for k in pairs(t) do
	local path = rootpath..k
	os.rename(path, 'D:\\zxy\\_ZXY__\\美工\\npcStroyFace2\\'..k)
end

do return end

local function compareFile(a, b)
	local fa = io.open(a, 'r')
	local fb = io.open(b, 'r')

	local ca = fa:read('*a')
	local cb = fb:read('*a')

	local ret = false
	if ca == cb then
		ret = true
	end

	fa:close()
	fb:close()

	return ret
end

local function notifyFileIsSame(a, b)
	if b == nil then
		print(a, '=', 'nil')
	else
		--print(a, '=', b)
	end
end

local function compare()
	local npcFace = 'E:\\zxy\\resourceFiles\\assets\\mapAssets\\npcFace\\'
	local npcStoryFace = 'E:\\zxy\\resourceFiles\\assets\\mapAssets\\npcStoryFace\\'

	local function checkFile(a)
		for file in lfs.dir(npcFace) do
			if file ~= '.' and file ~= '..' then
				local path = npcFace .. '\\' .. file
				local attr = lfs.attributes(path)

				if attr.mode == 'directory' then

				elseif string.find(file, '.swf') then
					if compareFile(a, path) then
						notifyFileIsSame(a, path)
						return
					end
				end
			end
		end

		notifyFileIsSame(a, nil)
	end

	for file in lfs.dir(npcStoryFace) do
		if file ~= '.' and file ~= '..' then
			local path = npcStoryFace .. '\\' .. file
			local attr = lfs.attributes(path)

			if attr.mode == 'directory' then

			elseif string.find(file, '.swf') then
				checkFile(path)
			end
		end
	end
end



local t = {
	'10102',
	'10103',
	'10104',
	'30003',
	'30061',
	'40005',
	'f1',
	'f10000',
	'f10104',
	'f10401',
	'f123',
	'f1301',
	'f1302',
	'f1401',
	'f1501',
	'f1701',
	'f1802',
	'f2',
	'f20108',
	'f21',
	'f2101',
	'f2201',
	'f2301',
	'f2401',
	'f2402',
	'f2501',
	'f2502',
	'f2601',
	'f2602',
	'f2701',
	'f2901',
	'f3',
	'f3001',
	'f30042',
	'f3101',
	'f3201',
	'f4',
	'f40022',
	'f40023',
	'f4201',
	'f4601',
	'f4701',
	'f5002',
	'f51',
	'f5301',
	'f5401',
	'f5501',
	'f56404',
	'f56604',
	'f56704',
	'f5701',
	'f57604',
	'f5801',
	'f6001',
	'f6606',
	'f71',
	'f801',
	'nan1',
	'nan2',
	'nan3',
	'nv1',
	'nv2',
	'nv3',
	'xiaohuxian',
}

local dungeonStroyXml = io.open('D:\\zxy\\_ZXY__\\doc\\cfg\\1.0\\dungeonStory.xml', 'r')
local content = dungeonStroyXml:read('*a')

for i = 1, #t do
	if string.find(content, t[i]) then
		print(t[i], 'found')
	end
end

dungeonStroyXml:close()
