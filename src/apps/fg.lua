
local tArgs = { ... }
if #tArgs > 0 then
    local nTask = shell.openTab( unpack( tArgs ) )
    if nTask then
        shell.switchTab( nTask )
    end
else
    local nTask = shell.openTab( ".SertexOS/apps/shell" )
    if nTask then
        shell.switchTab( nTask )
    end
end
