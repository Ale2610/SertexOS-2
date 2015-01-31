local args = {...}

local argData = {
  ["-f"] = false,
  ["-o"] = false,
}

if #args > 0 then
  while #args > 0 do
    local arg = table.remove(args, 1)
    if argData[arg] ~= nil then
      argData[arg] = true
    end
  end
end

if _G.SertexOS and not argData["-f"] then
  printError("Found SertexOS data in memory!")
  print("If you want to reload SertexOS, launch with arguments '-f'")
  return
end

_G.SertexOS = {
  build = 1,
  quiet = false,
}

function os.version()
  return "SertexOS 2 b"..SertexOS.build
end

SertexOS.launchArgs = {...}

if OneOS and not argData["-o"] then
  -- devs need some fun too
  --printError("OneOS is not a stable system, and SertexOS 2 requires a stable system.")
  --printError("So what do you *really* want? SertexOS 2 or OneOS?")
  printError("Sorry, SertexOS and OneOS can't run in parallel.")
  print("Please reboot the computer without OneOS and start SertexOS.")
  print("If you *really* want to use OneOS *and* SertexOS, use the command line argument '-o' when starting SertexOS.")
  return
end

if not term.isColor() then
  print("SertexOS 2 is only for advanced computers")
  return
end

-- find base directory
local baseDir = fs.getDir(shell.getRunningProgram())
SertexOS.baseDir = baseDir
os.loadAPI(fs.combine(baseDir, "api"))

-- load extra APIs
if fs.exists(fs.combine(SertexOS.baseDir, "apis")) and fs.isDir(fs.combine(SertexOS.baseDir, "apis")) then
  for i, v in ipairs(fs.list(fs.combine(SertexOS.baseDir, "apis"))) do
    os.loadAPI(fs.combine(fs.combine(SertexOS.baseDir, "apis"), v))
  end
end

-- desktop

function desktop()
	local termW, termH = term.getSize()

	local sidebar = {
		{"Shutdown", function()
			local function printMsg(color)
				term.setBackgroundColor(color)
				term.setTextColor(colors.white)
				term.clear()
				term.setCursorPos(1, 1)
				sertextext.centerDisplay("Shutting Down...")
				sleep(0.1)
			end
			printMsg(colors.white)
			printMsg(colors.lightGray)
			printMsg(colors.gray)
			printMsg(colors.black)
			sleep(0.6)
			os.shutdown()
		end},
		{"Reboot", function()
			local function printMsg(color)
				term.setBackgroundColor(color)
				term.setTextColor(colors.white)
				term.clear()
				term.setCursorPos(1, 1)
				sertextext.centerDisplay("Rebooting...")
				sleep(0.1)
			end
			printMsg(colors.white)
			printMsg(colors.lightGray)
			printMsg(colors.gray)
			printMsg(colors.black)
			sleep(0.6)
			os.reboot()
		end},
		{"Logout", function()
			print("wip")
			sleep(1)
			os.queueEvent("terminate")
		end},
	}

	local sidebarVisible = false
	local sidebarWidth = 0
	for i, v in ipairs(sidebar) do
		if v[1]:len() > sidebarWidth then
			sidebarWidth = v[1]:len()
		end
	end

	local function redraw()
		term.setBackgroundColor(colors.white)
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.red)
		graphics.line(termW, 1, termW, termH, colors.red)
		term.setCursorPos(termW, math.ceil(termH / 2))
		term.setTextColor(colors.white)
		if sidebarVisible then
			graphics.box(termW - sidebarWidth - 5, 1, termW - sidebarWidth - 3, termH, colors.orange)
			graphics.box(termW - sidebarWidth - 2, 1, termW - 1, termH, colors.red)
			write(">")
			for i, v in ipairs(sidebar) do
				term.setCursorPos(termW - sidebarWidth, i + 1)
				write(v[1])
			end
		else
			write("<")
		end
	end

	while true do
		redraw()
		local ev = {os.pullEventRaw()}
		if ev[1] == "terminate" then
			return
		elseif ev[1] == "mouse_click" then
			if ev[3] == termW then
				sidebarVisible = not sidebarVisible
			elseif ev[3] >= termW - sidebarWidth
			and    ev[3] <= termW - 1
			and    ev[4] >= 2
			and    sidebarVisible then
				if sidebar[ev[4] - 1] then
					sidebar[ev[4] - 1][2]()
				end
			end
		end
	end
end

desktop()

