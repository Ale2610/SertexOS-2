local function crash(reason,message) --the crash error is only for OS crashes

	local function center(y, text )
		w, h = term.getSize()
		term.setCursorPos((w - #text) / 2, y)
		write(text)
	end
	os.pullEvent = os.pullEventRaw
	reasons = {
		["bypass"] = "System Bypassed",
		["security"] = "System Security Issue",
		["crash"] = "System Crashed",
		["unknown"] = "Unknown Error",
		["bios"] = "BIOS Error",
		["seretx"] = "SeretxOS 2 crashed again :C", -- Devs need fun
	}
		term.setBackgroundColor(colors.blue)
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.white)
		center(1,"SertexOS 2 Crashed:")
		if not reasons or not reasons[reason] then
			center(2,reasons["crash"])
		else
			center(2,reasons[reason])
		end
		
		if not message then
			center(4,"Undefined Crash")
		else
			print("\n\n"..message)
		end
		local x, y = term.getCursorPos()
		center(y+2,"Please reboot system!")
		center(y+3,"Please report the issue here:")
		center(y+4,"https://github.com/Sertex-Team/SertexOS-2/issues")
		while true do
			sleep(0)
		end
end

function loadKernel(...)
	dofile("/.SertexOS/SertexOS")
end


function centerDisplay( text )
		w, h = term.getSize()
		term.setCursorPos(( w - string.len(text)) / 2, h / 2)
		write( text )
end
function center(y, text )
	w, h = term.getSize()
	term.setCursorPos((w - #text) / 2, y)
	write(text)
end

term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.white)

sleep(0.1)
local args = {...}

local argData = {
  ["-f"] = false,
  ["-o"] = false,
  ["-u"] = false,
}

if #args > 0 then
  while #args > 0 do
    local arg = table.remove(args, 1)
    if argData[arg] ~= nil then
      argData[arg] = true
    end
  end
end

if not term.isColor() then
  print("SertexOS 2 is only for advanced computers")
  return
end

if _G.SertexOS and not argData["-f"] then
  printError("Found SertexOS data in memory!")
  print("If you want to reload SertexOS, launch with arguments '-f'")
  return
end

if argData["-u"] then
	sleep(0.1)
	print("Getting SertexOS 2 installer...")
	setfenv(loadstring(http.get("https://raw.github.com/Sertex-Team/SertexOS-2/master/upd.lua").readAll()),getfenv())()
end

if OneOS and not argData["-o"] then
  printError("Sorry, SertexOS and OneOS can't run in parallel.")
  print("Please reboot the computer without OneOS and start SertexOS.")
  print("If you *really* want to use OneOS *and* SertexOS, use the command line argument '-o' when starting SertexOS.")
  return
end

os.pullEvent = os.pullEventRaw

term.setBackgroundColor(colors.white)
term.clear()
term.setTextColor(colors.red)
term.setCursorPos(1,1)
print("BIOS Version: 1.7")
centerDisplay("")
local w, h = term.getSize()
local x, y = term.getCursorPos()
center(y - 1, "SertexOS")
center(y + 1, "Loading...")
center(y + 3, "Press ALT to load BIOS")
local waitingALT = os.startTimer(2)
	
while true do
	local event, par1 = os.pullEvent()

	if event == "timer" and par1 == waitingALT then
		term.setBackgroundColor(colors.black)
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.white)
		local ok, err = pcall(loadKernel)
	
		if not ok then
			crash("crash", err)
		end
		break
	elseif event == "key" then
		if par1 == 56 then
			term.setBackgroundColor(colors.black)
			term.clear()
			term.setCursorPos(1,1)
			term.setTextColor(colors.white)
			if fs.exists("/.SertexOS/.bios") then
				while true do
					term.setBackgroundColor(colors.white)
					term.clear()
					term.setTextColor(colors.red)
					term.setCursorPos(1,1)
					os.loadAPI("/.SertexOS/apis/sha256")
					f = fs.open("/.SertexOS/.bios", "r")
					print("SertexOS 2 BIOS")
					write("Password: ")
					local p = read("*")
					if sha256.sha256(p) == f.readLine() then
						local ok, err = pcall(bios)
	
						if not ok then
							crash("bios", err)
						end
						break
					else
						print("Wrong Password!")
						sleep(2)
					end
				end
			else
				local ok, err = pcall(bios)
				if not ok then
					crash("bios", err)
				end
				break
			end
		end
	end
	sleep(0)
end
