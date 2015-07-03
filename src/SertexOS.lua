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



local function kernel()

_G.SertexOS = {
  build = 5,
  quiet = true,
  program = {
  	adminRights = nil
  },
  currentUser = {
  	admin = false
  },
}

function os.version()
  return "SertexOS 2 b"..SertexOS.build
end

-- find base directory
local baseDir = fs.getDir(shell.getRunningProgram())
SertexOS.baseDir = baseDir

function log(text)
  local ftime = textutils.formatTime(os.time(), true)
  local str = "["..string.rep(" ", 5-ftime:len())..ftime.."] "..text
  if not SertexOS.quiet then
    print(str)
  end
  local f = fs.open(fs.combine(baseDir, "SertexOS.log"), "a")
  f.writeLine(str)
  f.close()
end

function lock()
  os.pullEvent = os.pullEventRaw
end

function unlock()
  os.pullEvent = ope
end

function setLogging(val)
  if type(val) == "boolean" then
    SertexOS.quiet = not val
  end
end

-- load extra APIs
if fs.exists(fs.combine(SertexOS.baseDir, "apis")) and fs.isDir(fs.combine(SertexOS.baseDir, "apis")) then
  for i, v in ipairs(fs.list(fs.combine(SertexOS.baseDir, "apis"))) do
    os.loadAPI(fs.combine(fs.combine(SertexOS.baseDir, "apis"), v))
  end
end
log("System Online")

dofile("/.SertexOS/config")

if language == "en" then
	dofile("/.SertexOS/lang/en.lang")
elseif language == "it" then
	dofile("/.SertexOS/lang/it.lang")
elseif language == "de" then
	dofile("/.SertexOS/lang/de.lang")
else
	dofile("/.SertexOS/lang/en.lang")
end

if not fs.exists("/.SertexOS/system") then
	fs.makeDir("/.SertexOS/system")
end

-- load system files

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

local systemDir = ".SertexOS"
local dbUsersDir = systemDir.."/databaseUsers/"
local folderUsersDir = "/user"

--getLoadedAPIs
local loadedAPIs = {}

local oldLoadAPI = os.loadAPI
local oldUnloadAPI = os.unloadAPI
function os.loadAPI(api)
	oldLoadAPI(api)
	table.insert(loadedAPIs, api)
	function os.getAPIs()
		return loadedAPIs
	end
end

function os.unloadAPI(api)
	oldUnloadAPI(api)
	table.remove(loadedAPIs, api)
end

--getTextColor

local oldTextColor = term.setTextColor
function term.setTextColor(color)
	oldTextColor(color)
	function term.getTextColor()
		return color
	end
end

--getBackgroundColor
local oldBGColor = term.setBackgroundColor
function term.setBackgroundColor(color)
	oldBGColor(color)
	function term.getBackgroundColor()
		return color
	end
end

os.forceShutdown = os.shutdown
os.forceReboot = os.reboot

function os.reboot()
	local function printMsg(color)
		term.setBackgroundColor(color)
		term.setTextColor(colors.white)
		term.clear()
		term.setCursorPos(1, 1)
		sertextext.centerDisplay(system_rebooting)
		sleep(0.1)
	end
	printMsg(colors.white)
	printMsg(colors.lightGray)
	printMsg(colors.gray)
	printMsg(colors.black)
	sleep(0.6)
	log("Reboot")
	os.forceReboot()
end

function os.shutdown()
	local function printMsg(color)
		term.setBackgroundColor(color)
		term.setTextColor(colors.white)
		term.clear()
		term.setCursorPos(1, 1)
		sertextext.centerDisplay(system_shuttingDown)
		sleep(0.1)
	end
	printMsg(colors.white)
	printMsg(colors.lightGray)
	printMsg(colors.gray)
	printMsg(colors.black)
	sleep(0.6)
	log("Shutdown")
	os.forceShutdown()
end

-- clear

local function clear()
	term.setBackgroundColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
	term.setTextColor(colors.red)
end

-- header
local function header()
	clear()
	graphics.box(1,1,51,3, colors.red)
	term.setTextColor(colors.white)
	sertextext.center(2, "SertexOS 2")
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.red)
	term.setCursorPos(1,5)
end

-- about

