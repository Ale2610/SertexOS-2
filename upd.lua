--SertexOS 2 Installer

shell.setDir("/")
if fs.exists("startup") then
	if fs.exists("startup.bak") then
		fs.delete("startup.bak")
	end
	fs.move("startup", "startup.bak")
end

if not fs.exists("/.SertexOS/config") then
	local f = fs.open("/.SertexOS/config","w")
	f.write("configVersion = 1\nlanguage = \"en\"")
	f.close()
else
	dofile("/.SertexOS/config")
	if not configVersion == 1 then
		local f = fs.open("/.SertexOS/config","w")
		f.write("configVersion = 1\nlanguage = \"en\"")
		f.close()
	end
end

systemDir = ".SertexOS"

local files = {
	["src/SertexOS.lua"] = systemDir.."/SertexOS",
	["src/apps/shell/shell.lua"] = systemDir.."/apps/shell/shell",
	["src/apps/shell/logo"] = systemDir.."/apps/shell/logo",
	["src/apps/firewolf/firewolf.lua"] = systemDir.."/apps/firewolf/firewolf",
	["src/apps/firewolf/logo"] = systemDir.."/apps/firewolf/logo",
	["src/root/multitask.lua"] = systemDir.."/root/multitask",
	["src/apps/fg.lua"] = systemDir.."/apps/fg",
	["src/apis/api.lua"] = systemDir.."/apis/api",
	["src/apis/ui.lua"] = systemDir.."/apis/ui",
	["src/apis/graphics.lua"] = systemDir.."/apis/graphics",
	["src/apis/sertextext.lua"] = systemDir.."/apis/sertextext",
	["src/apis/sha256.lua"] = systemDir.."/apis/sha256",
	["update"] = systemDir.."/update",
	["src/startup"] = "/startup",
	
	["src/lang/en.lang"] = systemDir.."/lang/en.lang",
	["src/lang/it.lang"] = systemDir.."/lang/it.lang",
	["src/lang/de.lang"] = systemDir.."/lang/de.lang",
}

local githubUser    = "Sertex-Team"
local githubRepo    = "SertexOS-2"
local githubBranch  = "master"

local installerName = "SertexOS 2 Updater" -- if you need one, this will replace "Installer for user/repo, branch branch"

local function clear()
	term.clear()
	term.setCursorPos(1, 1)
end

local function httpGet(url, save)
	if not url then
		error("not enough arguments, expected 1 or 2", 2)
	end
	local remote = http.get(url)
	if not remote then
		return false
	end
	local text = remote.readAll()
	remote.close()
	if save then
		local file = fs.open(save, "w")
		file.write(text)
		file.close()
		return true
	end
	return text
end

local function get(user, repo, bran, path, save)
	if not user or not repo or not bran or not path then
		error("not enough arguments, expected 4 or 5", 2)
	end
    local url = "https://raw.github.com/"..user.."/"..repo.."/"..bran.."/"..path
	local remote = http.get(url)
	if not remote then
		return false
	end
	local text = remote.readAll()
	remote.close()
	if save then
		local file = fs.open(save, "w")
		file.write(text) --# attempt to index ? a nil valuef
		file.close()
		return true
	end
	return text
end

local function getFile(file, target)
	return get(githubUser, githubRepo, githubBranch, file, target)
end

shell.setDir("")

clear()

print(installerName or ("Installer for " .. githubUser .. "/" .. githubRepo .. ", branch " .. githubBranch))
print("Getting files...")
local fileCount = 0
for _ in pairs(files) do
	fileCount = fileCount + 1
end
local filesDownloaded = 0

local w, h = term.getSize()

for k, v in pairs(files) do
	term.setTextColor(colors.red)
	term.setBackgroundColor(colors.white)
	clear()
	term.setCursorPos(2, 2)
	print(installerName or ("Installer for " .. githubUser .. "/" .. githubRepo .. ", branch " .. githubBranch))
	term.setCursorPos(2, 4)
	print("File: "..v)
	term.setCursorPos(2, h - 1)
	print(tostring(math.floor(filesDownloaded / fileCount * 100)).."% - "..tostring(filesDownloaded + 1).."/"..tostring(fileCount))
	local ok = k:sub(1, 4) == "ext:" and httpGet(k:sub(5), v) or getFile(k, v)
	if not ok then
		if term.isColor() then
			term.setTextColor(colors.red)
		end
		term.setCursorPos(2, 6)
		print("Error getting file:")
		term.setCursorPos(2, 7)
		print(k)
		sleep(1)
	end
	filesDownloaded = filesDownloaded + 1
end
clear()
term.setCursorPos(2, 2)
print("Press any key to continue.")
local w, h = term.getSize()
term.setCursorPos(2, h-1)
print("100% - "..tostring(filesDownloaded).."/"..tostring(fileCount))
os.pullEvent("key")

os.reboot()

