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
_____           _             ____   _____ 
/ ____|         | |           / __ \ / ____|
| (___   ___ _ __| |_ _____  _| |  | | (___  
\___ \ / _ \ '__| __/ _ \ \/ / |  | |\___ \ 
 ____) |  __/ |  | ||  __/>  <| |__| |____) |
|_____/ \___|_|   \__\___/_/\_\\____/|_____/ 
                                              
You are in Dev Shell
      
Please use the exit command to return to the operating system.
      
If you are reading this then you are NOT a developer.
    ]])
  end
end
