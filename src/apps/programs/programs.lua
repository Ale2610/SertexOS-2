-- Programs
local w, h = term.getSize()

if not SertexOS then
	print("This program can not work without SertexOS 2")
	return
end

if multishell then
	multishell.setTitle( multishell.getCurrent(), "Programs" )
end
local function clear()
	term.setBackgroundColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
	term.setTextColor(colors.red)
end

local function draw()
	clear()
	local w,h = term.getSize()
	graphics.line(1,1,w,1, colors.red)
	term.setTextColor(colors.white)
	--[[
	Unused
	term.setCursorPos(1,1)
	term.setBackgroundColor(colors.lime)
	write("+")
	term.setCursorPos(2,1)
	term.setBackgroundColor(colors.orange)
	write("-")
	]]--
	term.setCursorPos(w,1)
	term.setBackgroundColor(colors.red)
	write("X")
	term.setCursorPos(1,3)
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.red)
end

draw()

while true do
	draw()
	local pList = fs.list("/.SertexOS/programs")
	for i = 1, #pList do
		print(pList[i])
	end
	local e, par1, x, y = os.pullEvent()
	if e == "mouse_click" or e == "monitor_touch" then
		if y == 1 and x == w then
			return
		elseif y > 2 then
			if y < math.ceil(#pList + 1) then
				shell.run("/.SertexOS/programs/"..pList[y+2])
			end
		end
	end
end