-- Anti / Defense Hub - Integrated from multiple sources
-- Features: Anti Grab, Anti Void, Anti Ragdoll, Anti Explode, etc.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- OrionLib (多くのスクリプトで使用されていたUIライブラリ)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jadpy/suki/refs/heads/main/orion"))()
local Window = OrionLib:MakeWindow({
    Name = "Anti / Defense Hub",
    HidePremium = true,
    SaveConfig = false,
    IntroEnabled = false
})

-- 設定テーブル
local Config = {
    AntiGrab = false,
    AntiVoid = false,
    AntiRagdoll = false,
    AntiExplode = false,
    AntiGucci = false,      -- 一部のスクリプトにあった謎の機能（残しておく）
    AntiGrabTP = false,
    StruggleSpam = false
}

-- タイマー
local DefenseTimer = 0

-- ヘルパー関数
local function GetRoot(part)
    return part and part.Parent and part.Parent:FindFirstChild("HumanoidRootPart")
end

local function SetNetworkOwner(part, cframe)
    pcall(function()
        ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(part, cframe or HumanoidRootPart.CFrame)
    end)
end

local function Struggle()
    pcall(function()
        ReplicatedStorage.CharacterEvents.Struggle:FireServer(LocalPlayer)
        ReplicatedStorage.GameCorrectionEvents.StopAllVelocity:FireServer()
    end)
end

-- Anti Grab ロジック
local function AntiGrabLoop()
    if not Config.AntiGrab then return end
    Struggle()
end

-- Anti Void ロジック
local function AntiVoidCheck()
    if not Config.AntiVoid then return end
    if HumanoidRootPart.Position.Y < -80 then
        HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
    end
end

-- Anti Ragdoll ロジック
local function AntiRagdollCheck()
    if not Config.AntiRagdoll then return end
    if Humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

-- Anti Explode / その他防御（簡易実装）
local AntiExplodeConnection
local function SetupAntiExplode()
    if Config.AntiExplode then
        if AntiExplodeConnection then return end
        AntiExplodeConnection = Workspace.ChildAdded:Connect(function(child)
            if child.Name:find("Explosion") or child.Name:find("Bomb") then
                pcall(function() child:Destroy() end)
            end
        end)
    else
        if AntiExplodeConnection then
            AntiExplodeConnection:Disconnect()
            AntiExplodeConnection = nil
        end
    end
end

-- メインループ
RunService.Heartbeat:Connect(function(dt)
    DefenseTimer = DefenseTimer + dt

    if DefenseTimer >= 0.1 then
        if Config.AntiGrab or Config.StruggleSpam then
            AntiGrabLoop()
        end

        AntiVoidCheck()
        AntiRagdollCheck()

        DefenseTimer = 0
    end
end)

-- UI 作成
local AntiTab = Window:MakeTab({
    Name = "Anti / Defense",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

AntiTab:AddSection({Name = "Anti Features"})

AntiTab:AddToggle({
    Name = "Anti Grab",
    Default = false,
    Callback = function(v)
        Config.AntiGrab = v
    end
})

AntiTab:AddToggle({
    Name = "Anti Void",
    Default = false,
    Callback = function(v)
        Config.AntiVoid = v
    end
})

AntiTab:AddToggle({
    Name = "Anti Ragdoll",
    Default = false,
    Callback = function(v)
        Config.AntiRagdoll = v
    end
})

AntiTab:AddToggle({
    Name = "Anti Explode",
    Default = false,
    Callback = function(v)
        Config.AntiExplode = v
        SetupAntiExplode()
    end
})

AntiTab:AddToggle({
    Name = "Anti Grab TP (Experimental)",
    Default = false,
    Callback = function(v)
        Config.AntiGrabTP = v
        -- 必要ならここにTPロジック追加
    end
})

AntiTab:AddToggle({
    Name = "Struggle Spam (Anti Grab強化)",
    Default = false,
    Callback = function(v)
        Config.StruggleSpam = v
    end
})

AntiTab:AddSection({Name = "Utility"})

AntiTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        end
    end
})

AntiTab:AddButton({
    Name = "Teleport to Safe Zone",
    Callback = function()
        HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
})

-- 初期化通知
OrionLib:MakeNotification({
    Name = "Anti Hub Loaded",
    Content = "Anti / Defense features are ready.",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- キャラクター再読み込み対応
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

OrionLib:Init()