local function about()
	header()
	sertextext.center(5, about_title)
	sertextext.left(7, "(c) Copyright 2015 SertexOS 2 - All Rights Reserved")
	sertextext.left(8, "Do not distribute!")
	sertextext.left(9, "Firewolf by GravityScore")
	local bytes = fs.getFreeSpace("/")
	kbytes = bytes/1024
	bytes = bytes%1024
	mbytes = kbytes/1024
	kbytes = kbytes%1024
	gbytes = mbytes/1024
	mbytes = mbytes%1024
	tbytes = gbytes/1024
	gbytes = gbytes%1024
	 tbytes = tbytes*100
	bytes = gbytes*100
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
	
	sertextext.center(11,about_freeSpace.." "..mbytes.."MB")
	sertextext.center(13, lang_pressAnyKey)
	os.pullEvent("key")
	return
end

-- settings

local function settings()
	
	local function changeLang()
		langs = {
			"English", --1
			"Italiano", --2
			"Deutsch", --3
		}
		lock()
		while true do
			item, id = ui.menu(langs, language_title)
		
			if id == 1 then
				local f = fs.open("/.SertexOS/config","w")
				f.write("configVersion = "..configVersion.."\nlanguage = \"en\"")
				f.close()
				break
			elseif id == 2 then
				local f = fs.open("/.SertexOS/config","w")
				f.write("configVersion = "..configVersion.."\nlanguage = \"it\"")
				f.close()
				break
			elseif id == 3 then
				local f = fs.open("/.SertexOS/config","w")
				f.write("configVersion = "..configVersion.."\nlanguage = \"de\"")
				f.close()
				break
			end
		end
		requestReboot = ui.yesno(language_reboot2, language_reboot1)
		if requestReboot then
			local function printMsg(color)
					term.setBackgroundColor(color)
					term.setTextColor(colors.white)
					term.clear()
					term.setCursorPos(1, 1)
					sertextext.centerDisplay(system_rebooting)
					sleep(0.1)
				end
				printMsg(colors.white)
				printMsg(colors.lightGray)
				printMsg(colors.gray)
				printMsg(colors.black)
				sleep(0.6)
				log("Reboot")
				os.forceReboot()
			else
				return
			end
	end
	
	local function changePassword()
		clear()
		header()
		sertextext.center(5, changePassword_title.." "..SertexOS.u.."\n\n")
		print("  "..changePassword_enterCurrentPassword)
		write("  > ")
		currentPW = read("*")
		f = fs.open(dbUsersDir..SertexOS.u, "r")
		pw = f.readLine()
		f.close()
		if sha256.sha256(currentPW) ~= pw then
			print("\n  "..wrongPassword)
			sleep(2)
			changePassword()
		else
			print("  "..changePassword_enterNewPassword)
			write("  > ")
			local newPW = read("*")
			print("  "..changePassword_repeatNewPassword)
			write("  > ")
			local repeatNewPW = read("*")
			if newPW == repeatNewPW then
				local f = fs.open(dbUsersDir..SertexOS.u, "w")
				f.write(sha256.sha256(newPW))
				f.close()
				print("\n  "..lang_done)
				sleep(2)
			else
				print("\n  "..wrongPassword)
				sleep(2)
				changePassword()
			end
		end
		return
	end
	
	local function update()
		log("System Update")
		setfenv(loadstring(http.get("https://raw.github.com/Sertex-Team/SertexOS-2/master/upd.lua").readAll()),getfenv())()
	end
	
	local function exitSettings()
		return
	end
	options = {
		settings_changeLang, --1
		settings_changePassword, --2
		settings_update, --3
		lang_exit, --4
	}
	
	item, id = ui.menu(options, settings_title)
	
	if id == 1 then
		changeLang()
	elseif id == 2 then
		changePassword()
	elseif id == 3 then	
		update()
	elseif id == 4 then
		exitSettings()
	end
end

-- desktop

