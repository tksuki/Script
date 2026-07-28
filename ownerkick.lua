local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 高速待機用変数
local fastWait = 0.00001

local Window = Rayfield:CreateWindow({
    Name = "Player Grab System",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Script",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("Grab", 4483362458)

local selectedPlayerText = ""

-- モード管理変数
local isGrabbingMode1 = false -- Detector CFrame送信
local isGrabbingMode2 = false -- キャラ(Torso) CFrame送信

local grabLoop = nil

-- 現在掴んでいる対象のパーツを保持する変数
local activeHRP = nil
local activeDetector = nil

local function getPlayers()
    local players = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(players, plr.DisplayName .. " (" .. plr.Name .. ")")
        end
    end
    return players
end

local function getUsernameFromOption(option)
    if type(option) == "table" then
        option = option[1]
    end
    if not option or type(option) ~= "string" then return nil end
    
    local name = option:match("%((.-)%)")
    return name or option
end

-- 対象プレイヤーの3スタッド以内にある Detector を探す関数
local function findClosestDetector(targetHRP)
    if not targetHRP then return nil end
    local closest = nil
    local minDistance = 5

    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "PlayerCharacterLocationDetector" then
            local part = v:IsA("BasePart") and v or (v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")))
            if part then
                local dist = (part.Position - targetHRP.Position).Magnitude
                if dist <= minDistance then
                    minDistance = dist
                    closest = part
                end
            end
        end
    end
    return closest
end

-- アンカー設定関数
local function setAnchored(part, status)
    if part and part:IsA("BasePart") then
        pcall(function()
            part.Anchored = status
        end)
    end
end

-- 速度リセット関数
local function stopVelocity(part)
    if part and part:IsA("BasePart") then
        pcall(function()
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

-- トグルオフ時や停止時にアンカーを解除する処理
local function stopGrab()
    isGrabbingMode1 = false
    isGrabbingMode2 = false
    
    if grabLoop then
        task.cancel(grabLoop)
        grabLoop = nil
    end
    
    if activeHRP then
        setAnchored(activeHRP, false)
        activeHRP = nil
    end
    if activeDetector then
        setAnchored(activeDetector, false)
        activeDetector = nil
    end
end

-- 共通のループ開始処理
local function startGrab(sendCharCFrame)
    stopGrab()
    
    if sendCharCFrame then
        isGrabbingMode2 = true
    else
        isGrabbingMode1 = true
    end
    
    grabLoop = task.spawn(function()
        local isHoldingTarget = false
        local lastTargetUser = nil
        local lockedDetector = nil
        
        while isGrabbingMode1 or isGrabbingMode2 do
            local username = getUsernameFromOption(selectedPlayerText)
            
            if username ~= lastTargetUser then
                if activeHRP then setAnchored(activeHRP, false) end
                if activeDetector then setAnchored(activeDetector, false) end
                activeHRP = nil
                activeDetector = nil
                
                isHoldingTarget = false
                lockedDetector = nil
                lastTargetUser = username
            end
            
            if not username or username == "" then
                isHoldingTarget = false
                lockedDetector = nil
                task.wait(0.1)
                continue
            end
            
            local targetPlayer = Players:FindFirstChild(username)
            if not targetPlayer then
                isHoldingTarget = false
                lockedDetector = nil
                task.wait(0.1)
                continue
            end
            
            local character = targetPlayer.Character
            if not character then
                isHoldingTarget = false
                lockedDetector = nil
                repeat
                    task.wait(0.05)
                    if not (isGrabbingMode1 or isGrabbingMode2) then return end
                    targetPlayer = Players:FindFirstChild(username)
                    if targetPlayer then
                        character = targetPlayer.Character
                    end
                until character
            end
            
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            -- R6 と R15 の両方に対応して Torso を動的取得
            local torso = character and (character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if not hrp or not torso or not humanoid or humanoid.Health <= 0 then
                if activeHRP then setAnchored(activeHRP, false) end
                if activeDetector then setAnchored(activeDetector, false) end
                activeHRP = nil
                activeDetector = nil
                isHoldingTarget = false
                lockedDetector = nil
                task.wait(0.1)
                continue
            end
            
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            
            if not myHRP then
                if activeHRP then setAnchored(activeHRP, false) end
                if activeDetector then setAnchored(activeDetector, false) end
                activeHRP = nil
                activeDetector = nil
                isHoldingTarget = false
                lockedDetector = nil
                task.wait(0.1)
                continue
            end

            activeHRP = hrp
            
            -- 自分自身のCFrameから真上20スタッドの位置を動的計算
            local targetCFrame = myHRP.CFrame * CFrame.new(0, 20, 0)
            
            --------------------------------------------------
            -- パターンA：初回（セットアップ）
            --------------------------------------------------
            if not isHoldingTarget then
                local originalCFrame = myHRP.CFrame
                
                -- 通信のため一時的にアンカー解除
                setAnchored(hrp, false)
                if lockedDetector then setAnchored(lockedDetector, false) end

                -- 対象の直下にTP
                myHRP.CFrame = hrp.CFrame * CFrame.new(0, -6, 0)
                
                if not lockedDetector then
                    lockedDetector = findClosestDetector(hrp)
                end
                
                activeDetector = lockedDetector
                
                if not lockedDetector then
                    pcall(function()
                        ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(torso)
                    end)
                end
                
                task.wait(0.2)
                
                -- ★ リモートイベント送信（本来の形：Torsoの実座標をそのまま渡す）
                pcall(function()
                    ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(table.unpack({
                        [1] = torso,
                        [2] = torso.CFrame
                    }))
                end)
                
                task.wait(fastWait)
                
                -- 元の位置に戻る
                myHRP.CFrame = originalCFrame
                
                -- 真上20スタッドへ移動させて固定
                if isGrabbingMode1 or isGrabbingMode2 then
                    pcall(function()
                        hrp.CFrame = targetCFrame
                        stopVelocity(hrp)
                        setAnchored(hrp, true)

                        if lockedDetector and lockedDetector.Parent then
                            lockedDetector.CFrame = targetCFrame
                            stopVelocity(lockedDetector)
                            setAnchored(lockedDetector, true)
                        end
                    end)
                end
                
                pcall(function()
                    ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(torso)
                end)
                
                isHoldingTarget = true
                task.wait(fastWait)
                
            --------------------------------------------------
            -- パターンB：継続ループ
            --------------------------------------------------
            else
                if not lockedDetector then
                    lockedDetector = findClosestDetector(hrp)
                end
                activeDetector = lockedDetector

                if not lockedDetector or not lockedDetector.Parent then
                    pcall(function()
                        ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(torso)
                    end)
                end
                
                if lockedDetector and lockedDetector.Parent then
                    local currentDetPos = lockedDetector.Position
                    local targetPos = targetCFrame.Position
                    local distFromAbove = (currentDetPos - targetPos).Magnitude
                    
                    -- Detectorが頭上20スタッドから10スタッド以上外れたら再取得TP
                    if distFromAbove > 10 then
                        local originalCFrame = myHRP.CFrame
                        
                        setAnchored(hrp, false)
                        setAnchored(lockedDetector, false)

                        myHRP.CFrame = lockedDetector.CFrame * CFrame.new(0, -6, 0)
                        task.wait(fastWait)
                        
                        -- ★ リモートイベント送信（本来の形：Torsoの実座標をそのまま渡す）
                        pcall(function()
                            ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(table.unpack({
                                [1] = torso,
                                [2] = torso.CFrame
                            }))
                        end)
                        
                        myHRP.CFrame = originalCFrame
                    end
                end
                
                task.wait(fastWait)
                
                -- 真上20スタッドに常に追従・固定
                if isGrabbingMode1 or isGrabbingMode2 then
                    pcall(function()
                        hrp.CFrame = targetCFrame
                        stopVelocity(hrp)
                        setAnchored(hrp, true)

                        if lockedDetector and lockedDetector.Parent then
                            lockedDetector.CFrame = targetCFrame
                            stopVelocity(lockedDetector)
                            setAnchored(lockedDetector, true)
                        end
                    end)
                end
                
                -- ★ リモートイベント送信（本来の形：Torsoの実座標をそのまま渡す）
                pcall(function()
                    ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(table.unpack({
                        [1] = torso,
                        [2] = torso.CFrame
                    }))
                end)
                
                task.wait(fastWait)
                
                pcall(function()
                    ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(torso)
                end)
                
                task.wait(fastWait)
            end
        end
        
        if activeHRP then setAnchored(activeHRP, false) end
        if activeDetector then setAnchored(activeDetector, false) end
    end)
end

-- UI構築・イベント設定
local Dropdown = Tab:CreateDropdown({
    Name = "対象プレイヤー",
    Options = getPlayers(),
    CurrentOption = {""},
    Flag = "TargetPlayer",
    Callback = function(Option)
        if type(Option) == "table" then
            selectedPlayerText = Option[1] or ""
        else
            selectedPlayerText = Option or ""
        end
    end,
})

-- トグル1 (Detector CFrame送信)
local GrabToggle1 = Tab:CreateToggle({
    Name = "掴む (Detector CFrame送信)",
    CurrentValue = false,
    Flag = "GrabToggle1",
    Callback = function(Value)
        if Value then
            startGrab(false)
        else
            stopGrab()
        end
    end,
})

-- トグル2 (キャラ CFrame送信)
local GrabToggle2 = Tab:CreateToggle({
    Name = "掴む (キャラ CFrame送信)",
    CurrentValue = false,
    Flag = "GrabToggle2",
    Callback = function(Value)
        if Value then
            startGrab(true)
        else
            stopGrab()
        end
    end,
})

local function updateDropdown()
    local newList = getPlayers()
    pcall(function()
        if Dropdown.Refresh then
            Dropdown:Refresh(newList)
        elseif Dropdown.Set then
            Dropdown:Set(newList)
        end
    end)
    
    local currentUsername = getUsernameFromOption(selectedPlayerText)
    if currentUsername and not Players:FindFirstChild(currentUsername) then
        selectedPlayerText = ""
    end
end

Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    updateDropdown()
end)

LocalPlayer.OnDestroying:Connect(function()
    stopGrab()
end)
