print( "SertexOS 2 Booting..." )
local _baseDir = fs.getDir( shell.getRunningProgram() )
local _autorun = {
--# Put autorun programs names and dirs here as a string  e.g. "lol lol 3",#-- 
  
}
function log( text )
  local ftime = textutils.formatTime( os.time(), true )
  local str = "[" .. string.rep( " ", 5-ftime:len()) .. ftime .. "] [ BOOTLOADER ]" .. text
  --if not SertexOS.quiet then
  --  print( str )
 -- end
  local f = fs.open( fs.combine( _baseDir, "SertexOSBootloader.log" ), "a" )
  f.writeLine( str )
  f.close()
end
log( "Loading AutoRun programs..." )
if #_autorun < 0 then
  for i = 1, #_autorun do
    shell.run( i )
  end
end
log( "Finished, executing SertexOS..." )
shell.run( "SertexOS" )
