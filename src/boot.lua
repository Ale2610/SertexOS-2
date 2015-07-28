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

local function loadKernel(...)
	_G.SertexOS = {
		 version = "b7.1",
		 build = 1,
		 quiet = true,
		 configVersion = 2,
  		program = {
  			adminRights = nil
		 },
		  currentUser = {
		 	admin = false
		 },
	}

-- find base directory
local baseDir = fs.getDir(shell.getRunningProgram())
SertexOS.baseDir = baseDir

	function os.version()
  		return "SertexOS 2 "..SertexOS.version
	end
-- load extra APIs
	if fs.exists(fs.combine(SertexOS.baseDir, "apis")) and fs.isDir(fs.combine(SertexOS.baseDir, "apis")) then
	 for i, v in ipairs(fs.list(fs.combine(SertexOS.baseDir, "apis"))) do
	 os.loadAPI(fs.combine(fs.combine(SertexOS.baseDir, "apis"), v))
  	end
	end
-- load system files
	if not fs.exists("/.SertexOS/system") then
		fs.makeDir("/.SertexOS/system")	
	end

	for i, v in ipairs(fs.list("/.SertexOS/system")) do
		if not fs.isDir(v) then
			dofile("/.SertexOS/system/"..v)
		end
	end

-- load autorun files scripts
	for i, v in ipairs(fs.list("/.SertexOS/autorun")) do
		if not fs.isDir(v) then
			dofile("/.SertexOS/autorun/"..v)
		end
	end
	shell.run("/.SertexOS/SertexOS",...)
end

local function bios()
	os.pullEvent = os.pullEventRaw
	os.loadAPI("/.SertexOS/apis/ui")
	
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

local w, h = term.getSize()
local x, y = term.getCursorPos()
	
	opt = {
		"Boot SertexOS 2", --1 
		"Load CraftOS 1.7", --2
		"Update SertexOS 2", --3
		"Reset Config", --4
		"Show Free Space", --5
		"Wipe Computer", --6
		"Add Password for BIOS", --7
		"Remove Password for BIOS", --8
	}
	while true do

	n, c = ui.menu(opt, "BIOS")
	
		if c == 1 then
			local ok, err = pcall(loadKernel)
	
			if not ok then
				crash("crash", err)
			end
		elseif c == 2 then
			crash = nil
			SertexOS = nil
			os.unloadAPI("/.SertexOS/apis/ui")
			term.setBackgroundColor(colors.black)
			term.clear()
			term.setCursorPos(1,1)
			sleep(0.1)
			shell.run("/rom/programs/shell")
			break
		elseif c == 3 then
			term.setBackgroundColor(colors.black)
			term.clear()
			term.setCursorPos(1,1)
			term.setTextColor(colors.white)
			setfenv(loadstring(http.get("https://raw.github.com/Sertex-Team/SertexOS-2/master/upd.lua").readAll()),getfenv())()
		elseif c == 4 then
			term.clear()
			term.setCursorPos(1,1)
			local f = fs.open("/.SertexOS/config","w")
			f.write("configVersion = 1\nlanguage = \"en\"")
			f.close()
			print("Done")
			sleep(2)
		elseif c == 5 then
			term.setBackgroundColor(colors.white)
			term.clear()
			term.setTextColor(colors.red)
			bytes = fs.getFreeSpace("/")
	   		kbytes = bytes/1024
   			bytes = bytes%1024
   			mbytes = kbytes/1024
   			kbytes = kbytes%1024
   			gbytes = mbytes/1024
   			mbytes = mbytes%1024
   			tbytes = gbytes/1024
   			gbytes = gbytes%1024
   
   			tbytes = tbytes*100
   			gbytes = gbytes*100
			mbytes = mbytes*100
   			kbytes = kbytes*100
   			bytes = bytes*100
   
   			tbytes = math.floor(tbytes)
   			gbytes = math.floor(gbytes)
   			mbytes = math.floor(mbytes)
   			kbytes = math.floor(kbytes)
   			bytes = math.floor(bytes)
   
   			tbytes = tbytes/100
   			gbytes = gbytes/100
   			mbytes = mbytes/100
   			kbytes = kbytes/100
   			bytes = bytes/100
   
   			space = tbytes.."TB "..gbytes.."GB "..mbytes.."MB "..kbytes.."KB "..bytes.."B"
			centerDisplay("Free Space: "..space)
			local w, h = term.getSize()
			local x, y = term.getCursorPos()
			center(y + 2, "Press Any Key")
			os.pullEvent("key")
		elseif c == 6 then
			local c = ui.yesno("You Will Lose All Files", "Wipe Computer?", false)
			if not c then
				bios()
				break
			end
				term.setBackgroundColor(colors.black)
				term.clear()
				term.setCursorPos(1,1)
				term.setTextColor(colors.white)
				list = fs.list("")
				
				for i = 1, #list do
					if not fs.isReadOnly(list[i]) then
						fs.delete(list[i])
						printError(list[i].." deleted")
					else
						printError(list[i].." is read only! (Can't be deleted)")
					end
				end
				print("press any key")
				os.pullEvent("key")
				os.reboot()
		elseif c == 7 then
			os.loadAPI("/.SertexOS/apis/sha256")
			while true do
				term.clear()
				term.setCursorPos(1,1)
				print("SertexOS 2 BIOS")
				write("Insert Password: ")
				local p1 = read("*")
				write("Repeat Password: ")
				local p2 = read("*")
				
				if p1 == p2 then
					local f = fs.open("/.SertexOS/.bios", "w")
					f.write(sha256.sha256(p1))
					f.close()
					print("Done")
					sleep(2)
					break
				else
					print("Wrong Password")
					sleep(2)
				end
			end
			os.unloadAPI("/.SertexOS/apis/sha256")
		elseif c == 8 then
			os.loadAPI("/.SertexOS/apis/sha256")
			if fs.exists("/.SertexOS/.bios") then
				write("Insert Password: ")
				local p = read("*")
				local f = fs.open("/.SertexOS/.bios", "r")
				if sha256.sha256(p) == f.readLine() then
					fs.delete("/.SertexOS/.bios")
					print("Done")
					sleep(2)
				else
					print("Wrong Password")
					sleep(2)
				end
				f.close()
			else
				print("No Password Set")
				sleep(2)
			end
			os.unloadAPI("/.SertexOS/apis/sha256")
		end
	end
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
		elseif par1 == 36 then
			crash("seretx", "Good job man! You crashed SeretxOS")
		end
	end
	sleep(0)
end
