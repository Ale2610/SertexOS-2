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
  build = 3,
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

api.log("System Online")

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

-- settings

function settings()
	
	local function changeLang()
		print("WIP")
		sleep(2)
		return
	end
	
	local function changePassword()
		print("WIP")
		sleep(2)
		return
	end
	
	local function update()
		api.log("System Update")
		shell.run("pastebin run x01uD8Uc")
	end
	
	local function exitSettings()
		desktop()
	end
	options = {
		"Change Language", --1
		"Change Password", --2
		"Update", --3
		"Exit", --4
	}
	
	item, id = ui.menu(options, "Settings")
	
	if id == 1 then
		changeLang()
	elseif id == 2 then
		changePassword()
	elseif id == 3 then	
		update()
	elseif id == 4 then
		exitSettings()
	else
		settings()
	end
end

-- desktop

function desktop()

	if u == nil then
		api.crash("bypass", "Username = nil")
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
		sertextext.left(1, "Computer ID: "..os.getComputerID())
		sertextext.right(1, "User: "..u)		
		term.setBackgroundColor(colors.white)
		term.setTextColor(colors.red)
	end

	while true do
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
				api.log("Shutdown")
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
				api.log("Reboot")
				os.reboot()
			end},
			{"Logout", function()
				local function printMsg(color)
					term.setBackgroundColor(color)
					term.setTextColor(colors.white)
					term.clear()
					term.setCursorPos(1, 1)
					sertextext.centerDisplay("Logging Out...")
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
			{"Shell", function()
				api.log("Opened Shell")
				term.setBackgroundColor(colors.black)
				term.clear()
				term.setCursorPos(1,1)
				shell.setDir("/")
				shell.openTab("/.SertexOS/apps/shell")
				shell.switchTab(2)
				sleep(0.1)
			end},
			{"Settings", function()
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

function header()
	clear()
	graphics.box(1,1,51,3, colors.red)
	term.setTextColor(colors.white)
	sertextext.center(2, "SertexOS 2")
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.red)
	term.setCursorPos(1,5)
end

-- login

function login()
	clear()
	if not fs.exists("/.SertexOS/.userCreateOk") then
	while true do
		header()
		print( "  SertexOS 2 Account Setup" )
		print( "\n  Please Enter Your Username." )
		write( "  > " )
		u = read()
		print( "  Please Enter A Password." )
		write( "  > " )
		p = read( "*" )
		print( "  Please Repeat The Password." )
		write( "  > " )
		rp = read("*")
		if p ~= rp then
			print("  Wrong Password.")
			api.log("Wrong Password on setup")
			sleep(2)
			login()
		end
		encrtyptedPassword = sha256.sha256(p)
		choose = ui.yesno("It's this correct?", "You entered " .. u .. " as your username.")
		if choose then
			print( "   Writing Data..." )
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
		choose = ui.yesno("Do you want to create another user?")
		
		if choose then
			sleep(0.1)
			api.log("Making new user")
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
		print( "  Please Log In" )
		write( "\n  Username > " )
		u = read()
		write( "  Password > " )
		p = read( "*" )
		encryptedPassword = sha256.sha256(p)
		if not fs.exists(dbUsersDir..u) or u == "" then
			print("  Username not registered!")
			sleep(2)
			login()
		end
		f = fs.open( dbUsersDir..u, "r" )
		p2 = f.readLine()
		f.close()
		if encryptedPassword == p2 then
			print( "\n  Welcome " .. u .. "!" )
			api.log("Logged In As "..u)
			sleep( 2 )
			desktop()
		else
			printError( "  Incorrect Password!" )
			api.log("Incorrect Password from "..u.." Password: "..p)
			sleep( 2 )
			login()
		end
			
end

login()
