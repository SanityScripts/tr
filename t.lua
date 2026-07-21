local correctGameIds = {14195703130}
local gameId = game.PlaceId
local gameName = "Murderers VS Sheriffs DUELS"
local isCorrectGame = false

for _, id in pairs(correctGameIds) do
    if gameId == id then
        isCorrectGame = true
        break
    end
end

if not isCorrectGame then
    task.delay(1, function()
        game:GetService("Players").LocalPlayer:Kick("Wrong server. Go to TradingHub (Murderers VS Sheriffs DUELS) game.")
    end)
    return
end

if getgenv().fjevgbrivgtuthui then
    warn("You have already executed the trade helper!")
    return
end
getgenv().fjevgbrivgtuthui = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Results = {
    Passed = 0,
    Failed = 0,
    Tests = {}
}

local function RunCheck(Index, Name, Func)
    local Success = pcall(Func)
    if Success then
        Results.Passed = Results.Passed + 1
        table.insert(Results.Tests, "[PASS ->] " .. Index .. ". " .. Name .. " check")
    else
        Results.Failed = Results.Failed + 1
        table.insert(Results.Tests, "[-> FAIL] " .. Index .. ". " .. Name .. " check")
    end
end

local InstanceCreator = Instance and Instance.new or nil
local NewCFrame = CFrame and CFrame.new or nil
local SanityCheckFinish = false

