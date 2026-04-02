local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- --- 1. 実行時にチャットへ入力 ---
local function SendHubChat()
    local msg = ""
    local TextChatService = game:GetService("TextChatService")
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then channel:SendAsync(msg) end
    else
        local chatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent then chatEvent.SayMessageRequest:FireServer(msg, "All") end
    end
end
pcall(SendHubChat)

local Window = Rayfield:CreateWindow({
   Name = "HamHubFTAP | HamHub v2 🐹",
   LoadingTitle = "HamHub kill aura v2 起動中...",
   LoadingSubtitle = "by User",
   ConfigurationSaving = { Enabled = false }
})

-- --- 2. 内部変数 ---
local KillAuraEnabled = false
local KickAuraEnabled = false
local KillAllEnabled = false
local KickAllEnabled = false
local AntiGrabEnabled = false
local NEARBY_RANGE = 35
local blobalter = 1 -- Kick Aura用の左右切り替え変数
local selectedTargetName = ""
local playerThreads = {} -- Kill Aura用のスレッド管理

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- --- 3. ブロブマン取得共通関数 ---
local function getMyBlobman()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "CreatureBlobman" and v:FindFirstChild("VehicleSeat") then
            local seat = v.VehicleSeat
            local seatWeld = seat:FindFirstChild("SeatWeld")
            if seatWeld and seatWeld.Part1 and seatWeld.Part1:IsDescendantOf(LP.Character) then
                return v
            end
        end
    end
    return nil
end

-- --- 4. 攻撃ロジック ---

-- 【Kill Aura用】提供ファイルの最強即死ロジック (Heartbeat連打)
local function stopKillThreads(userId)
    if playerThreads[userId] then
        playerThreads[userId].active = false
        playerThreads[userId] = nil
    end
end

local function startKillThreads(player)
    local userId = player.UserId
    stopKillThreads(userId)
    local state = { active = true }
    playerThreads[userId] = state

    task.spawn(function()
        local conn
        conn = RS.Heartbeat:Connect(function()
            if not state.active then conn:Disconnect() return end
            local blob = getMyBlobman()
            if not blob then return end
            local char = player.Character
            local pHRP = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not pHRP or not hum then return end

            pcall(function()
                local s1 = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                local grabEvent = (s1 and s1:FindFirstChild("CreatureGrab")) or blob:FindFirstChild("CreatureGrab", true)
                local releaseEvent = (s1 and s1:FindFirstChild("CreatureRelease")) or blob:FindFirstChild("CreatureRelease", true)
                
                local rDet = blob:FindFirstChild("RightDetector")
                local lDet = blob:FindFirstChild("LeftDetector")
                
                for _, det in ipairs({rDet, lDet}) do
                    if det and grabEvent then
                        local weld = det:FindFirstChildWhichIsA("Weld") or det:FindFirstChild(det.Name:gsub("Detector", "Weld"))
                        grabEvent:FireServer(det, pHRP, weld)
                        hum.Health = 0
                        hum:ChangeState(Enum.HumanoidStateType.Dead)
                        if releaseEvent and weld then releaseEvent:FireServer(weld) end
                    end
                end
            end)
        end)
    end)
end

-- 【Kick系ロジック】左右切り替え掴み (BlingやKick Auraで使用)
local function grabTargetKick(targetPlayer)
    local blobman = getMyBlobman()
    if not blobman or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    local grabPartName = (blobalter == 1) and "LeftDetector" or "RightDetector"
    local weldPartName = (blobalter == 1) and "LeftWeld" or "RightWeld"
    local grabPart = blobman:FindFirstChild(grabPartName)
    local weldPart = grabPart and (grabPart:FindFirstChild(weldPartName) or grabPart:FindFirstChildWhichIsA("Weld"))
    
    blobalter = (blobalter == 1) and 2 or 1

    local scriptObj = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
    local grabEvent = scriptObj and scriptObj:FindFirstChild("CreatureGrab") or blobman:FindFirstChild("CreatureGrab", true)
    
    if grabEvent then
        grabEvent:FireServer(grabPart, targetHRP, weldPart)
    end
end

-- --- 😈 Kick Menu ---
local KickTab = Window:CreateTab("😈 Kick Menu", 4483362458)

local function getPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(list, p.DisplayName .. " (@" .. p.Name .. ")") end
    end
    return list
end

local PlayerDropdown = KickTab:CreateDropdown({
   Name = "Target Player (Bling用)",
   Options = getPlayerList(),
   Callback = function(Option) if Option[1] then selectedTargetName = Option[1]:match("@([%w_]+)") end end,
})

KickTab:CreateButton({
   Name = "Refresh List",
   Callback = function() PlayerDropdown:Refresh(getPlayerList(), true) end,
})

