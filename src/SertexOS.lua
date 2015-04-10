function crash(reason,message)

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
			center(4, "Undefined Crash")
		else
			center(4,message)
		end
		center(7,"Please reboot system!")
		center(8,"Please report the issue here:")
		center(9,"https://github.com/Sertex-Team/SertexOS-2/issues")
		while true do
			sleep(0)
		end
end

function kernel(...)
sleep(0.1)
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
  build = 5,
  quiet = true,
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
	_G.SertexOS = nil
	SertexOS = nil
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
api.lock()
api.log("System Online")

dofile("/.SertexOS/config")

if language == "en" then
	dofile("/.SertexOS/lang/en.lang")
elseif language == "it" then
	dofile("/.SertexOS/lang/it.lang")
elseif language == "de" then
	dofile("/.SertexOS/lang/de.lang")
else
	crash("crash", "Language Not Found")
end

local systemDir = ".SertexOS"
local dbUsersDir = systemDir.."/databaseUsers/"
local folderUsersDir = "/user"

-- clear

function clear()
	term.setBackgroundColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
	term.setTextColor(colors.red)
end

-- header
function header()
	clear()
	graphics.box(1,1,51,3, colors.red)
	term.setTextColor(colors.white)
	sertextext.center(2, "SertexOS 2")
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.red)
	term.setCursorPos(1,5)
end


-- settings

function settings()
	
	local function changeLang()
		langs = {
			"English", --1
			"Italiano", --2
			"Deutsch", --3
		}
		item, id = ui.menu(langs, language_title)
		
		if id == 1 then
			local f = fs.open("/.SertexOS/config","w")
			f.write("configVersion = "..configVersion.."\nlanguage = \"en\"")
			f.close()
		elseif id == 2 then
			local f = fs.open("/.SertexOS/config","w")
			f.write("configVersion = "..configVersion.."\nlanguage = \"it\"")
			f.close()
		elseif id == 3 then
			local f = fs.open("/.SertexOS/config","w")
			f.write("configVersion = "..configVersion.."\nlanguage = \"de\"")
			f.close()
		else
			crash("crash", "language id not found")
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
				api.log("Reboot")
				os.reboot()
			else
				return
			end
	end
	
	local function changePassword()
		clear()
		header()
		sertextext.center(5, changePassword_title.." "..u.."\n\n")
		print("  "..changePassword_enterCurrentPassword)
		write("  > ")
		currentPW = read("*")
		f = fs.open(dbUsersDir..u, "r")
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
				local f = fs.open(dbUsersDir..u, "w")
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
		api.log("System Update")
		shell.run("pastebin run x01uD8Uc")
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

function desktop()

	if u == nil then
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
		sertextext.right(1, desktop_user..u)		
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
				api.log("Shutdown")
				os.shutdown()
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
				api.log("Reboot")
				os.reboot()
			end},
			{mainMenu_logout, function()
				local function printMsg(color)
					term.setBackgroundColor(color)
					term.setTextColor(colors.white)
					term.clear()
					term.setCursorPos(1, 1)
					sertextext.centerDisplay(account_loggingOut)
					api.log("Logged Out "..u)
					sleep(0.1)
				end
				printMsg(colors.white)
				printMsg(colors.lightGray)
				printMsg(colors.gray)
				printMsg(colors.black)
				sleep(0.6)
				login()
			end},
			{mainMenu_shell, function()
				api.log("Opened Shell")
				term.setBackgroundColor(colors.black)
				term.clear()
				term.setCursorPos(1,1)
				shell.setDir("/")
				shell.openTab("/.SertexOS/apps/shell")
				shell.switchTab(2)
				sleep(0.1)
			end},
			{mainMenu_settings, function()
				settings()
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
			desktopHeader()
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
end
-- login

function login()
	clear()
	if not fs.exists("/.SertexOS/.userCreateOk") then
	while true do
		header()
		print( "  "..setup_title )
		print( "\n  "..setup_enterUsername )
		write( "  > " )
		u = read()
		print( "  "..setup_enterPassword )
		write( "  > " )
		p = read( "*" )
		print( "  "..setup_repeatEnterPassword )
		write( "  > " )
		rp = read("*")
		if p ~= rp then
			print("  "..wrongPassword)
			api.log("Wrong Password on setup")
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
			api.log("Created Account "..u)
			sleep(0.1)
		else
			api.log("User deleted")
			sleep(0.1)
			login()
		end
		choose = ui.yesno(setup_createAnotherUser)
		
		if choose then
			sleep(0.1)
			api.log("Creating new user")
			login()
		else
			api.log("Stop making new users")
			userOk = fs.open(systemDir.."/.userCreateOk", "w")
			userOk.write("ignore me please")
			userOk.close()
			sleep(0.1)
			break
		end
	end	
	end
		clear()
		header()
		print( "  "..login_title )
		write( "\n  "..login_username.." > " )
		u = read()
		write( "  "..login_password.." > " )
		p = read( "*" )
		encryptedPassword = sha256.sha256(p)
		if not fs.exists(dbUsersDir..u) or u == "" then
			print("  "..login_notRegistered)
			sleep(2)
			login()
		end
		f = fs.open( dbUsersDir..u, "r" )
		p2 = f.readLine()
		f.close()
		if encryptedPassword == p2 then
			print( "\n  "..login_welcome:format(u) )
			api.log("Logged In As "..u)
			sleep( 2 )
			desktop()
		else
			printError( "  "..wrongPassword )
			api.log("Incorrect Password from "..u.." Password: "..p)
			sleep( 2 )
			login()
		end
			
end

login()
end --end kernel

local ok, err = pcall(kernel)
	
if not ok then
	crash("crash", err)
end
