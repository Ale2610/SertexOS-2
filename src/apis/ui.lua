xLen,yLen = term.getSize()

function isSpace()
	local xNow, yNow = term.getCursorPos()
	return yNow < yLen
end

function version() 
	return 1,"LMNetUI"
end

function has(pWhat)
	-- I want a boolean, not a function...
	return ui[pWhat] ~= nil 
end

function clearArea(pYStart, pYEnd)
	for i=pYStart,pYEnd do
		term.setCursorPos(1,i)
		term.clearLine()
	end
end

function colorPicker(title, moreText, customColors)
	local screenTitle = title or "Color Picker"
	local colorList = {}
	local selected = 1
	if customColors then
		for i = 1, #customColors do
			table.insert(colorList, customColors[i])
		end
	else
		for i = 0, 15 do
			local num = 2^i
			if term.isColor() or num == 1 or num == 32768 then
				table.insert(colorList, num)
			end
		end
	end
	local function redraw()
		term.setTextColor(1)
		term.setBackgroundColor(32768)
		term.clear()
		term.setCursorPos(1, 1)
		local w, h = term.getSize()
		local cx, cy = math.ceil(w/2), math.ceil(h/2)
		term.setCursorPos(cx-math.floor(screenTitle:len()/2), 1)
		print(screenTitle)
		if moreText then
			for i, v in pairs(moreText) do
				print(v)
			end
		end
		for i = 1, #colorList do
			term.setTextColor(colorList[i])
			if selected == i then
				write("#")
			else
				write("_")
			end
		end
		term.setCursorPos(1, h-1)
		term.setTextColor(colors.white)
		term.setBackgroundColor(colors.black)
		write("Use arrow keys to move,")
		term.setCursorPos(1, h)
		write("press enter to pick color.")
	end
	local oldPullEvent = os.pullEvent
	os.pullEvent = os.pullEventRaw
	while true do
		redraw()
		local event = {os.pullEvent()}
		if event[1] == "terminate" then
			os.pullEvent = oldPullEvent
			return
		elseif event[1] == "key" then
			if event[2] == keys.left then
				if selected == 1 then
					selected = #colorList
				else
					selected = selected - 1
				end
			elseif event[2] == keys.right then
				if selected == #colorList then
					selected = 1
				else
					selected = selected + 1
				end
			elseif event[2] == keys.enter then
				os.pullEvent = oldPullEvent
				return colorList[selected]
			end
		end
	end
end

function cprint(text)
	if type(text) ~= 'table' then
		text = {text}
	end
	
	local w, h = term.getSize()
	
	for i=1,#text do
		local x, y = term.getCursorPos()
		term.setCursorPos(math.floor(w/2)-math.floor(text[i]:len()/2), y)
		print(text[i])
	end
end