task.spawn(function()
    RunCheck(1, "instance new", function()
        if typeof(InstanceCreator) ~= "function" then
            error("Instance.new is not a function")
        end
        local part = InstanceCreator("Part")
        if not part or not part:IsA("BasePart") then
            error("Failed to create Part instance")
        end
        part:Destroy()
    end)

    RunCheck(2, "cframe new", function()
        local cf = NewCFrame(1, 2, 3)
        if typeof(cf) ~= "CFrame" then
            error("CFrame.new did not return a CFrame")
        end
        if cf.X ~= 1 or cf.Y ~= 2 or cf.Z ~= 3 then
            error("CFrame position values are incorrect")
        end
    end)

    RunCheck(3, "get service", function()
        local ok, players = pcall(game.GetService, game, "Players")
        if not ok or players ~= game.Players then
            error("GetService failed for Players service")
        end
    end)

    RunCheck(4, "vector3 new", function()
        local v = Vector3.new(4, 5, 6)
        if typeof(v) ~= "Vector3" then
            error("Vector3.new did not return a Vector3")
        end
        if v.X ~= 4 or v.Y ~= 5 or v.Z ~= 6 then
            error("Vector3 position values are incorrect")
        end
    end)

    RunCheck(5, "task functions", function()
        local SpawnFunc = task.spawn or spawn
        local WaitFunc = task.wait or wait
        if typeof(SpawnFunc) ~= "function" then
            error("task.spawn or spawn is not a function")
        end
        local ran = false
        SpawnFunc(function()
            ran = true
        end)
        WaitFunc(0.1)
        if not ran then
            error("Spawned function did not execute")
        end
    end)

    RunCheck(6, "tween service creation", function()
        local TweenService = game:GetService("TweenService")
        local part = Instance.new("Part")
        local tweenInfo = TweenInfo.new(0.1)
        local tween = TweenService:Create(part, tweenInfo, { Transparency = 1 })
        if not tween or typeof(tween.Play) ~= "function" then
            error("TweenService:Create failed")
        end
        part:Destroy()
    end)

    RunCheck(7, "instance cloning", function()
        local part = Instance.new("Part")
        part.Name = "Original"
        local clone = part:Clone()
        if not clone or clone.Name ~= "Original" then
            error("Instance:Clone failed")
        end
        part:Destroy()
        clone:Destroy()
    end)

    RunCheck(8, "findfirstchild and waitforchild", function()
        local folder = Instance.new("Folder")
        folder.Name = "FolderTest"
        local child = Instance.new("Part")
        child.Name = "ChildPart"
        child.Parent = folder
        if folder:FindFirstChild("ChildPart") ~= child then
            error("FindFirstChild failed")
        end
        local found = folder:WaitForChild("ChildPart", 1)
        if found ~= child then
            error("WaitForChild failed")
        end
        folder:Destroy()
    end)

    RunCheck(9, "runservice event functions", function()
        local RunService = game:GetService("RunService")
        for _, evName in ipairs({ "Heartbeat", "RenderStepped", "Stepped" }) do
            local ev = RunService[evName]
            if ev and typeof(ev.Connect) ~= "function" then
                error("RunService event " .. evName .. " is not connectable")
            end
        end
    end)

    RunCheck(10, "workspace raycast", function()
        local WorkspaceService = game:GetService("Workspace")
        local origin = Vector3.new(0, 10, 0)
        local direction = Vector3.new(0, -20, 0)
        local result = WorkspaceService:Raycast(origin, direction)
        if typeof(WorkspaceService.Raycast) ~= "function" then
            error("Workspace:Raycast is not a function")
        end
    end)

    RunCheck(11, "tween transparency changes", function()
        local TweenService = game:GetService("TweenService")
        local part = Instance.new("Part")
        part.Parent = workspace
        local tweenInfo = TweenInfo.new(0.1)
        local tween = TweenService:Create(part, tweenInfo, { Transparency = 0.5 })
        tween:Play()
        task.wait(0.15)
        if math.abs(part.Transparency - 0.5) > 0.01 then
            error("Tween did not change transparency correctly")
        end
        part:Destroy()
    end)

    RunCheck(12, "vector3 addition and magnitude", function()
        local a = Vector3.new(1, 2, 3)
        local b = Vector3.new(4, 5, 6)
        local c = a + b
        if c.X ~= 5 or c.Y ~= 7 or c.Z ~= 9 then
            error("Vector3 addition failed")
        end
        if math.abs(c.Magnitude - math.sqrt(5 ^ 2 + 7 ^ 2 + 9 ^ 2)) > 0.01 then
            error("Vector3 magnitude calculation failed")
        end
    end)

    RunCheck(13, "remote event firing", function()
        local event = Instance.new("RemoteEvent")
        local fired = false
        event.OnServerEvent:Connect(function() fired = true end)
        task.spawn(function() event:FireServer() end)
        task.wait(0.1)
        if not fired then
            error("RemoteEvent:FireServer failed")
        end
        event:Destroy()
    end)

    RunCheck(14, "cframe new and positioning", function()
        local cf1 = CFrame.new(1, 2, 3)
        local cf2 = CFrame.new(0, 1, 0)
        local cf3 = cf1 * cf2
        local expected = Vector3.new(1, 3, 3)
        local pos = cf3.Position
        if pos.X ~= expected.X or pos.Y ~= expected.Y or pos.Z ~= expected.Z then
            error("CFrame multiplication failed")
        end
    end)

    RunCheck(15, "workspace raycast", function()
        local part = Instance.new("Part")
        part.Anchored = true
        part.Size = Vector3.new(4, 1, 4)
        part.Position = Vector3.new(0, 5, 0)
        part.Parent = workspace
        local origin = Vector3.new(0, 10, 0)
        local direction = Vector3.new(0, -10, 0)
        local result = workspace:Raycast(origin, direction)
        if not result or result.Instance ~= part then
            part:Destroy()
            error("Raycast did not detect the part")
        end
        part:Destroy()
    end)

    RunCheck(16, "humanoid health manipulation", function()
        local model = Instance.new("Model")
        local humanoid = Instance.new("Humanoid")
        humanoid.Health = 100
        humanoid.Parent = model
        model.Parent = workspace
        humanoid:TakeDamage(25)
        task.wait(0.05)
        if humanoid.Health ~= 75 then
            model:Destroy()
            error("Humanoid:TakeDamage failed")
        end
        model:Destroy()
    end)

    RunCheck(17, "seat and weldconstraint", function()
        local seat = Instance.new("Seat")
        seat.Anchored = false
        seat.Position = Vector3.new(0, 5, 0)
        seat.Parent = workspace
        local part = Instance.new("Part")
        part.Anchored = false
        part.Position = Vector3.new(0, 6, 0)
        part.Parent = workspace
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = seat
        weld.Part1 = part
        weld.Parent = seat
        if weld.Part0 ~= seat or weld.Part1 ~= part then
            seat:Destroy()
            part:Destroy()
            error("WeldConstraint setup failed")
        end
        seat:Destroy()
        part:Destroy()
    end)

    RunCheck(18, "userinputservice key detection", function()
        local UIS = game:GetService("UserInputService")
        if typeof(UIS.IsKeyDown) ~= "function" then
            error("UserInputService.IsKeyDown is not a function")
        end
    end)

    RunCheck(19, "tween events and their completion", function()
        local TweenService = game:GetService("TweenService")
        local part = Instance.new("Part")
        part.Parent = workspace
        local tween = TweenService:Create(part, TweenInfo.new(0.1), { Transparency = 0.5 })
        local finished = false
        tween.Completed:Connect(function() finished = true end)
        tween:Play()
        task.wait(0.15)
        if not finished then
            part:Destroy()
            error("Tween completion event did not fire")
        end
        part:Destroy()
    end)

    RunCheck(20, "player character existence", function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        if not player then
            error("LocalPlayer is nil")
        end
        if player.Character and not player.Character:IsA("Model") then
            error("Character is not a Model")
        end
    end)

    RunCheck(21, "body velocity movement", function()
        local part = Instance.new("Part")
        part.Anchored = false
        part.Position = Vector3.new(0, 5, 0)
        part.Parent = workspace
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 10, 0)
        bv.Parent = part
        task.wait(0.1)
        if part.Position.Y <= 5 then
            bv:Destroy()
            part:Destroy()
            error("BodyVelocity did not move the part")
        end
        bv:Destroy()
        part:Destroy()
    end)

    RunCheck(22, "cframe rotation", function()
        local cf = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(90), 0)
        local pos = (cf * Vector3.new(1, 0, 0))
        if math.abs(pos.X) > 0.01 then
            error("CFrame rotation calculation failed")
        end
    end)

    RunCheck(23, "touch event firing", function()
        local part1 = Instance.new("Part")
        part1.Anchored = false
        part1.Position = Vector3.new(0, 5, 0)
        part1.Parent = workspace
        local part2 = Instance.new("Part")
        part2.Anchored = false
        part2.Position = Vector3.new(0, 6, 0)
        part2.Parent = workspace
        local touched = false
        part1.Touched:Connect(function(hit)
            if hit == part2 then touched = true end
        end)
        part2.Position = Vector3.new(0, 5, 0)
        task.wait(0.1)
        part1:Destroy()
        part2:Destroy()
        if not touched then
            error("Touch event did not fire")
        end
    end)

    RunCheck(24, "string manipulation", function()
        local s = string.format("%s %d", "hello", 42)
        if s ~= "hello 42" then error("string.format failed") end
        if string.len("test") ~= 4 then error("string.len failed") end
        if string.upper("abc") ~= "ABC" then error("string.upper failed") end
    end)

    RunCheck(25, "table operations", function()
        local t = { 1, 2, 3 }
        table.insert(t, 4)
        if #t ~= 4 or t[4] ~= 4 then error("table.insert failed") end
        table.remove(t, 1)
        if #t ~= 3 or t[1] ~= 2 then error("table.remove failed") end
    end)

    RunCheck(26, "math library functions", function()
        if math.floor(3.9) ~= 3 then error("math.floor failed") end
        if math.ceil(3.1) ~= 4 then error("math.ceil failed") end
        if math.max(1, 5, 3) ~= 5 then error("math.max failed") end
        if math.min(1, 5, 3) ~= 1 then error("math.min failed") end
        if math.abs(-7) ~= 7 then error("math.abs failed") end
    end)

    RunCheck(27, "color3 creation", function()
        local c = Color3.new(1, 0, 0)
        if typeof(c) ~= "Color3" then error("Color3.new failed") end
        if c.R ~= 1 or c.G ~= 0 or c.B ~= 0 then error("Color3 values incorrect") end
        local c2 = Color3.fromRGB(255, 128, 0)
        if typeof(c2) ~= "Color3" then error("Color3.fromRGB failed") end
    end)

    RunCheck(28, "udim2 creation", function()
        local u = UDim2.new(0.5, 10, 0.5, 20)
        if typeof(u) ~= "UDim2" then error("UDim2.new failed") end
        if u.X.Scale ~= 0.5 or u.X.Offset ~= 10 then error("UDim2 X values incorrect") end
        if u.Y.Scale ~= 0.5 or u.Y.Offset ~= 20 then error("UDim2 Y values incorrect") end
    end)

    RunCheck(29, "instance attribute setting and getting", function()
        local part = Instance.new("Part")
        part:SetAttribute("TestAttr", 42)
        if part:GetAttribute("TestAttr") ~= 42 then
            part:Destroy()
            error("SetAttribute or GetAttribute failed")
        end
        part:Destroy()
    end)

    RunCheck(30, "bindable event firing", function()
        local event = Instance.new("BindableEvent")
        local received = false
        event.Event:Connect(function() received = true end)
        event:Fire()
        task.wait(0.05)
        if not received then
            event:Destroy()
            error("BindableEvent:Fire failed")
        end
        event:Destroy()
    end)

    RunCheck(31, "bindable function invoke", function()
        local bf = Instance.new("BindableFunction")
        bf.OnInvoke = function(val) return val * 2 end
        local result = bf:Invoke(5)
        if result ~= 10 then
            bf:Destroy()
            error("BindableFunction:Invoke failed")
        end
        bf:Destroy()
    end)

    RunCheck(32, "part property changes", function()
        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 3, 4)
        part.BrickColor = BrickColor.new("Bright red")
        part.Anchored = true
        if part.Size ~= Vector3.new(2, 3, 4) then
            part:Destroy()
            error("Part size property change failed")
        end
        if not part.Anchored then
            part:Destroy()
            error("Part anchored property change failed")
        end
        part:Destroy()
    end)

    RunCheck(33, "coroutine creation and resuming", function()
        local result = nil
        local co = coroutine.create(function()
            result = 99
        end)
        coroutine.resume(co)
        if result ~= 99 then error("Coroutine resume failed") end
    end)

    RunCheck(34, "pcall error catching", function()
        local ok, err = pcall(function()
            error("intentional error")
        end)
        if ok then error("pcall did not catch error") end
        if not err then error("pcall did not return error message") end
    end)

    RunCheck(35, "instance getchildren", function()
        local folder = Instance.new("Folder")
        local a = Instance.new("Part")
        a.Parent = folder
        local b = Instance.new("Part")
        b.Parent = folder
        local children = folder:GetChildren()
        if #children ~= 2 then
            folder:Destroy()
            error("GetChildren failed")
        end
        folder:Destroy()
    end)

    RunCheck(36, "instance getdescendants", function()
        local folder = Instance.new("Folder")
        local sub = Instance.new("Folder")
        sub.Parent = folder
        local part = Instance.new("Part")
        part.Parent = sub
        local desc = folder:GetDescendants()
        if #desc ~= 2 then
            folder:Destroy()
            error("GetDescendants failed")
        end
        folder:Destroy()
    end)

    RunCheck(37, "number to string and string to number", function()
        local n = 3.14
        local s = tostring(n)
        if typeof(s) ~= "string" then error("tostring failed") end
        local back = tonumber(s)
        if math.abs(back - n) > 0.001 then error("tonumber failed") end
    end)

    RunCheck(38, "cframe lookAt", function()
        local from = Vector3.new(0, 0, 0)
        local to = Vector3.new(0, 0, -10)
        local cf = CFrame.lookAt(from, to)
        if typeof(cf) ~= "CFrame" then error("CFrame.lookAt failed") end
        local lookVec = cf.LookVector
        if math.abs(lookVec.Z - (-1)) > 0.01 then error("CFrame.lookAt direction incorrect") end
    end)

    RunCheck(39, "gui object creation", function()
        local screenGui = Instance.new("ScreenGui")
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.5, 0, 0.5, 0)
        frame.Parent = screenGui
        if not frame or frame.Size ~= UDim2.new(0.5, 0, 0.5, 0) then
            screenGui:Destroy()
            error("GUI creation failed")
        end
        screenGui:Destroy()
    end)

    RunCheck(40, "sound instance creation", function()
        local sound = Instance.new("Sound")
        sound.Volume = 0.5
        if typeof(sound) ~= "Instance" then
            sound:Destroy()
            error("Sound creation failed")
        end
        if sound.Volume ~= 0.5 then
            sound:Destroy()
            error("Sound volume property failed")
        end
        sound:Destroy()
    end)

    RunCheck(41, "vector3 dot and cross product", function()
        local a = Vector3.new(1, 0, 0)
        local b = Vector3.new(0, 1, 0)
        local dot = a:Dot(b)
        if dot ~= 0 then error("Vector3:Dot failed") end
        local cross = a:Cross(b)
        if math.abs(cross.Z - 1) > 0.01 then error("Vector3:Cross failed") end
    end)

    RunCheck(42, "instance changed event", function()
        local part = Instance.new("Part")
        local changed = false
        part.Changed:Connect(function(prop)
            if prop == "Name" then changed = true end
        end)
        part.Name = "NewName"
        task.wait(0.05)
        if not changed then
            part:Destroy()
            error("Instance.Changed event failed")
        end
        part:Destroy()
    end)

    RunCheck(43, "random number generation", function()
        local rng = Random.new()
        local n = rng:NextNumber(0, 1)
        if n < 0 or n > 1 then error("Random:NextNumber failed") end
        local i = rng:NextInteger(1, 10)
        if i < 1 or i > 10 then error("Random:NextInteger failed") end
    end)

    RunCheck(44, "string find and match", function()
        local s = "hello world"
        local start, finish = string.find(s, "world")
        if start ~= 7 or finish ~= 11 then error("string.find failed") end
        local match = string.match(s, "%a+")
        if match ~= "hello" then error("string.match failed") end
    end)

    RunCheck(45, "cframe inverse", function()
        local cf = CFrame.new(5, 10, 15)
        local inv = cf:Inverse()
        local result = cf * inv
        if math.abs(result.X) > 0.01 or math.abs(result.Y) > 0.01 or math.abs(result.Z) > 0.01 then
            error("CFrame:Inverse failed")
        end
    end)

    RunCheck(46, "part anchored physics", function()
        local part = Instance.new("Part")
        part.Anchored = true
        part.Position = Vector3.new(0, 50, 0)
        part.Parent = workspace
        task.wait(0.2)
        if math.abs(part.Position.Y - 50) > 0.1 then
            part:Destroy()
            error("Anchored part moved")
        end
        part:Destroy()
    end)

    RunCheck(47, "folder and value instances", function()
        local folder = Instance.new("Folder")
        local intVal = Instance.new("IntValue")
        intVal.Value = 99
        intVal.Parent = folder
        local strVal = Instance.new("StringValue")
        strVal.Value = "test"
        strVal.Parent = folder
        if intVal.Value ~= 99 or strVal.Value ~= "test" then
            folder:Destroy()
            error("Value instance properties failed")
        end
        folder:Destroy()
    end)

    RunCheck(48, "ipairs and pairs iteration", function()
        local arr = { 10, 20, 30 }
        local sum = 0
        for _, v in ipairs(arr) do
            sum = sum + v
        end
        if sum ~= 60 then error("ipairs iteration failed") end
        local dict = { a = 1, b = 2, c = 3 }
        local count = 0
        for _ in pairs(dict) do
            count = count + 1
        end
        if count ~= 3 then error("pairs iteration failed") end
    end)

    RunCheck(49, "task delay execution", function()
        local ran = false
        task.delay(0.05, function()
            ran = true
        end)
        task.wait(0.15)
        if not ran then error("task.delay failed") end
    end)

    RunCheck(50, "instance findfirstchildofclass", function()
        local model = Instance.new("Model")
        local part = Instance.new("Part")
        part.Parent = model
        local humanoid = Instance.new("Humanoid")
        humanoid.Parent = model
        if model:FindFirstChildOfClass("Humanoid") ~= humanoid then
            model:Destroy()
            error("FindFirstChildOfClass failed for Humanoid")
        end
        if model:FindFirstChildOfClass("Part") ~= part then
            model:Destroy()
            error("FindFirstChildOfClass failed for Part")
        end
        model:Destroy()
    end)

    SanityCheckFinish = true
