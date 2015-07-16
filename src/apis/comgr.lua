local processList = {}
local exit = false
local noAutoExit = false
local removeCodes = {}
function setAutoExit(val)
	noAutoExit = not val
end
function forceExit()
	exit = true
end
function run()
	local firstRun = true
	exit = false
	while (function()
		local rtn = false
		for i, co in pairs(processList) do
			if coroutine.status(co) ~= "dead" then
				rtn = true
			end
		end
		return rtn
	end)() or noAutoExit do
		if exit then
			break
		end
		local event = {}
		if not firstRun then
			event = {os.pullEventRaw()}
		end
		firstRun = false
		for k, co in pairs(processList) do
			if coroutine.status(co) ~= "dead" then
				coroutine.resume(co, unpack(event))
			end
		end
		for k, code in pairs(removeCodes) do
			processList[k] = nil
		end
	end
end
function addProcess(func)
	local co = coroutine.create(func)
	processList[tostring(func)] = co
	return tostring(co)
end
function removeProcess(code)
	removeCodes[code] = true
end