-- Bling (拉致機能) の復活
KickTab:CreateButton({
   Name = "Bling (TP & Grab Loop & Return)",
   Callback = function()
      local target = Players:FindFirstChild(selectedTargetName or "")
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
          local myHRP = LP.Character.HumanoidRootPart
          local originalCF = myHRP.CFrame
          
          -- TP
          myHRP.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
          
          -- 1秒間掴み連打
          local grabbing = true
          task.spawn(function()
              local startTime = tick()
              while grabbing and (tick() - startTime) < 1.1 do
                  grabTargetKick(target)
                  task.wait(0.1)
              end
          end)
          
          task.wait(1)
          grabbing = false
          
          -- 元の場所へ戻る
          myHRP.CFrame = originalCF
          Rayfield:Notify({Title = "Bling", Content = "拉致完了", Duration = 2})
      else
          Rayfield:Notify({Title = "Error", Content = "ターゲットを選択してください", Duration = 3})
      end
   end,
})

KickTab:CreateSection("--- All Teleport Loop ---")

local function runTeleportLoop(mode)
    task.spawn(function()
        while (mode == "Kill" and KillAllEnabled) or (mode == "Kick" and KickAllEnabled) do
            for _, p in ipairs(Players:GetPlayers()) do
                if p == LP or not p.Character then continue end
                if (mode == "Kill" and not KillAllEnabled) or (mode == "Kick" and not KickAllEnabled) then break end
                local myHRP = LP.Character:FindFirstChild("HumanoidRootPart")
                local pHRP = p.Character:FindFirstChild("HumanoidRootPart")
                if myHRP and pHRP then
                    myHRP.CFrame = pHRP.CFrame * CFrame.new(0, 0, -3)
                    if mode == "Kill" then startKillThreads(p) task.wait(0.3) stopKillThreads(p.UserId)
                    else grabTargetKick(p) task.wait(0.3) end
                end
            end
            task.wait(0.1)
        end
    end)
end

KickTab:CreateToggle({ Name = "Kick All (全員巡回投げ)", Callback = function(v) KickAllEnabled = v; if v then runTeleportLoop("Kick") end end })
KickTab:CreateToggle({ Name = "Kill All (全員巡回即死)", Callback = function(v) KillAllEnabled = v; if v then runTeleportLoop("Kill") end end })

-- --- 💀 Aura ---
local AuraTab = Window:CreateTab("💀 Aura", 4483362458)

AuraTab:CreateToggle({
    Name = "💀 Kill Aura (最強即死判定)",
    Callback = function(v) 
        KillAuraEnabled = v 
        if not v then for id in pairs(playerThreads) do stopKillThreads(id) end end
    end
})

AuraTab:CreateToggle({
    Name = "🔥 Kick Aura (左右切り替え掴み)",
    Callback = function(v) KickAuraEnabled = v end
})

AuraTab:CreateSlider({
   Name = "検知範囲", Range = {10, 100}, Increment = 5, CurrentValue = 35,
   Callback = function(v) NEARBY_RANGE = v end
})

task.spawn(function()
    while true do
        if KillAuraEnabled or KickAuraEnabled then
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, player in pairs(Players:GetPlayers()) do
                    if player == LP or not player.Character then continue end
                    local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP and (targetHRP.Position - hrp.Position).Magnitude <= NEARBY_RANGE then
                        if KillAuraEnabled then
                            if not playerThreads[player.UserId] then startKillThreads(player) end
                        elseif KickAuraEnabled then
                            grabTargetKick(player)
                        end
                    else
                        if KillAuraEnabled then stopKillThreads(player.UserId) end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- --- 🛡️ Anti & Players ---
local AntiTab = Window:CreateTab("🛡️ Anti", 4483362458)
AntiTab:CreateToggle({
    Name = "🔒 Anti-Grab",
    Callback = function(v)
        AntiGrabEnabled = v
        task.spawn(function()
            local struggleEvent = ReplicatedStorage:FindFirstChild("Struggle", true)
            while AntiGrabEnabled do
                local IsHeld = LP:FindFirstChild("IsHeld")
                if LP.Character and IsHeld and IsHeld.Value then
                    if struggleEvent then pcall(function() struggleEvent:FireServer(LP) end) end
                    for _, part in ipairs(LP.Character:GetChildren()) do if part:IsA("BasePart") then part.Anchored = true end end
                elseif LP.Character then
                    for _, part in ipairs(LP.Character:GetChildren()) do if part:IsA("BasePart") then part.Anchored = false end end
                end
                task.wait(0.2)
            end
        end)
    end
})

local PlayerTab = Window:CreateTab("👤 Players", 4483362458)
PlayerTab:CreateButton({
    Name = "🎥 三人称 (5000)",
    Callback = function()
        LP.CameraMaxZoomDistance = 5000
        LP.CameraMode = Enum.CameraMode.Classic
    end
})

Rayfield:LoadConfiguration()