end)

repeat task.wait(0.1) until SanityCheckFinish == true

local TotalTests = (Results.Passed + Results.Failed)
local Percentage = 0
if TotalTests > 0 then
    Percentage = math.floor((Results.Passed / TotalTests) * 100)
end

local failedCount = 0
for _, line in ipairs(Results.Tests) do
    if string.find(line, "FAIL") then
        print(line)
        failedCount = failedCount + 1
    end
end

if Results.Failed > 5 then
    print("[VEXALSCRIPTS] sanity check failed with a total result of! (" .. Results.Passed .. "/" .. TotalTests .. ") (" .. Percentage .. "%)")
    error("[VEXALSCRIPTS] failed too many tests (5), this script shall not run!")
    return
end

print("[VEXALSCRIPTS] sanity check succeeded with a total result of! (" .. Results.Passed .. "/" .. TotalTests .. ") (" .. Percentage .. "%)")

local success232, result232 = pcall(function()
    return require(game:GetService("ReplicatedStorage"):WaitForChild("Collection"):WaitForChild("ItemDatabase"))
end)

if (not (success232 and result232)) or not fireproximityprompt then
    game:GetService("Players").LocalPlayer:Kick("Unsupported executor, please try using Delta or a real executor")
    return
end

local success56, placeEnum = pcall(function()
    return require(game:GetService("ReplicatedStorage").Places.PlaceEnum)
end)

