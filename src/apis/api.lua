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

function crash(reason,message) --for crash (please code it)
	lock()
	reasons = {
		["bypass"] = "System Bypassed",
		["security"] = "System Security Issue",
		["crash"] = "System Crashed",
		["unknown"] = "Unknown Error",
		["seretx"] = "SeretxOS 2 crashed again :C",
	}
		term.setBackgroundColor(colors.blue)
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.white)
		sertextext.center(1,"SertexOS 2 Crashed:")
		sertextext.center(2,reasons[reason])
		sertextext.center(4,message)
		sertextext.center(7,"Automatic Reboot In 10 Seconds.")
		sertextext.center(8,"Please report on the github repo")
		sleep(10)
		os.reboot()
end
