local termW, termH = term.getSize()

local sidebar = {
  {"Shutdown", function()
    local function printMsg(color)
      term.setBackgroundColor(color)
      term.setTextColor(colors.white)
      term.clear()
      term.setCursorPos(1, 1)
      sertextext.centerDisplay("Shutting Down...")
      sleep(0.1)
    end
    printMsg(colors.white)
    printMsg(colors.lightGray)
    printMsg(colors.gray)
    printMsg(colors.black)
    sleep(0.6)
    os.shutdown()
  end},
  {"Reboot", function()
    local function printMsg(color)
      term.setBackgroundColor(color)
      term.setTextColor(colors.white)
      term.clear()
      term.setCursorPos(1, 1)
      sertextext.centerDisplay("Rebooting...")
      sleep(0.1)
    end
    printMsg(colors.white)
    printMsg(colors.lightGray)
    printMsg(colors.gray)
    printMsg(colors.black)
    sleep(0.6)
    os.reboot()
  end},
  {"Logout", function()
    print("wip")
    sleep(1)
    os.queueEvent("terminate")
  end},
}

local sidebarVisible = false
local sidebarWidth = 0
for i, v in ipairs(sidebar) do
  if v[1]:len() > sidebarWidth then
    sidebarWidth = v[1]:len()
  end
end

local function redraw()
  term.setBackgroundColor(colors.white)
  term.clear()
  term.setCursorPos(1,1)
  term.setTextColor(colors.red)
  graphics.line(termW, 1, termW, termH, colors.red)
  term.setCursorPos(termW, math.ceil(termH / 2))
  term.setTextColor(colors.white)
  if sidebarVisible then
    graphics.box(termW - sidebarWidth - 5, 1, termW - sidebarWidth - 3, termH, colors.orange)
    graphics.box(termW - sidebarWidth - 2, 1, termW - 1, termH, colors.red)
    write(">")
    for i, v in ipairs(sidebar) do
      term.setCursorPos(termW - sidebarWidth, i + 1)
      write(v[1])
    end
  else
    write("<")
  end
end

while true do
  redraw()
  local ev = {os.pullEventRaw()}
  if ev[1] == "terminate" then
    return
  elseif ev[1] == "mouse_click" then
    if ev[3] == termW then
      sidebarVisible = not sidebarVisible
    elseif ev[3] >= termW - sidebarWidth
    and    ev[3] <= termW - 1
    and    ev[4] >= 2
    and    sidebarVisible then
      if sidebar[ev[4] - 1] then
        sidebar[ev[4] - 1][2]()
      end
    end
  end
end