local success2, placeService = pcall(function()
    return require(game:GetService("ReplicatedStorage").Places.PlaceService)
end)

if not success56 or not success2 then
    game:GetService("Players").LocalPlayer:Kick("Failed to load place modules")
    return
end

if not placeService.IsThisPlace(placeEnum.Trading) then
    game:GetService("Players").LocalPlayer:Kick("Invalid place, please be in the trading hub!")
    return
end

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemDatabase = require(ReplicatedStorage.Collection.ItemDatabase)
local PlayerCollection = require(ReplicatedStorage.Collection.PlayerCollectionService)
local myItems = PlayerCollection.GetCollection() or {}
local rawData = game:HttpGet("https://raw.githubusercontent.com/SanityScripts/tr/refs/heads/main/value-list.json")
local valueData = HttpService:JSONDecode(rawData)

local function scanInventory()
    local colorKeywords = { "Purple", "Blue", "Yellow", "Gold", "Red", "Green", "Pink", "Orange", "Black", "White", "Cyan", "Magenta" }
    local idMap = {
        ["SG"] = "Sniper",
        ["G"] = "Gun",
        ["K"] = "Knife",
        ["LC"] = "Case",
        ["CD"] = "Banner",
        ["C"] = "Case"
    }

    local function getCleanName(color, name, idName)
        local raw = color .. " " .. name .. " " .. idName
        local words = {}
        local result = {}
        for word in raw:gmatch("%S+") do
            local upper = string.upper(word)
            if not words[upper] then
                table.insert(result, word)
                words[upper] = true
            end
        end
        return table.concat(result, " ")
    end

    local function fetchValue(color, name, idName)
        if not valueData then
            return "Not Found", getCleanName(color, name, idName)
        end
        local typeFallback = (idName == "Gun" and "Revolver") or (idName == "Knife" and "Axe") or ""
        local checks = {
            { color, name, idName },
            { name, idName, color },
            { color, name, typeFallback },
            { name, typeFallback, color }
        }
        for _, set in ipairs(checks) do
            local query = getCleanName(set[1], set[2], set[3])
            if query ~= "" then
                local upperQuery = string.upper(query)
                for _, data in ipairs(valueData) do
                    local apiName = string.upper(data.pets or "")
                    local match = true
                    for word in upperQuery:gmatch("%S+") do
                        if not apiName:find(word, 1, true) then
                            match = false
                            break
                        end
                    end
                    if match then
                        return data.value or "N/A", query
                    end
                end
            end
        end
        return "Not Found", getCleanName(color, name, idName)
    end

    local results = {}
    local calculatedInventory = {}

    for i = 1, #myItems do
        local item = myItems[i]
        local info = ItemDatabase.getEntry(item.Id)
        if info then
            local baseName = info.DisplayName or ""
            local uiName = info.DisplayNameOverride or info.DisplayName or ""
            local foundColor = ""
            for _, color in ipairs(colorKeywords) do
                if string.find(string.lower(baseName), string.lower(color), 1, true) then
                    foundColor = color
                    break
                end
            end
            local prefix = string.match(tostring(item.Id), "^%a+")
            local idName = idMap[prefix] or ""
            local itemValue, finalName = fetchValue(foundColor, uiName, idName)

            local last = results[#results]
            if last and last.name == finalName and last.value == itemValue then
                last.stop = i
            else
                table.insert(results, { start = i, stop = i, name = finalName, value = itemValue })
            end

            table.insert(calculatedInventory, { Index = i, Name = finalName, Value = itemValue })
        end
    end

    return results, calculatedInventory
end

local grouped, fullList = scanInventory()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Murder vs Sheriff Duels - Trade Helper",
    Icon = "rbxassetid://139687752061139",
    Author = "by Vexal Scripts",
    Folder = "MVSDTRADEHELPERVEXALSCRIPTS",
    Size = UDim2.fromOffset(650, 430),
    MinSize = Vector2.new(450, 250),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Sky",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() end,
    },
})

