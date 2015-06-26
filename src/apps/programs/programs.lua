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

local function header()
	local w,h = term.getSize()
	graphics.line(1,1,w,1, colors.red)
	term.setTextColor(colors.white)
end

local function header_exit(charX)
	if not charX then
		charX = "X"
	end
	local w,h = term.getSize()
	graphics.line(1,1,w,1, colors.red)
	term.setTextColor(colors.white)
	local w, h = term.getSize()
	term.setCursorPos(w,1)
	term.setBackgroundColor(colors.red)
	write(charX)
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.red)
	term.setCursorPos(1,3)
end

local function draw()
	clear()
	local w,h = term.getSize()
	graphics.line(1,1,w,1, colors.red)
	term.setTextColor(colors.white)
	term.setCursorPos(1,1)
	term.setBackgroundColor(colors.lime)
	write("+")
	term.setCursorPos(2,1)
	term.setBackgroundColor(colors.orange)
	write("-")
	term.setCursorPos(w,1)
	term.setBackgroundColor(colors.red)
	write("X")
	term.setCursorPos(1,3)
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.red)
end

local function add()
	term.setBackgroundColor(colors.white)
	term.clear()
	header_exit("<")
	term.setCursorBlink(true)
	write("File Directory: \\")
	local w,h = term.getSize()
	local e =  { os.pullEvent() }
	if e[1] == "mouse_click" or e[1] == "monitor_touch" then
		local x = e[3]
		local y = e[4]
		if y == 1 and x == w then
			return
		end
	elseif e[1] == "key" then
		local dir = read()
		write("Link Name: ")
		local link = read()
		local f = fs.open("/.SertexOS/programs/"..link, "w")
		f.write("dofile(\"/"..dir.."\")")
		f.close()
		print("Done!")
		print("Press Any Key")
		os.pullEvent("key")
		return
	end
end

local function remove()
	term.setBackgroundColor(colors.white)
	term.clear()
	header_exit("<")
	local w,h = term.getSize()
	local pList = fs.list("/.SertexOS/programs")
	for i = 1, #pList do
		print(pList[i])
	end
	local e =  { os.pullEvent() }
	if e[1] == "mouse_click" or e[1] == "monitor_touch" then
		local x = e[3]
		local y = e[4]
		if y == 1 and x == w then
			return
		end
		if y > 2 then
			
		end
	end
end

draw()

while true do
	term.setCursorBlink(false)
	local w, h = term.getSize()
	draw()
	local pList = fs.list("/.SertexOS/programs")
	for i = 1, #pList do
		print(pList[i])
	end
	local e, par1, x, y = os.pullEvent()
	if e == "mouse_click" or e == "monitor_touch" then
		if y == 1 then
			if x == w then
				return
			elseif x == 1 then
				add()
			elseif x == 2 then
				remove()
			end
		else
			if y - 2 > #pList then
				shell.run("fg ","/.SertexOS/programs/"..pList[y-2])
			end
		end
	end
end
