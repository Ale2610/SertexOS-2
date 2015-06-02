term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.blue)
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
  else
  printError( "Invalid Command" )
  end
end