Window:EditOpenButton({
    Title = "Vexal",
    Icon = "rbxassetid://139687752061139",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("0A1128"),
        Color3.fromHex("4B0082")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

Window:Tag({
    Title = "NEW UPDATE",
    Icon = "shield-check",
    Color = Color3.fromHex("#30aaff"),
    Radius = 5,
})

local Welcome = Window:Tab({
    Title = "Welcome",
    Icon = "shield-user",
    Locked = false,
})

Welcome:Paragraph({
    Title = "Welcome to Vexal Scripts!!",
    Desc = "We hope you find this script useful, if you find any issues please report them below to my discord by making a ticket, thank you for using us!",
    Color = "Blue",
    Image = "rbxassetid://139687752061139",
    ImageSize = 60,
    Locked = false,
    Buttons = {
        {
            Icon = "link",
            Title = "Copy our Discord Link",
            Callback = function()
                setclipboard("https://dsc.gg/vexalscripts")
            end,
        }
    }
})

local ControlsTab = Window:Tab({
    Title = "My Inventory Controls",
    Icon = "settings",
})

local DatabaseTab = Window:Tab({
    Title = "123 Demands",
    Icon = "circle-check-big",
})

local ResultsTab = Window:Tab({
    Title = "Results",
    Icon = "list",
})

local LogParagraph = ResultsTab:Paragraph({
    Title = "Inventory Log",
    Desc = "Waiting for you to click some buttons!",
    Color = "Blue",
})

WindUI:Notify({
    Title = "Welcome to Vexal Scripts MVSD",
    Duration = 15,
    Icon = "rbxassetid://139687752061139",
})

local searchQuery = ""
local dbSearchQuery = ""

local function updateUI(groupedResults)
    local fullText = ""
    local totalGroups = #groupedResults
    for _, entry in ipairs(groupedResults) do
        local range = (entry.start == entry.stop) and tostring(entry.start) or (entry.start .. "-" .. entry.stop)
        fullText = fullText .. string.format("[%s] %s | Value: %s\n", range, entry.name, entry.value)
    end
    LogParagraph:SetTitle("Success")
    LogParagraph:SetDesc(fullText)
end

ControlsTab:Input({
    Title = "Search Inventory",
    Desc = "Search an item from your inventory",
    Value = "",
    Type = "Input",
    Placeholder = "e.g. Reef",
    Locked = false,
    Callback = function(input)
        searchQuery = input
    end
})

ControlsTab:Button({
    Title = "Find Item",
    Desc = "Search an items value from your inventory",
    Locked = false,
    Callback = function()
        if searchQuery == "" then return end
        local results = ""
        local count = 0
        local upperQuery = string.upper(searchQuery)
        for _, item in ipairs(fullList) do
            if string.find(string.upper(item.Name), upperQuery, 1, true) then
                results = results .. string.format("[%d] %s | Value: %s\n", item.Index, item.Name, item.Value)
                count = count + 1
            end
        end
        LogParagraph:SetTitle("Search: " .. searchQuery .. " (" .. count .. " Found)")
        LogParagraph:SetDesc(results ~= "" and results or "No matches found.")
        ResultsTab:Select()
    end
})

ControlsTab:Button({
    Title = "Load Calculated Inventory",
    Desc = "Show all values of your inventory",
    Locked = false,
    Callback = function()
        local totalValue = 0
        local results = ""
        for _, v in ipairs(fullList) do
            local numValue = tonumber(v.Value) or 0
            totalValue = totalValue + numValue
            results = results .. string.format("[%d] %s | %s\n", v.Index, v.Name, v.Value)
        end
        local formattedTotal
        if totalValue >= 1000000 then
            formattedTotal = string.format("%.2fM", totalValue / 1000000)
        elseif totalValue >= 1000 then
            formattedTotal = string.format("%.2fK", totalValue / 1000)
        else
            formattedTotal = tostring(totalValue)
        end
        results = "Total Inventory Value: " .. formattedTotal .. "\n\n" .. results
        LogParagraph:SetTitle("Calculated Inventory (" .. #fullList .. " Items)")
        LogParagraph:SetDesc(results)
        ResultsTab:Select()
    end
})

ControlsTab:Button({
    Title = "Load Grouped View",
    Desc = "Show condensed values of your inventory",
    Locked = false,
    Callback = function()
        updateUI(grouped)
        ResultsTab:Select()
    end
})

DatabaseTab:Input({
    Title = "Detailed Searching",
    Desc = "Search any item using 123demands!",
    Value = "",
    Type = "Input",
    Placeholder = "e.g. Shimmer",
    Locked = false,
    Callback = function(input)
        dbSearchQuery = input
    end
})

DatabaseTab:Button({
    Title = "Search 123Demands",
    Desc = "Search global values, demand, and rarity",
    Locked = false,
    Callback = function()
        if dbSearchQuery == "" then return end
        local results = ""
        local count = 0
        local upperQuery = string.upper(dbSearchQuery)
        if valueData then
            for _, data in ipairs(valueData) do
                local itemName = data.pets or "Unknown"
                if string.find(string.upper(itemName), upperQuery, 1, true) then
                    local val = data.value or "N/A"
                    local dem = data.demand or "N/A"
                    local rar = data.rarity or "N/A"
                    results = results .. string.format("%s\nValue: %s | Demand: %s\nRarity: %s\n\n", itemName, val, dem, rar)
                    count = count + 1
                end
                if count >= 20 then
                    results = results .. "...and more. Try a specific search!"
                    break
                end
            end
        end
        LogParagraph:SetTitle("Database Results: " .. dbSearchQuery)
        LogParagraph:SetDesc(count > 0 and results or "No items found from 123demands")
        ResultsTab:Select()
    end
})

Welcome:Select()
