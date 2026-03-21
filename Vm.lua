local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jadpy/suki/refs/heads/main/orion')))()
local Window = OrionLib:MakeWindow({
    Name = "Extracted Features",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "ExtractedConfig"
})

-- ===== ヘルパー関数 =====

local selectedKickPlayer = nil

local function getPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            table.insert(list, plr.DisplayName .. " (" .. plr.Name .. ")")
        end
    end
    return list
end

local function getPlayerFromSelection(selection)
    if not selection then
        return nil
    end
    local username = selection:match("%((.-)%)")
    if username then
        return Players:FindFirstChild(username)
    end
    return nil
end

-- ===== Blobman タブ =====

local BlobmanTab = Window:MakeTab({
    Name = "Blobman",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local BlobmanSection = BlobmanTab:AddSection({
    Name = "Blobman Features"
})

local kickLoopEnabled = false

-- ドロップダウンを変数に保持
local KickDropdown = BlobmanTab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = getPlayerList(),
    Callback = function(Value)
        selectedKickPlayer = getPlayerFromSelection(Value)
    end
})

-- 動的更新: 入退室時に自動でリスト更新
local function refreshKickDropdown()
    local newList = getPlayerList()
    KickDropdown:Refresh(newList, true) -- true = 選択をリセット
    selectedKickPlayer = nil
end

Players.PlayerAdded:Connect(refreshKickDropdown)
Players.PlayerRemoving:Connect(function(plr)
    -- 選択中のプレイヤーが退出したらリセット
    if selectedKickPlayer == plr then
        selectedKickPlayer = nil
    end
    task.defer(refreshKickDropdown) -- 少し待ってから更新（リスト反映のため）
end)

BlobmanTab:AddToggle({
    Name = "ぐらぶ",
    Default = false,
    Callback = function(on)
        kickLoopEnabled = on
        local target = selectedKickPlayer
        
        if on and not target then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Select target first",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        
        local char = Player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local seat = hum and hum.SeatPart
        
        if on and (not seat or seat.Parent.Name ~= "CreatureBlobman") then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Must be sitting on Blobman",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        
        if not on then
            kickLoopEnabled = false
            return
        end
        
        task.spawn(function()
            local GE = ReplicatedStorage:WaitForChild("GrabEvents")
            local blob = seat.Parent
            local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
            local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
            local CG = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
            local CD = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
            local R_Det = blob:FindFirstChild("RightDetector")
            local R_Weld = R_Det and (R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld"))
            local SavedPos = blobRoot.CFrame
            
            local tChar = target.Character
            local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
            
            if tRoot and blobRoot then
                local bringStart = tick()
                while tick() - bringStart < 0.35 do
                    if not kickLoopEnabled then
                        break
                    end
                    blobRoot.CFrame = tRoot.CFrame
                    blobRoot.Velocity = Vector3.zero
                    pcall(function()
                        if CG and R_Det then
                            CG:FireServer(R_Det, tRoot, R_Weld)
                        end
                        GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                        GE.SetNetworkOwner:FireServer(tRoot, blobRoot.CFrame)
                    end)
                    RunService.Heartbeat:Wait()
                end
                blobRoot.CFrame = SavedPos
                blobRoot.Velocity = Vector3.zero
                task.wait(0.05)
            end
            
            local packetTimer = 0
            while kickLoopEnabled do
                if not target or not target.Parent or not target.Character then
                    break
                end
                
                local tChar = target.Character
                local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                local tHum = tChar and tChar:FindFirstChild("Humanoid")
                
                if tRoot and tHum and tHum.Health > 0 and blobRoot then
                    blobRoot.CFrame = SavedPos
                    blobRoot.Velocity = Vector3.zero
                    
                    local lockPos = SavedPos * CFrame.new(0, 23, 0)
                    tRoot.CFrame = lockPos
                    tRoot.Velocity = Vector3.zero
                    tRoot.RotVelocity = Vector3.zero
                    
                    if tick() - packetTimer > 0.05 then
                        packetTimer = tick()
                        pcall(function()
                            tHum.PlatformStand = true
                            tHum.Sit = true
                            GE.SetNetworkOwner:FireServer(tRoot, lockPos)
                            if R_Det then
                                local weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
                                if weld then
                                    CD:FireServer(weld)
                                end
                            end
                            GE.DestroyGrabLine:FireServer(tRoot)
                            if R_Det then
                                CG:FireServer(R_Det, tRoot, R_Weld)
                            end
                            GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                        end)
                    end
                else
                    blobRoot.CFrame = SavedPos
                    blobRoot.Velocity = Vector3.zero
                end
                
                if not kickLoopEnabled then
                    break
                end
                RunService.Heartbeat:Wait()
            end
            
            kickLoopEnabled = false
            if blobRoot then
                blobRoot.CFrame = SavedPos
                blobRoot.Velocity = Vector3.zero
            end
        end)
    end
})
local grabLockEnabled = false

BlobmanTab:AddToggle({
    Name = "グラブロック (掴んで20スタッド上に固定)",
    Default = false,
    Callback = function(on)
        grabLockEnabled = on

        if not on then return end

        local target = selectedKickPlayer
        if not target then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Select target first",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            grabLockEnabled = false
            return
        end

        local char = Player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local seat = hum and hum.SeatPart

        if not seat or seat.Parent.Name ~= "CreatureBlobman" then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Must be sitting on Blobman",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            grabLockEnabled = false
            return
        end

        task.spawn(function()
            local GE = ReplicatedStorage:WaitForChild("GrabEvents")
            local blob = seat.Parent
            local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
            local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
            local CG = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
            local R_Det = blob:FindFirstChild("RightDetector")
            local R_Weld = R_Det and (R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld"))

            while grabLockEnabled do
                if not target or not target.Parent or not target.Character then break end

                local tChar = target.Character
                local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                local tHum = tChar and tChar:FindFirstChild("Humanoid")

                if tRoot and tHum and tHum.Health > 0 and blobRoot then
                    -- 掴む
                    pcall(function()
                        if CG and R_Det then
                            CG:FireServer(R_Det, tRoot, R_Weld)
                        end
                        GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                    end)

                    -- 20スタッド上の位置を計算
                    local lockPos = blobRoot.CFrame * CFrame.new(0, 20, 0)

                    -- SetNetworkOwnerを送って位置を固定
                    pcall(function()
                        GE.SetNetworkOwner:FireServer(tRoot, lockPos)
                        tRoot.CFrame = lockPos
                        tRoot.Velocity = Vector3.zero
                        tRoot.RotVelocity = Vector3.zero
                        if tHum then
                            tHum.PlatformStand = true
                        end
                    end)
                end

                RunService.Heartbeat:Wait()
            end
        end)
    end
})

OrionLib:Init()

OrionLib:MakeNotification({
    Name = "Script Loaded",
    Content = "Extracted Features loaded successfully!",
    Image = "rbxassetid://4483345998",
    Time = 5
})