function menu(items, title, start,allowNil,moreTitle)
	local function clear()
		term.clear()
		term.setCursorPos(1, 1)
	end
	
	local termWidth, termHeight = term.getSize()
	local drawSize = termHeight - 6
	
	local function maxPages()
		local itemCount = #items
		local pageCount = 0
		while itemCount > 0 do
			itemCount = itemCount - drawSize
			pageCount = pageCount + 1
		end
		return pageCount
	end
	
	local function iif(cond, trueval, falseval)
		if cond then
			return trueval
		else
			return falseval
		end
	end
	
	local function pagedItems()
		local ret = {}
		for i = 1, maxPages() do
			local tmp = {}
			local nElements = 0
			for j = drawSize*(i-1)+1, iif(drawSize*(i+1) > #items, #items, drawSize*(i+1)) do
				if nElements < drawSize then
					table.insert(tmp, items[j])
					nElements = nElements + 1
				end
			end
			table.insert(ret, tmp)
		end
		return ret
	end
	
	local selected = 1
	if start then
		selected = start
	end
	local page = 1
	
	local function redraw()
		term.setBackgroundColor(colors.black)
		clear()
		cprint(title)
		if moreTitle then
			head = moreTitle
		else
			head = {"Select with arrow keys or with mouse.","Press enter to select.",}
			if not allowNil or allowNil == true then
				head[3] = 'Terminate to cancel.'
			end
		end
		for i=1,3 do
			print(head[i])
		end
		pages = "<- (page "..page.." of "..maxPages()..") ->"
		print(pages)
		for i = 1, #pagedItems()[page] do
			if selected == drawSize*(page-1)+i then
				term.setBackgroundColor(colors.white)
				term.setTextColor(colors.black)
			else
				term.setBackgroundColor(colors.black)
				term.setTextColor(colors.white)
			end
			term.clearLine()
			print(iif(selected == drawSize*(page-1)+i, ">", " ").." "..pagedItems()[page][i])
			term.setBackgroundColor(colors.black)
			term.setTextColor(colors.white)
		end
	end

	local function changePage(pW)
		if pW == 1 and page < maxPages() then
			page = page + 1
			if selected + drawSize > #items then
				selected = #items
			else
				selected = selected + drawSize
			end
		elseif pW == -1 and page > 1 then
			page = page - 1
			if selected - drawSize < 1 then
				selected = 1
			else
				selected = selected - drawSize
			end
		end
	end
	
	while true do
		redraw()
		local eventData = {os.pullEventRaw()}
		if eventData[1] == "terminate" then
			if not allowNil or allowNil == true then
				clear()
				return nil
			end
		elseif eventData[1] == "key" then
			if eventData[2] == keys.up and selected > 1 then
				selected = selected - 1
				if selected-(page-1)*drawSize < 1 then
					page = page - 1
				end
			elseif eventData[2] == keys.down and selected < #items then
				selected = selected + 1
				if selected-(page-1)*drawSize > drawSize then
					page = page + 1
				end
			elseif eventData[2] == keys.enter then
				clear()
				return items[selected], selected
			elseif eventData[2] == keys.left then
				changePage(-1)
			elseif eventData[2] == keys.right then
				changePage(1)
			end
		elseif eventData[1] == 'mouse_click' then
			if eventData[4] > 5 then
				clear()
				selected = (eventData[4]-6+((page-1)*drawSize))+1
				return items[selected], selected
			elseif eventData[4] == 5 then
				if eventData[3] == 1 or eventData[3] == 2 then
					changePage(-1)
				elseif eventData[3] == pages:len()-1 or eventData[3] == pages:len()-2 then
					changePage(1)
				end
			end
		elseif eventData[1] == 'mouse_scroll' then
			if eventData[2] == 1 then
				changePage(1)
			elseif eventData[2] == -1 then
				changePage(-1)
			end
		end
		sleep(0)
	end
end

function yesno(text, title, start)
	local function clear()
		term.clear()
		term.setCursorPos(1, 1)
	end
	
	local function drawButton(buttonText, x, y, x2, y2, enabled)
		if enabled then
			term.setBackgroundColor(colors.white)
		else
			if term.isColor() then
				term.setBackgroundColor(colors.gray)
			end
		end
		term.setCursorPos(x, y)
		for _y = y, y2 do
			for _x = x, x2 do
				term.setCursorPos(_x, _y)
				write(" ")
			end
		end
		term.setCursorPos(x+math.floor((x2-x)/2)-math.floor(buttonText:len()/2), y+math.floor((y2-y+1)/2))
		term.setTextColor(colors.black)
		write(buttonText)
		term.setTextColor(colors.white)
		term.setBackgroundColor(colors.black)
	end
	
	local selected = true
	
	local function redraw()
		clear()
		cprint(title)
		term.setCursorPos(1, 3)
		print(text)
		local w, h = term.getSize()
		drawButton("Yes", 2, h-1, math.floor(w/2)-1, h-1, selected)
		drawButton("No", math.floor(w/2)+1, h-1, w-1, h-1, not selected)
	end
	
	if start ~= nil and type(start) == "boolean" then
		selected = start
	end
	local w, h = term.getSize()
	while true do
		redraw()
		local eventData = {os.pullEventRaw()}
		if eventData[1] == "terminate" then
			clear()
			return
		elseif eventData[1] == "key" then
			if eventData[2] == keys.up or eventData[2] == keys.down or eventData[2] == keys.left or eventData[2] == keys.right then
				selected = not selected
			elseif eventData[2] == keys.enter then
				clear()
				return selected
			end
		elseif eventData[1] == 'mouse_click' then
			if eventData[4] == h-1 then
				if eventData[3] >= math.floor(w/2)+1 and eventData[3] <= w-1 then
					clear()
					return false
				elseif eventData[3] >= 2 and eventData[3] <= math.floor(w/2)-1 then
					clear()
					return true
				end
			end
		end
		sleep(0)
	end
end

function button(pLabel,pX,pY,pCol)
	local xLen,yLen = term.getSize()
	local rtn = {}
	local rtn_m = {}
	rtn_m.__index = rtn_m
	rtn.label = pLabel
	if pX == 'm' then
		rtn.xStart = (xLen/2)-(pLabel:len()/2)
	else
		rtn.xStart = pX
	end

	rtn.xEnd = rtn.xStart+pLabel:len()+2
	rtn.y = pY
	rtn.color = pCol
	rtn.textColor = colors.white
	rtn.onClick = nil
	rtn.autoExec = true
	rtn.type = "button"
	
	setmetatable(rtn,rtn_m)

	function rtn_m:draw()
		paintutils.drawLine(self.xStart,self.y,self.xEnd,self.y,self.color)
		term.setCursorPos(self.xStart+1,self.y)
		term.setTextColor(self.textColor)
		write(self.label)
	end

	function rtn_m:setNewLabel(pLabel)
		local oLabel = self.label
		self.label = pLabel
		self.xEnd = self.xStart+self.label:len()+2 
	end
	
	function rtn_m:isClicked(pX,pY)
		if pY == self.y and pX >= self.xStart and pX <= self.xEnd then
			if self.autoExec and self.onClick then
				self.onClick()
			end
			return true
		else
			return false
		end 
	end
	
	return rtn
end

function clickedElements(pX,pY, ... )
	local x = { ... }
	for i,v in pairs(x) do
		if v:isClicked(pX,pY) then
			if v.type == 'button' then
				v:exec()
			end
			return v.label
		end
	end
	return false
end

clickedButtons = clickedElements

function progressBar(pX,pY,pLen,pCol,pTxt)
	local rtn = {}
	local rtn_m = {}
	rtn_m.__index = rtn_m

	rtn.x = pX
	rtn.y = pY
	rtn.len = pLen
	rtn.color = pCol
	rtn.textColor = colors.white
	rtn.showText = pTxt
	rtn.percent = 0
	rtn.type = "progressBar"

	setmetatable(rtn,rtn_m)

	function rtn_m:draw()
		term.setCursorPos(self.x,self.y)
		term.clearLine()
		local leng = math.floor((self.percent/100)*self.len)
		paintutils.drawLine(self.x,self.y,leng,self.y,self.color)
		term.setTextColor(self.textColor)
		term.setCursorPos((self.len/2)-1,self.y)
		term.setBackgroundColor(colors.black)
		write(tostring(self.percent)..' %')
	end
	
	function rtn_m:progress( pProgress )
		local progress
		if pProgress <= 1 then
			progress = pProgress*100	
		else
			progress = pProgress	
		end
		
		self.percent = progress
		self:draw()
	end

	return rtn
end

function splitStr(str, maxWidth)
	local words = {}
	for word in str:gmatch("[^ \t]+") do
		table.insert(words, word)
	end
	local lines = {}
	local cLn = 1
	for i, word in ipairs(words) do
		if not lines[cLn] then
			lines[cLn] = word
		elseif (lines[cLn].." "..word):len() > maxWidth then
			cLn = cLn + 1
			lines[cLn] = word
		else
			lines[cLn] = lines[cLn].." "..word
		end
	end
	return lines
end

function textField(pId,pX,pY,pLen,pBg,pTxt)
	local rtn = {}
	local rtn_m = {}
	rtn_m.__index = rtn_m
	rtn.x = pX
	rtn.y = pY
	
	if pLen == 'f' then
		local b
		rtn.len,b = term.getSize()
	else
		rtn.len = pLen
	end
	
	rtn.textColor = pTxt
	rtn.backgroundColor = pBg
	rtn.onClickRead = true
	rtn.value = ''
	rtn.id = pId
	rtn.text = pId
	rtn.type = "textField"
	
	setmetatable(rtn,rtn_m)
	
	function rtn_m:draw()
		paintutils.drawLine(self.x,self.y,self.len,self.y,self.backgroundColor)
		local sign,gray
		if self.value ~= '' then
			sign = self.value
			gray = false
		else
			sign = self.text
			gray = true
		end
		
		term.setCursorPos(self.x,self.y)
		term.clearLine()
		if gray then
			term.setTextColor(colors.gray)
		else
			term.setTextColor(self.textColor)
		end
		
		local i = 1
		while i <= sign:len() and i <= self.len do
			write(sign:sub(i,i))
			i = i+1
		end
	end
	
	function rtn_m:isClicked(pX,pY)
		if pX >= self.x and pX <= self.len and pY == self.y then
			if self.onClickRead then
				term.setCursorPos(self.x,self.y)
				term.setTextColor(self.textColor)
				term.setBackgroundColor(self.backgroundColor)
				term.clearLine()
				self.value = read()
			end
			return true
		else
			return false
		end
	end
	
	function rtn_m:warn()
	
	end
	
	return rtn
end

function contextMenu(pItems,pX,pY,pID)
	local rtn = {}
	local rtn_m = {}
	rtn_m["__index"] = rtn_m

	setmetatable(rtn,rtn_m)
	rtn.items = pItems
	rtn.x = pX
	rtn.y = pY
	rtn.color = colors.white
	rtn.textColor = colors.black
	rtn.clicked = false
	rtn.len = #rtn.items
	rtn.wide = 0
	rtn.onClickActions = {}
	rtn.type = "contextMenu"
	rtn.id = pID

	for i,v in pairs(rtn.items) do
		if v:len() > rtn.wide then
			rtn.wide = v:len()
		end
	end

	rtn.wide = rtn.wide+1

	function rtn_m:draw()
		term.setCursorPos(self.x,self.y)
		for i=0,self.len-1 do
			paintutils.drawLine(self.x, self.y+i, self.x+self.wide, self.y+i, self.color)
		end
		term.setTextColor(self.textColor)
		for i=1,self.len do
			term.setCursorPos(self.x+1,self.y+(i-1))
			print(self['items'][i])
		end
	end

	function rtn_m:isClicked(pX,pY, ... )
		if pX >= self.x and pX <= self.x+self.wide and pY >= self.y and pY <= self.y+self.len then
			local obj = (pY - self.y)+1
			self.object = self.items[obj]
			self.clicked = true
			if self.onClickActions[self.object] then
				self.onClickActions(self.id, ... )
			end
			return true,self.object
		else
			self.clicked = false
			self.object = nil
			return false
		end
	end

	function rtn_m:addOnClick(pItem,pFkt)
		self.onClickActions[pItem] = pFkt
	end

	return rtn
end

function textToTable(allowNil, ... )
	local inp = { ... }
	local rtn = {}
	for i,v in ipairs(inp) do
		if v.type == "textField" then	
			if not allowNil and v.value == '' then
				v:warn()
				return nil
			end
			rtn[v.id] = v.value
		end
	end
	return rtn
end

function createSwitch(tElements,yPos,colorSelect,colorNormal,pID)
		--"Label"
	rtn = {}
	rtn_m = {}
	rtn_m["__index"] = rtn_m
	setmetatable(rtn,rtn_m)

	rtn.type = "switch"
	rtn.id = pID
	rtn.buttons = {}
	rtn.color = colorNormal
	rtn.colorSelect = colorSelect
	rtn.onClick = nil
	rtn.y = yPos

	for i=1,#tElements do
		local j = 1
		if rtn.buttons[i-1] then
			j = rtn.buttons[i-1].xEnd
		end
		table.insert(rtn.buttons,ui.button(tElements[i],j,yPos,rtn.color))
	end

	rtn.select = rtn.buttons[1]

	function rtn_m:draw()
		for i,v in pairs(self.buttons) do
			if self.select == v then
				v.color = self.colorSelect
			else
				v.color = self.color
			end
			v:draw()
		end
	end

	function rtn_m:value()
		return self.select.label
	end

	function rtn_m:isClicked(pX,pY)
		if self.y == pY then
			for i,v in pairs(self.buttons) do
				if v:isClicked(pX,pY) then
					self.select = v
					if self.onClick then
						self.onClick(self.select.value,self.select)
					end
					return true,self.select
				end
			end
		end
		return false,self.select
	end

	return rtn
end

function toogle(pID,pX,pY)
	local rtn = {}
	local rtn_m = {}
	rtn_m.__index = rtn_m
	setmetatable(rtn,rtn_m)
	
	rtn.x = pX
	rtn.y = pY
	rtn.id = pID
	rtn.type = "toogle"
	rtn.value = false
		
	function rtn_m:draw()
		local dp = paintutils.drawPixel
		if self.value then
			dp(self.x,self.y,colors.green)
			dp(self.x+1,self.y,colors.green)
			term.setCursorPos(self.x+1,self.y)
			write("1")
			dp(self.x+2,self.y,colors.gray)
		else
			dp(self.x,self.y,colors.gray)
			dp(self.x+1,self.y,colors.red)
			dp(self.x+2,self.y,colors.red)
			term.setCursorPos(self.x+1,self.y)
			write("0")
		end
	end

	function rtn_m:isClicked(pX,pY)
		if pX >= self.x and pX <= self.x+2 and pY == self.y then
			self.value = not self.value
			self:draw()
			return true
		else
			return false
		end
	end
			
	function rtn_m:makeTo(pTrue, pFalse)
		if self.value then
			return pTrue
		else
			return pFalse
		end
	end
	
	return rtn
end

function inputNumber(pID,pX,pY,pLen,pColor)
	local rtn,rtn_m = {},{}
	rtn_m.__index = rtn_m
	setmetatable(rtn,rtn_m)

	rtn.x = pX
	rtn.y = pY
	rtn.id = pID
	rtn.len = pLen
	rtn.value = ""
	rtn.reverse = {}
	for i=1,rtn.len do
		rtn.value = rtn.value .. "0"
		rtn.reverse[i] = rtn.len-(i-1)
	end
	rtn.type = "inputNumber"
	rtn.color = pColor
	rtn.textColor = colors.white

	function rtn_m:draw()
		term.setTextColor(self.textColor)
		term.setBackgroundColor(self.color)
		for i=1,self.len do
			term.setCursorPos(self.x+(i-1),self.y)
			write("+")
			term.setCursorPos(self.x+(i-1),self.y+1)
			write(self.value:sub(i,i))
			term.setCursorPos(self.x+(i-1),self.y+2)
			write("-")
		end
	end

	function rtn_m:isClicked(pX,pY)
		if pX >= self.x and pX <= self.x+self.len and pY >= self.y and pY <= self.y+3 then
			local field = (pX-self.x)+1
			local front,back,handle,add
			
			if field > 1 then
				front = self.value:sub(1,field-1)
			else
				front = ""
			end

			if field < self.len then
				back = self.value:sub(field+1,self.value:len())
			else
				back = ""
			end
			
			handle = self.value:sub(field,field)

			if pY == self.y or pY == self.y+2 then
				local zehner = (self.reverse[field]-1)*10

				if zehner == 0 then
					zehner = 1
				end

				if pY == self.y then
					add = zehner
				else
					add = -zehner
				end

				handle = tostring( tonumber(self.value) + add )
				--self.value = front..handle..back
			else
				term.setCursorPos(self.x,self.y+1)
				self.value = read()
			end
			self:draw()
			return true
		else
			return false
		end
	end

	function rtn_m:asNumber()
		return tonumber(self.value)
	end

	return rtn
end

function listView(pid, pX, pY, pLen, pWide, tListItems)
	local rtn = {}
	local rtn_m = {}
	rtn_m.__index = rtn_m
	setmetatable(rtn,rtn_m)
	
	rtn.x = pX
	rtn.y = pY
	rtn.len = pLen == "f" and yLen or pLen
	rtn.wide = pWide == "f" and xLen or pWide
	rtn.maxX = rtn.x + rtn.wide
	rtn.maxY = rtn.y + rtn.len
	
	rtn.elements = #tListItems
	rtn.list = tListItems
	rtn.page = 1
	rtn.type = "listView"
	rtn.clickable = {}
	rtn.id = pid
	
	function rtn_m:draw()
		ui.clearArea(self.y, self.maxY)
		self.clickable = {}
		term.setCursorPos(self.x,self.y)
		local temp1, temp2 = 0,0
		local c = self.page
		while ui.isSpace() and c <= self.elements do
			temp1 = self:item(self.x, self.y+temp2, self.list[c], c)
			for i=1,temp1 do
				self.clickable[temp2+i] = c
			end
			temp2 = temp2+temp1
			c = c+1
		end
	end

	function rtn_m:newList(pList)
		self.list = pList
		self.elements = #pList
		self:draw()
	end
	
	function rtn_m:item(pX, pY, pItem, pNumber)
		local col
		if (pNumber / 2) == math.floor(pNumber/2) then
			col = colors.gray
		else
			col = colors.lightGray
		end
		term.setCursorPos(pX,pY)
		local len = 1
		if type(pItem) == "table" then
			for i=1,#pItem do
				paintutils.drawLine(pX,pY+(i-1),xLen,pY+(i-1),col)
			end
			term.setCursorPos(pX, pY)
			for i=1,#pItem do
				print(pItem[i])
			end
			len = #pItem
		else
			paintutils.drawLine(pX,pY,xLen,pY,col)
			print(pItem)
		end
		
		return len
	end
	
	function rtn_m.isClicked(pX, pY)
		if pX >= self.x and pX <= self.maxX and pY >= self.y and pY <= self.maxY then
			local itemThere = self.clickable[ (pY - self.y) + 1 ] 
			local itemList = self.list[ itemThere + (self.page - 1) ]
			return true, itemThere + (self.page - 1), itemList
		else
			return false
		end
	end
	
	function rtn_m:handleScroll(pF, pX, pY)
		if pX and pY then
			local buffer = self.autoExec
			self.autoExec = false
			local ist = self:isClicked(pX, pY)
			self.autoExec = buffer
			if ist then
				self.page = self.page+pF
				self:draw()
			end
		else
			self.page = self.page+pF
			self:draw()
		end
	end
	
	return rtn
end

function inGreen(pTxt)
	term.setTextColor(8192)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inBrown(pTxt)
	term.setTextColor(4096)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inBlack(pTxt)
	term.setTextColor(32768)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inPink(pTxt)
	term.setTextColor(64)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inYellow(pTxt)
	term.setTextColor(16)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inOrange(pTxt)
	term.setTextColor(2)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inMagenta(pTxt)
	term.setTextColor(4)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inPurple(pTxt)
	term.setTextColor(1024)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inCyan(pTxt)
	term.setTextColor(512)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inRed(pTxt)
	term.setTextColor(16384)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inWhite(pTxt)
	term.setTextColor(1)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inLightBlue(pTxt)
	term.setTextColor(8)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inLightGray(pTxt)
	term.setTextColor(256)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inGray(pTxt)
	term.setTextColor(128)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inLime(pTxt)
	term.setTextColor(32)
	print(pTxt)
	term.setTextColor(colors.white)
end

function inBlue(pTxt)
	term.setTextColor(2048)
	print(pTxt)
	term.setTextColor(colors.white)
end
