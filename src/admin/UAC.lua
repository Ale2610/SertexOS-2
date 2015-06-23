term.clear()
term.setCursorPos( 1, 1 )
print( "A program is requesting admin." )
if SertexOS.currentUser.admin then
  print( "Type 'y' or 'n'" )
  write( "Admin> " )
  i = read()
  if i == "y" then
    print( "Allowed access." )
    SertexOS.program.adminRights = true
  elseif i == "n" then
    print( "Declined access." )
    SertexOS.program.adminRights = false
  end
else
  print( "Please type the password of the admin of the system." )
  write( "Admin> " )
  i = read( "*" )
  sh = sha256.sha256( i )
  f = fs.open( dbUsersDir .. "admin", "r" )
    if sh == f.readLine() then
    print( "Allowed access." )
    SertexOS.program.adminRights = true
  else
    print( "Invalid password" )
    SertexOS.program.adminRights = false
  end
end
