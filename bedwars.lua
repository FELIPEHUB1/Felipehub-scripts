--// Texto RGB "FELIPEHUB" no canto inferior da tela
local RunService = game:GetService("RunService")
local TextLabel = Drawing.new("Text")
TextLabel.Text = "FELIPEHUB"
TextLabel.Size = 24
TextLabel.Outline = true
TextLabel.OutlineColor = Color3.fromRGB(0,0,0)
TextLabel.Center = false
TextLabel.Position = Vector2.new(20, workspace.CurrentCamera.ViewportSize.Y - 40)
TextLabel.Visible = true

-- Função para trocar cor RGB
task.spawn(function()
    local r,g,b = 255,0,0
    local step = "gUp"
    while task.wait(0.05) do
        if step == "gUp" then g = g + 15 if g >= 255 then g = 255 step = "rDown" end
        elseif step == "rDown" then r = r - 15 if r <= 0 then r = 0 step = "bUp" end
        elseif step == "bUp" then b = b + 15 if b >= 255 then b = 255 step = "gDown" end
        elseif step == "gDown" then g = g - 15 if g <= 0 then g = 0 step = "rUp" end
        elseif step == "rUp" then r = r + 15 if r >= 255 then r = 255 step = "bDown" end
        elseif step == "bDown" then b = b - 15 if b <= 0 then b = 0 step = "gUp" end end
        TextLabel.Color = Color3.fromRGB(r,g,b)
    end
end)

--// ---------------------- Loader Rust ---------------------- //
local isfile = isfile or function(file)
    local suc, res = pcall(function() return readfile(file) end)
    return suc and res ~= nil and res ~= ''
end

local delfile = delfile or function(file)
    writefile(file, '')
end

local function downloadFile(path, func)
    if not isfile(path) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/0xEIite/rust/'..readfile('rust/profiles/commit.txt')..'/'..select(1, path:gsub('rust/', '')), true)
        end)
        if not suc or res == '404: Not Found' then
            error(res)
        end
        if path:find('.lua') then
            res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after rust updates.\n'..res
        end
        writefile(path, res)
    end
    return (func or readfile)(path)
end

local function wipeFolder(path)
    if not isfolder(path) then return end
    for _, file in listfiles(path) do
        if file:find('loader') then continue end
        if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after rust updates.')) == 1 then
            delfile(file)
        end
    end
end

for _, folder in {'rust', 'rust/games', 'rust/profiles', 'rust/assets', 'rust/libraries', 'rust/guis'} do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

if not shared.RustDeveloper then
    local _, subbed = pcall(function() 
        return game:HttpGet('https://github.com/0xEIite/rust') 
    end)
    local commit = subbed:find('currentOid')
    commit = commit and subbed:sub(commit + 13, commit + 52) or nil
    commit = commit and #commit == 40 and commit or 'main'
    local firstInstall = not isfile('rust/profiles/commit.txt')
    if commit == 'main' or (isfile('rust/profiles/commit.txt') and readfile('rust/profiles/commit.txt') or '') ~= commit then
        wipeFolder('rust')
        wipeFolder('rust/games')
        wipeFolder('rust/guis')
        wipeFolder('rust/libraries')
    end
    writefile('rust/profiles/commit.txt', commit)
    if firstInstall then
        local profiles = {
            "default6872274481.txt",
            "default6872265039.txt",
            "6016588693.gui.txt"
        }
        for _, profile in next, profiles do
            local path = 'rust/profiles/'..profile
            downloadFile(path)
        end
    end
end

return loadstring(downloadFile('rust/main.lua'), 'main')()
