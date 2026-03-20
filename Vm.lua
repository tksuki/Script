local orionXHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/BlizTBr/scripts/main/Orion%20X"))()

local userInterface = orionXHub
local flingThingsWindow = orionXHub.MakeWindow(userInterface, {
    Name = "Fお珍珍MOD - ターゲット選択",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "FTAPConfig_Pn",
    IntroEnabled = false,
    KeyToOpenWindow = "M",
    FreeMouse = true
})

-- サービスと変数の準備
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer
local toysFolder = Workspace:WaitForChild(plr.Name .. "SpawnedInToys")

local SpawnToyRemoteFunction = ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
local DestroyToy = ReplicatedStorage.MenuToys.DestroyToy
local SetNetworkOwner = ReplicatedStorage.GrabEvents.SetNetworkOwner
local StickyPartEvent = ReplicatedStorage.PlayerEvents.StickyPartEvent

local AutoPencil = false
local AutoKunai = false
local TargetPlayerName = plr.Name
local OriginalLocation = nil

-- プレイヤーリスト取得関数
local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(names, p.Name)
    end
    return names
end

-- Toyスポーン用内部関数
local function spawnToy(toyName)
    local found = nil
    local conn
    conn = toysFolder.ChildAdded:Connect(function(c)
        if c.Name == toyName then
            found = c
            conn:Disconnect()
        end
    end)
    
    local char = plr.Character
    local spawnPos = (char and char:FindFirstChild("Head")) and char.Head.CFrame or CFrame.new(0, 10, 0)
    SpawnToyRemoteFunction:InvokeServer(toyName, spawnPos, Vector3.new())
    
    local t = 0
    while not found and t < 5 do
        task.wait(0.1)
        t += 0.1
    end
    if conn and conn.Connected then conn:Disconnect() end
    
    if not found then
        for _,c in ipairs(toysFolder:GetChildren()) do
            if c.Name == toyName then found = c break end
        end
    end
    
    if found then
        local soundPart = found:FindFirstChild("SoundPart") or found:FindFirstChildWhichIsA("BasePart")
        if soundPart then SetNetworkOwner:FireServer(soundPart, soundPart.CFrame) end
    end
    return found
end

-- =====================================================
-- タブ構成
-- =====================================================

local mainTab = flingThingsWindow:MakeTab({
    Name = "メイン操作",
    Icon = "rbxassetid://7733917120",
    PremiumOnly = false
})

local targetSection = mainTab:AddSection({
    Name = "ターゲット設定"
})

local PlayerDropdown = targetSection:AddDropdown({
    Name = "対象プレイヤーを選択",
    Default = plr.Name,
    Options = getPlayerNames(),
    Callback = function(Value)
        TargetPlayerName = Value
    end    
})

targetSection:AddButton({
    Name = "プレイヤーリストを更新",
    Callback = function()
        PlayerDropdown:Refresh(getPlayerNames(), true)
    end
})

local execSection = mainTab:AddSection({
    Name = "お珍珍起動"
})

local PencilToggle
local KunaiToggle

PencilToggle = execSection:AddToggle({
    Name = "ぼっき（ペンシル）",
    Default = false,
    Callback = function(v)
        if v then
            local myChar = plr.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                OriginalLocation = myChar.HumanoidRootPart.CFrame
            end
        end
        AutoPencil = v
    end
})

KunaiToggle = execSection:AddToggle({
    Name = "ふつう（クナイ）",
    Default = false,
    Callback = function(v)
        if v then
            local myChar = plr.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                OriginalLocation = myChar.HumanoidRootPart.CFrame
            end
        end
        AutoKunai = v
    end
})

-- =====================================================
-- メインループ
-- =====================================================

-- Pencilループ
task.spawn(function()
    while true do
        task.wait(0.1) -- 追従速度を上げるため少し短縮
        if not AutoPencil then continue end
        
        local targetPlr = Players:FindFirstChild(TargetPlayerName)
        local targetChar = targetPlr and targetPlr.Character
        local myChar = plr.Character
        if not targetChar or not myChar then continue end

        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")

        -- ループテレポート（刺さるまで毎フレーム位置を同期）
        if targetHRP and myHRP then
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2.5)
        end

        local pencil = toysFolder:FindFirstChild("ToolPencil")
        if not pencil then pencil = spawnToy("ToolPencil") end
        if not pencil then continue end

        local sticky = pencil:FindFirstChild("StickyPart")
        local targetPart = targetChar:FindFirstChild("Left Leg") or targetChar:FindFirstChild("LeftLowerLeg")
        
        if sticky and targetPart then
            StickyPartEvent:FireServer(
                sticky,
                targetPart,
                CFrame.new(0.2955, 0.8629, -0.7931, -0.9934, 0.1055, -0.0445, 0.1032, 0.9933, 0.0513, 0.0496, 0.0463, -0.9976)
            )
            
            -- 刺さった後の処理
            AutoPencil = false
            task.wait(0.05) -- 確実な帰還のための微小待機
            if OriginalLocation and myHRP then
                myHRP.CFrame = OriginalLocation
            end
            PencilToggle:Set(false)
        end
    end
end)

-- Kunaiループ
task.spawn(function()
    while true do
        task.wait(0.1)
        if not AutoKunai then continue end

        local targetPlr = Players:FindFirstChild(TargetPlayerName)
        local targetChar = targetPlr and targetPlr.Character
        local myChar = plr.Character
        if not targetChar or not myChar then continue end

        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")

        -- ループテレポート
        if targetHRP and myHRP then
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2.5)
        end

        local kunai = toysFolder:FindFirstChild("NinjaKunai")
        if not kunai then kunai = spawnToy("NinjaKunai") end
        if not kunai then continue end

        local sticky = kunai:FindFirstChild("StickyPart")
        local targetPart = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
        
        if sticky and targetPart then
            StickyPartEvent:FireServer(
                sticky,
                targetPart,
                CFrame.new(0.0309, -0.6654, -1.2322, -0.0905, -0.0288, 0.9954, 0.0086, 0.9995, 0.0297, -0.9958, 0.0113, -0.0902)
            )
            
            -- 刺さった後の処理
            AutoKunai = false
            task.wait(0.05)
            if OriginalLocation and myHRP then
                myHRP.CFrame = OriginalLocation
            end
            KunaiToggle:Set(false)
        end
    end
end)

orionXHub:Init()
