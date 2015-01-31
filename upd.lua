local files = {
	["src/SertexOS.lua"] = "SertexOS",
	["src/apis/api.lua"] = "apis/api",
	["src/apis/graphics.lua"] = "apis/graphics",
	["src/apis/sertextext.lua"] = "apis/sertextext",
	--["src/desktop"] = "desktop.lua"
	["update"] = "update",
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
		file.write(text)
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
print("Press any key")
os.pullEvent("key")
shell.run("SertexOS")