local function desktop()

	if SertexOS.u == nil then
		crash("bypass", "Username = nil")
	end

	function desktopHeader()
		local termW, termH = term.getSize()		

		term.setBackgroundColor(colors.white)
		term.clear()
		graphics.box(1,1,termW,1, colors.red)
		term.setBackgroundColor(colors.red)
		term.setCursorPos(1,1)
		term.setTextColor(colors.white)
		sertextext.center(1, "SertexOS 2")
		sertextext.left(1, desktop_computerID..os.getComputerID())
		sertextext.right(1, desktop_user..SertexOS.u)		
		term.setBackgroundColor(colors.white)
		term.setTextColor(colors.red)
	end

	while true do
		local termW, termH = term.getSize()

		local sidebar = {
			{mainMenu_shutdown, function()
				local function printMsg(color)
					term.setBackgroundColor(color)
					term.setTextColor(colors.white)
					term.clear()
					term.setCursorPos(1, 1)
					sertextext.centerDisplay(system_shuttingDown)
					sleep(0.1)
				end
				printMsg(colors.white)
				printMsg(colors.lightGray)
				printMsg(colors.gray)
				printMsg(colors.black)
				sleep(0.6)
				log("Shutdown")
				os.forceShutdown()
			end},
			{mainMenu_reboot, function()
				local function printMsg(color)
					term.setBackgroundColor(color)
					term.setTextColor(colors.white)
					term.clear()
					term.setCursorPos(1, 1)
					sertextext.centerDisplay(system_rebooting)
					sleep(0.1)
				end
				printMsg(colors.white)
				printMsg(colors.lightGray)
				printMsg(colors.gray)
				printMsg(colors.black)
				sleep(0.6)
				log("Reboot")
				os.forceReboot()
			end},
			{mainMenu_logout, function()
				local function printMsg(color)
					term.setBackgroundColor(color)
					term.setTextColor(colors.white)
					term.clear()
					term.setCursorPos(1, 1)
					sertextext.centerDisplay(account_loggingOut)
					log("Logged Out "..SertexOS.u)
					sleep(0.1)
				end
				printMsg(colors.white)
				printMsg(colors.lightGray)
				printMsg(colors.gray)
				printMsg(colors.black)
				sleep(0.6)
				login()
			end},
			{mainMenu_settings, function()
				settings()
			end},
			{mainMenu_about, function()
				about()
			end},
		}
		
		local function app(name, x, y) -- the max character are 7
			local applications = {
				[mainMenu_shell] = "shell",
				["Frwlf"] = "firewolf",
				["Files"] = "filemanager",
				["Progrms"] = "programs",
			}
			
			appDir = "/.SertexOS/apps/"..applications[name]
			appLogo = paintutils.loadImage(appDir.."/logo")
			
			if not appLogo then
				appLogo = paintutils.loadImage("/.SertexOS/apps/defaultLogo")
			end
			
			paintutils.drawImage(appLogo, x, y)
			
			maxX = x + 4
			maxY = y + 5
			
			if tonumber(#name) > 5 then
				term.setCursorPos(x - 1, maxY - 1)
			else
				term.setCursorPos(x, maxY - 1)
			end
			term.setBackgroundColor(colors.white)
			term.setTextColor(colors.red)
			write(name)
		end
		

		local sidebarVisible = false
		local sidebarWidth = 0
		for i, v in ipairs(sidebar) do
			if v[1]:len() > sidebarWidth then
				sidebarWidth = v[1]:len()
			end
		end

		local function redraw()
			desktopHeader()
			app(mainMenu_shell, 2,3)
			app("Frwlf", 10,3)
			app("Files", 18,3)
			app("Progrms", 26, 3)
			graphics.line(termW, 1, termW, termH, colors.red)
			term.setCursorPos(termW, math.ceil(termH / 2))
			term.setTextColor(colors.white)
			if sidebarVisible then
				graphics.box(termW - sidebarWidth - 4, 1, termW - sidebarWidth - 3, termH, colors.orange)
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
		
			lock()
		
		while true do
			sleep(0)
			redraw()
			local ev = {os.pullEventRaw()}
			if ev[1] == "mouse_click" then
				local mx = ev[3]
				local my = ev[4]
				if ev[3] == termW then
					sidebarVisible = not sidebarVisible
				elseif ev[3] >= termW - sidebarWidth and    ev[3] <= termW - 1 and    ev[4] >= 2 and    sidebarVisible then
					if sidebar[ev[4] - 1] then
						sidebar[ev[4] - 1][2]()
					end
				elseif (mx > 2 - 1 and my > 3 - 1) and (mx < 6 + 1 and my < 8 + 1) then
					shell.openTab("/.SertexOS/apps/shell/app")
				elseif (mx > 8 - 1 and my > 3 - 1) and (mx < 14 + 1 and my < 8 + 1) then
					shell.openTab("/.SertexOS/apps/firewolf/app")
				elseif (mx > 14 - 1 and my > 3 - 1) and (mx < 22 + 1 and my < 8 + 1) then
					shell.openTab("/.SertexOS/apps/filemanager/app")
				elseif (mx > 20 - 1 and my > 3 - 1) and (mx < 30 + 1 and my < 8 + 1) then
					shell.openTab("/.SertexOS/apps/programs/app")
				end
			end
			sleep(0)
		end
	end
end
-- login

function login()
	lock()
	clear()
	if not fs.exists("/.SertexOS/.userCreateOk") then
		while true do
			header()
			print( "  "..setup_title )
			print( "\n  "..setup_enterUsername )
			write( "  > " )
			u = read()
			if u == "" then
				print("  "..noUser)	
				log("No User on setup")
				sleep(2)
				login()
			elseif fs.isDir(dbUsersDir..u) or fs.exists(dbUsersDir..u) then
				print("  "..setup_existsUser)
				log("Invalid or existing user on setup")
				sleep(2)
				login()
			end
			print( "  "..setup_enterPassword )
			write( "  > " )
			p = read( "*" )
			print( "  "..setup_repeatEnterPassword )
			write( "  > " )
			rp = read("*")
			if p ~= rp then
				print("  "..wrongPassword)
				log("Wrong Password on setup")
				sleep(2)
				login()
			end
			encrtyptedPassword = sha256.sha256(p)
			choose = ui.yesno(setup_isUsernameCorrect2, setup_isUsernameCorrect1:format(u))
			if choose then
				print( "   "..writingData )
				f = fs.open( dbUsersDir..u, "w" )
				f.write( sha256.sha256(p) )
				f.close()
				fs.makeDir(folderUsersDir.."/"..u.."/desktop")
				log("Created Account "..u)
				sleep(0.1)
			else
				log("User deleted")
				sleep(0.1)
				login()
			end
			choose = ui.yesno(setup_createAnotherUser)
		
			if choose then
				sleep(0.1)
				log("Creating new user")
				login()
			else
				log("Stop making new users")
				userOk = fs.open(systemDir.."/.userCreateOk", "w")
				userOk.write("ignore me please")
				userOk.close()
				sleep(0.1)
				break
			end
			-- Admin
			if not fs.exists( "/.SertexOS/.userAdminCreateOk" ) then
				f = fs.open( "/.SertexOS/.userAdminCreateOk", "w" )
				f.write( "ignore me please" )
				f.close()
				header()
				print( "  " ..  setup_adminTitle )
				print( "\n  " .. setup_adminPass )
				write( "  > " )
				ap = read( "*" )
				print( "   " .. writingData )
				f = fs.open( dbUsersDir .. "admin", "w" )
				f.write( sha256.sha256( ap ) )
				f.close()
				fs.makeDir( folderUsersDir .. "/" .. "admin" .. "/desktop" )
				log( "Created Admin Account" )
			end
		end	
	end
		clear()
		local list = fs.list(dbUsersDir)
		local users = {}
		
		for i = 1, #list do
			if not fs.isDir(dbUsersDir..list[i]) then
				table.insert(users, list[i])
			end
		end
		
		SertexOS.u = ui.menu(users, login_title)
		if not SertexOS.u then
			login()
		end
		clear()
		header()
		
		print("  "..login_title)
		print("\n  "..SertexOS.u)
		write( "\n  "..login_password.." > " )
		p = read( "*" )
		encryptedPassword = sha256.sha256(p)
		if not fs.exists(dbUsersDir..SertexOS.u) or SertexOS.u == "" or fs.isDir(dbUsersDir..SertexOS.u) then
			print("  "..login_notRegistered)
			sleep(2)
			login()
		end
		f = fs.open( dbUsersDir..SertexOS.u, "r" )
		p2 = f.readLine()
		f.close()
		if encryptedPassword == p2 then
			print( "\n  "..login_welcome:format(SertexOS.u) )
			log("Logged In As "..SertexOS.u)
			sleep( 2 )
			desktop()
		else
			printError( "  "..wrongPassword )
			log("Incorrect Password from "..SertexOS.u.." Password: "..p)
			sleep( 2 )
			login()
		end
			
end

login()
end --end kernel

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
			local ok, err = pcall(kernel)
	
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
print("BIOS Version: 1.6")
centerDisplay("")
local w, h = term.getSize()
local x, y = term.getCursorPos()
center(y - 1, "SertexOS 2")
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
		local ok, err = pcall(kernel)
	
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
