
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.blue)
local function crash(reason,message) --copied for devshell

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
	--	while true do
		--	sleep(0)
		--end
		print( "forcecrash end" )
end
print( "SertexOS Developer Shell" )
print( "" )
print( "You opened this window by typing \"devshell\" in the main Operating System. If you don't know what this is, please type \"exit\". Type \"help\" for more commands. " )
print( "" )
while true do
  term.setTextColor( colors.blue )
  write( "SertexOS@Root$ " )
  input = read()
  if input == "motd" then
    print( "SertexOS Developer Shell" )
    print( "" )
    print( "You opened this window by typing \"devshell\" in the main Operating System. If you don't know what this is, please type \"exit\". Type \"help\" for more commands. " )
    print( "" )
  elseif input == "exit" then
    return true
  elseif input == "help" then
    print([[
 ___  ____  ____  ____  ____  _  _  _____  ___ 
/ __)( ___)(  _ \(_  _)( ___)( \/ )(  _  )/ __)
\__ \ )__)  )   /  )(   )__)  )  (  )(_)( \__ \
(___/(____)(_)\_) (__) (____)(_/\_)(_____)(___/
 ____  ____  _  _    ___  _   _  ____  __    __   
(  _ \( ___)( \/ )  / __)( )_( )( ___)(  )  (  )  
 )(_) ))__)  \  /   \__ \ ) _ (  )__)  )(__  )(__ 
(____/(____)  \/    (___/(_) (_)(____)(____)(____)
                       
You are in Dev Shell
      
Please use the exit command to return to the operating system.
      
If you are reading this then you are NOT a developer.
    ]])
  elseif input == "" then
  elseif input == "forcecrash" then
    write( "crashtype> " )
    r = read()
    crash( r, "Forced Crash" )
  else
    printError( "Invalid Command" )
  end
end
