--SertexText API by Ale2610 and MultMine
--1.4

--normal

function right(y, text )
        w, h = term.getSize()
        term.setCursorPos(w - #text, y)
        write(text)
end

function left(y, text)
	term.setCursorPos(1, y)
	write( text )
end

function center(y, text )
        w, h = term.getSize()
        term.setCursorPos((w - #text) / 2, y)
        write(text)
end

function centerDisplay( text )
        w, h = term.getSize()
        term.setCursorPos(( w - string.len(text)) / 2, h / 2)
        write( text )
end

--slow

function slowRight(y, text )
        w, h = term.getSize()
        term.setCursorPos(w - #text, y)
        textutils.slowWrite(text)
end

function slowLeft(y, text)
	term.setCursorPos(1, y)
	textutils.slowWrite( text )
end

function slowCenter(y, text )
        w, h = term.getSize()
        term.setCursorPos((w - #text) / 2, y)
        textutils.slowWrite(text)
end

function slowCenterDisplay( text )
        w, h = term.getSize()
        term.setCursorPos(( w - string.len(text)) / 2, h / 2)
        textutils.slowWrite( text )
end

--color

function rightColor(y, color, text)
  if not term.isColor() then
    print("Colors not supported")
  end
  w, h = term.getSize()
  term.setCursorPos(w - #text, y)
  term.setTextColor(color)
  write(text)
end

function leftColor(y, color, text)
  if not term.isColor() then
    print("Colors not supported")
  end
  term.setCursorPos(1, y)
  term.setTextColor(color)
  write(text)
end

function centerColor(y, color, text)
  if not term.isColor() then
    print("Colors not supported")
  end
       w, h = term.getSize()
	term.setCursorPos((w - #text) / 2, y)
	term.setTextColor(color)
	write(text)
end

function CenterDisplayColor(color, text)
  if not term.isColor() then
    print("Colors not supported")
  end
        x, y = term.getSize()
        term.setCursorPos(( x - string.len(text)) / 2, y / 2)
		term.setTextColor(color)
        write( text )
end

--slow color

function slowRightColor(y, color, text )
  if not term.isColor() then
    print("Colors not supported")
  end
        w, h = term.getSize()
        term.setCursorPos(w - #text, y)
		term.setTextColor(color)
        textutils.slowWrite(text)
end

function slowLeftColor(y, color, text)
  if not term.isColor() then
    print("Colors not supported")
  end
	term.setCursorPos(1, y)
	term.setTextColor(color)
	textutils.slowWrite( text )
end

function slowCenterColor(y, color, text )
  if not term.isColor() then
    print("Colors not supported")
  end
        w, h = term.getSize()
        term.setCursorPos((w - #text) / 2, y)
		term.setTextColor(color)
        textutils.slowWrite(text)
end

function slowCenterDisplayColor(color, text)
  if not term.isColor() then
    print("Colors not supported")
  end
        x, y = term.getSize()
        term.setCursorPos(( x - string.len(text)) / 2, y / 2)
		term.setTextColor(color)
        textutils.slowWrite( text )
end

--setCursorPos

function setCursorPosText(x, y, text)
  term.setCursorPos(x, y)
  write(text)
end

function slowSetCursorPosText(x, y, text)
  term.setCursorPos(x, y)
  textutils.slowWrite(text)
end
  
function setCursorPosTextColor(x, y, color, text)
  if not term.isColor() then
    print("Colors not supported")
  end
  term.setCursorPos(x, y)
  term.setTextColor(color)
  write(text)
end

function slowSetCursorPosTextColor(x, y, color, text)
  if not term.isColor() then
    print("Colors not supported")
  end
  term.setCursorPos(x, y)
  term.setTextColor(color)
  textutils.slowWrite(text)
end

function monitor(monitor, x, y, text)
  stMonitor = peripheral.wrap(monitor)
  stMonitor.setCursorPos(x, y)
  stMonitor.write(text)
end

function monitorColor(monitor, x, y, color, text)
  stMonitor = peripheral.wrap(monitor)
  stMonitor.setCursorPos(x, y)
  stMonitor.setTextColor(color)
  stMonitor.write(text)
end

function slowMonitor(monitor, x, y, text) --don't use
  stMonitor = peripheral.wrap(monitor)
  stMonitor.setCursorPos(x, y)
  stMonitor.write(text)
  
  --From textutils API
  nRate = nRate or 20
    if nRate < 0 then
        error( "Rate must be positive", 2 )
    end
    local nSleep = 1 / nRate
        
    sText = tostring( sText )
    local x,y = term.getCursorPos(x,y)
    local len = string.len( sText )
    
    for n=1,len do
        term.setCursorPos( x, y )
        sleep( nSleep )
        local nLines = write( string.sub( sText, 1, n ) )
        local newX, newY = term.getCursorPos()
        y = newY - nLines
    end
	--end
end

--info

function getInfo()
	write("SertexText API by Ale2610 and MultMine\nVersion: 1.4\n")
end