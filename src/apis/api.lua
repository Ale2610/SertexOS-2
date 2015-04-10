function clear()
  term.setBackgroundColor(colors.white)
  term.clear()
  term.setCursorPos(1,1)
  term.setTextColor(colors.red)
end


local baseDir = SertexOS.baseDir

local ope = os.pullEvent

function log(text)
  local ftime = textutils.formatTime(os.time(), true)
  local str = "["..string.rep(" ", 5-ftime:len())..ftime.."] "..text
  if not SertexOS.quiet then
    print(str)
  end
  local f = fs.open(fs.combine(baseDir, "SertexOS.log"), "a")
  f.writeLine(str)
  f.close()
end

function lock()
  os.pullEvent = os.pullEventRaw
end

function unlock()
  os.pullEvent = ope
end

function setLogging(val)
  if type(val) == "boolean" then
    SertexOS.quiet = not val
  end
end