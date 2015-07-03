local file = false
local mitem
local copyname
local rpath = "/.SertexOS/apps/filemanager/" --here goes sertex path later
local copypath
local mx,my
local bgColor = colors.white
local bar = colors.red
local iconlist = fs.list(rpath.."icons")
local icons = {}
local tArgs = {...}
local path = tArgs[1] or ""
for i,v in pairs(iconlist) do
  --check the icon
  if fs.isDir(rpath.."icons/"..v) then
    error("Malformed icon("..v..")",0)
  end
  local f = fs.open(rpath.."icons/"..v,"r")
  local max = 0
  local lines = 0
  local line = f.readLine()
  while line do
    lines = lines + 1
    if #line > max then
      max = #line
    end
    line = f.readLine()
  end
  if lines > 4 or max > 5 then
    error("Malformed icon("..v..")",0)
  end
  --load the icon
  icons[v] = paintutils.loadImage(rpath.."icons/"..v)
end
if not icons["unknown"] or not icons["folder"] then
  error("Missing important icons",0)
end
if not fs.isDir(path) then
  error("Malformed path",0)
end
local function updateTitle()
  local title = path
  if path == "" then title = "/" end
  title = "File: "..title
  multishell.setTitle(multishell.getCurrent(),title)
end
updateTitle()
local curPage = tonumber(tArgs[2]) or 1 --for dev
local x,y = term.getSize()
local items = math.floor(x/12)
local rows = math.floor(y/8)
local count = items*rows
while true do
  local list = fs.list(path)
  term.setBackgroundColor(bgColor)
  term.clear()
  local pages = {{{}}}
  for i,v in pairs(list) do
    local num = i
    local page = math.ceil(num/count)
    num = num - ((page-1)*count)
    local row = math.ceil(num/items)
    num = num - ((row-1)*items)
    if not pages[page] then
      pages[page] = {}
    end
    if not pages[page][row] then
      pages[page][row] = {}
    end
    pages[page][row][num] = v
  end
  term.setCursorPos(1,1)
  term.setBackgroundColor(bar)
  term.clearLine()
  term.setTextColor(colors.white)
  term.write(" < "..curPage.." >   "..path)
  local x,y = term.getSize()
  term.setCursorPos(x-4,1)
  term.setBackgroundColor(bar)
  write("<-- ")
  term.setBackgroundColor(colors.red)
  term.write("X")
  term.setBackgroundColor(bgColor)
  term.setTextColor(colors.red)
  for i,row in pairs(pages[curPage]) do
    --draw
    for i2,item in pairs(row) do
      local x,y = 1,2
      y = y + (i*8)
      x = x + (i2*12)
      x = x - 12
      --that is the bootom left corner
      --icons are 5 widht so wait i am confused
      --we have 12 space we put the item after 3.5? so should we use 3 or 4? 
      local ix = x + 3
      local iy = y - 5
      --ok lets check the item
      local icon
      if fs.isDir(fs.combine(path,item)) then
        icon = icons["folder"]
      else
        local name = {}
        for w in (item.."."):gmatch("([^.]*).") do
          table.insert(name,w)
        end
        if #name > 1 then
          local type = name[#name]
          icon = icons[type] or icons["unknown"]
        else
          icon = icons["unknown"]
        end
      end
      paintutils.drawImage(icon,ix,iy)
      x = x + math.floor(6 - #item/2)
      term.setCursorPos(x,y) --i will work on center later
      term.setBackgroundColor(bgColor)
      term.write(item)
    end
  end
  if mx and my then
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.black)
    term.setCursorPos(mx,my)
    if file then
      write(" Copy  ")
    end
    if not copypath then
      term.setTextColor(colors.gray)
    end
    term.setCursorPos(mx,my + 1)
    write(" Paste ")
    if file then
      term.setCursorPos(mx, my + 2)
      term.setTextColor(colors.red)
      write(" Delete")
    end
  end
  local e,k,x,y = os.pullEvent()
  local sx,sy = term.getSize()
  if (e == "key" and k == keys.right) or (e == "mouse_click" and y == 1 and k == 1 and x == 2)then
    curPage = curPage - 1
    if curPage > #pages then
      curPage = 1
    end
    mx,my = nil,nil
  elseif (e == "key" and k == keys.left) or (e == "mouse_click" and k == 1 and x == (5 + #tostring(curPage)) and y == 1) then
    curPage = curPage + 1
    if curPage < 1 then
      curPage = #pages
    end
    mx,my = nil,nil
  elseif e == "mouse_click" and k == 1 and  y == 1 and x == sx then
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1,1)
    return
  elseif e == "mouse_click" and k == 1 and y == 1 and x >= sx-5 and x <= sx-2 then
    local folders = {}
    for w in (path.."/"):gmatch("([^/]*)/") do
      table.insert(folders,w)
    end
    folders[#folders] = nil
    path = table.concat(folders,"/")
    updateTitle()
    mx,my = nil,nil
  elseif e == "mouse_click" then
    local cont = true
    if mx and my then
      if x >= mx and x <= mx + 7 then
        if y == my and file then
          copypath = fs.combine(path,mitem)
          copyname = mitem
          cont = false
        elseif y == my + 1 then
          local paste = fs.combine(path,copyname)
          while fs.exists(paste) do
            paste = paste.." - Copy"
          end
          fs.copy(copypath,paste)
          copypath = nil
        elseif y == my + 2 and file then
          local del = ui.yesno("Are you sure?","Delete: "..mitem,false)
          if del then
            fs.delete(mitem)
          end
        end
      end
    end
    mx,my = nil,nil
    file = false
    if cont then
      for i,row in pairs(pages[curPage]) do
        for i2,item in pairs(row) do
          local sx,sy = 1,2
          sy = sy + (i*8)
          sx = sx + (i2*12)
          sx = sx - 12
          local ix = sx + 3 + 5
          local iy = sy - 5
          if x >= sx and x <= ix and y >= iy and y <= sy then
            if k == 1 then
              --ok just for folders currently
              if fs.isDir(fs.combine(path,item)) then
                path = fs.combine(path,item)
                curPage = 1
                updateTitle()
              end
              break
            elseif k == 2 then
              mx = x
              my = y
              file = true
              mitem = item
            end
          end
        end
      end
      if k == 2 then
        mx = x
        my = y
      end
    end
  end
end
