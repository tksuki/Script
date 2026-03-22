-- FlyGuiV3 Enhanced - R15対応 + 動的スティック版 + 降車修正
if not game:IsLoaded() then
    game.Loaded:wait()
end

local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local LocalPlayer=P.LocalPlayer

-- カメラ設定を最初に適用
pcall(function()
    LocalPlayer.CameraMaxZoomDistance = 999999999
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
end)

-- カメラ貫通修正
pcall(function()
    local PopperClient = LocalPlayer:WaitForChild("PlayerScripts").PlayerModule.CameraModule.ZoomController.Popper
    for i, v in next, getgc() do
        if getfenv(v).script == PopperClient and typeof(v) == "function" then
            for i2, v2 in next, debug.getconstants(v) do
                if tonumber(v2) == 0.25 then
                    debug.setconstant(v, i2, 0)
                elseif tonumber(v2) == 0 then
                    debug.setconstant(v, i2, 0.25)
                end
            end
        end
    end
end)

FLYING=false 
QEfly=true 
vehicleflyspeed=1 
NOCLIP_ENABLED=false 
local fD,fU,tC,nC,seatConnection
local scriptAddedParts={}
local originalCanCollideStates={}

-- R6/R15両対応のルートパーツ取得関数
local function gR(c)
    return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
end

local function getVehicle()
    local p=LocalPlayer 
    local c=p.Character 
    if not c then return nil end 
    local h=c:FindFirstChildOfClass("Humanoid")
    if h and h.SeatPart and h.SeatPart.Parent then 
        return h.SeatPart.Parent 
    end 
    return nil 
end

local function saveOriginalCollisionState(part)
    if not originalCanCollideStates[part] then
        originalCanCollideStates[part] = part.CanCollide
    end
end

local function restoreOriginalCollisionState(part)
    if originalCanCollideStates[part] ~= nil then
        part.CanCollide = originalCanCollideStates[part]
    end
end

function toggleNoclip(enable)
    NOCLIP_ENABLED=enable 
    if enable then 
        nC=R.Stepped:Connect(function()
            local c=LocalPlayer.Character 
            if c then 
                for _,part in pairs(c:GetDescendants())do 
                    if part:IsA("BasePart")then 
                        saveOriginalCollisionState(part)
                        part.CanCollide=false 
                    end 
                end 
            end 
            
            local v=getVehicle()
            if v then 
                for _,part in pairs(v:GetDescendants())do 
                    if part:IsA("BasePart")then 
                        saveOriginalCollisionState(part)
                        part.CanCollide=false
                    end 
                end
                
                for _,seat in pairs(v:GetDescendants()) do
                    if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
                        if seat.Occupant then
                            local occupantChar = seat.Occupant.Parent
                            if occupantChar then
                                for _,part in pairs(occupantChar:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        saveOriginalCollisionState(part)
                                        part.CanCollide=false
                                    end
                                end
                            end
                        end
                    end
                end
            end 
        end)
    else 
        if nC then nC:Disconnect()nC=nil end 
        local c=LocalPlayer.Character 
        if c then 
            for _,part in pairs(c:GetDescendants())do 
                if part:IsA("BasePart")then 
                    restoreOriginalCollisionState(part)
                end 
            end 
        end 
        local v=getVehicle()
        if v then 
            for _,part in pairs(v:GetDescendants())do 
                if part:IsA("BasePart")then
                    local isScriptPart=false
                    for _,addedPart in pairs(scriptAddedParts)do
                        if part==addedPart or part:FindFirstChildOfClass("BodyGyro")or part:FindFirstChildOfClass("BodyVelocity")then
                            isScriptPart=true
                            break
                        end
                    end
                    if isScriptPart then
                        part.CanCollide=false
                    else
                        restoreOriginalCollisionState(part)
                    end
                end 
            end 
        end
        originalCanCollideStates={}
    end 
end

function sFLY(v)
    local c=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local h=c:FindFirstChildOfClass("Humanoid")
    if not h then 
        repeat task.wait()until c:FindFirstChildOfClass("Humanoid")
        h=c:FindFirstChildOfClass("Humanoid")
    end
    
    if fD or fU then fD:Disconnect()fU:Disconnect()end 
    if tC then tC:Disconnect()tC=nil end
    if seatConnection then seatConnection:Disconnect()seatConnection=nil end
    
    local T=gR(c)
    local C={F=0,B=0,L=0,R=0,Q=0,E=0}
    local lC={F=0,B=0,L=0,R=0,Q=0,E=0}
    local S=0
    local currentVehicle = nil
    
    -- 車から降りる検知機能
    seatConnection = h.Seated:Connect(function(active, seat)
        if not active and FLYING then
            -- 座席から降りた時の処理
            task.wait(0.1)
            NOFLY()
            local o = LocalPlayer.PlayerGui:FindFirstChild("main")
            if o then
                local onofBtn = o.Frame:FindFirstChild("onof")
                if onofBtn then
                    onofBtn.BackgroundColor3=Color3.fromRGB(255,249,74)
                end
            end
            if NOCLIP_ENABLED then
                toggleNoclip(false)
                local nc = o and o.Frame:FindFirstChild("noclip")
                if nc then
                    nc.Text="Noclip: OFF"
                    nc.BackgroundColor3=Color3.fromRGB(255,150,200)
                end
            end
        end
    end)
    
    local function FLY()
        FLYING=true 
        local BG=Instance.new('BodyGyro')
        local BV=Instance.new('BodyVelocity')
        
        local flyTarget = nil
        currentVehicle = getVehicle()
        
        if currentVehicle then
            flyTarget = currentVehicle:FindFirstChild("VehicleSeat") or currentVehicle.PrimaryPart or currentVehicle:FindFirstChildWhichIsA("BasePart")
            
            for _, seat in pairs(currentVehicle:GetDescendants()) do
                if seat:IsA("VehicleSeat") then
                    seat.MaxSpeed = 0
                    seat.Torque = 0
                    seat.TurnSpeed = 0
                end
            end
            
            for _, obj in pairs(currentVehicle:GetDescendants()) do
                if obj:IsA("HingeConstraint") or obj:IsA("Motor") or obj:IsA("Motor6D") or 
                   obj:IsA("CylindricalConstraint") or obj:IsA("BallSocketConstraint") then
                    if obj:IsA("HingeConstraint") then
                        obj.MotorMaxTorque = 0
                        obj.AngularVelocity = 0
                    elseif obj:IsA("Motor") or obj:IsA("Motor6D") then
                        obj.MaxVelocity = 0
                        obj.DesiredAngle = 0
                    end
                end
            end
        else
            flyTarget = T
        end
        
        if not flyTarget then return end
        
        table.insert(scriptAddedParts,flyTarget)
        BG.P=9e4 
        BG.Parent=flyTarget 
        BV.Parent=flyTarget 
        BG.MaxTorque=Vector3.new(9e9,9e9,9e9)
        BG.CFrame=flyTarget.CFrame 
        BV.Velocity=Vector3.new(0,0,0)
        BV.MaxForce=Vector3.new(9e9,9e9,9e9)
        
        task.spawn(function()
            repeat task.wait()
                local cam=workspace.CurrentCamera
                
                local newVehicle = getVehicle()
                if newVehicle ~= currentVehicle then
                    if currentVehicle then
                        for _, seat in pairs(currentVehicle:GetDescendants()) do
                            if seat:IsA("VehicleSeat") then
                                seat.Disabled = false
                            end
                        end
                    end
                    
                    currentVehicle = newVehicle
                    if currentVehicle then
                        flyTarget = currentVehicle:FindFirstChild("VehicleSeat") or currentVehicle.PrimaryPart or currentVehicle:FindFirstChildWhichIsA("BasePart")
                        
                        for _, seat in pairs(currentVehicle:GetDescendants()) do
                            if seat:IsA("VehicleSeat") then
                                seat.Disabled = true
                                seat.MaxSpeed = 0
                                seat.Torque = 0
                                seat.TurnSpeed = 0
                            end
                        end
                        
                        for _, obj in pairs(currentVehicle:GetDescendants()) do
                            if obj:IsA("HingeConstraint") or obj:IsA("Motor") or obj:IsA("Motor6D") or 
                               obj:IsA("CylindricalConstraint") or obj:IsA("BallSocketConstraint") then
                                if obj:IsA("HingeConstraint") then
                                    obj.MotorMaxTorque = 0
                                    obj.AngularVelocity = 0
                                elseif obj:IsA("Motor") or obj:IsA("Motor6D") then
                                    obj.MaxVelocity = 0
                                    obj.DesiredAngle = 0
                                end
                            end
                        end
                    else
                        flyTarget = T
                    end
                    
                    if flyTarget and BG.Parent ~= flyTarget then
                        BG.Parent = flyTarget
                        BV.Parent = flyTarget
                        table.insert(scriptAddedParts,flyTarget)
                    end
                end
                
                if not currentVehicle and h then 
                    h.PlatformStand=true 
                end
                
                if C.L+C.R~=0 or C.F+C.B~=0 or C.Q+C.E~=0 then 
                    S=50 
                elseif not(C.L+C.R~=0 or C.F+C.B~=0 or C.Q+C.E~=0)and S~=0 then 
                    S=0 
                end
                
                if(C.L+C.R)~=0 or(C.F+C.B)~=0 or(C.Q+C.E)~=0 then
                    BV.Velocity=((cam.CFrame.LookVector*(C.F+C.B))+((cam.CFrame*CFrame.new(C.L+C.R,(C.F+C.B+C.Q+C.E)*0.2,0).Position)-cam.CFrame.Position))*S
                    lC={F=C.F,B=C.B,L=C.L,R=C.R}
                elseif(C.L+C.R)==0 and(C.F+C.B)==0 and(C.Q+C.E)==0 and S~=0 then
                    BV.Velocity=((cam.CFrame.LookVector*(lC.F+lC.B))+((cam.CFrame*CFrame.new(lC.L+lC.R,(lC.F+lC.B+C.Q+C.E)*0.2,0).Position)-cam.CFrame.Position))*S
                else 
                    BV.Velocity=Vector3.new(0,0,0)
                end 
                
                if not currentVehicle then
                    BG.CFrame = cam.CFrame
                else
                    BG.CFrame = CFrame.new(flyTarget.Position, flyTarget.Position + cam.CFrame.LookVector * Vector3.new(1, 0, 1))
                end
            until not FLYING
            
            C={F=0,B=0,L=0,R=0,Q=0,E=0}
            lC={F=0,B=0,L=0,R=0,Q=0,E=0}
            S=0 
            BG:Destroy()
            BV:Destroy()
            
            if currentVehicle then
                for _, seat in pairs(currentVehicle:GetDescendants()) do
                    if seat:IsA("VehicleSeat") then
                        seat.Disabled = false
                    end
                end
            end
            
            for i=#scriptAddedParts,1,-1 do 
                if scriptAddedParts[i]==flyTarget then 
                    table.remove(scriptAddedParts,i)
                end 
            end
            
            if h then h.PlatformStand=false end 
        end)
    end
    
    fD=U.InputBegan:Connect(function(i)
        local k=i.KeyCode 
        if k==Enum.KeyCode.W then 
            C.F=(v and vehicleflyspeed or 1)
        elseif k==Enum.KeyCode.S then 
            C.B=-(v and vehicleflyspeed or 1)
        elseif k==Enum.KeyCode.A then 
            C.L=-(v and vehicleflyspeed or 1)
        elseif k==Enum.KeyCode.D then 
            C.R=(v and vehicleflyspeed or 1)
        elseif QEfly and k==Enum.KeyCode.E then 
            C.Q=(v and vehicleflyspeed or 1)*2
        elseif QEfly and k==Enum.KeyCode.Q then 
            C.E=-(v and vehicleflyspeed or 1)*2 
        end 
    end)
    
    fU=U.InputEnded:Connect(function(i)
        local k=i.KeyCode 
        if k==Enum.KeyCode.W then 
            C.F=0 
        elseif k==Enum.KeyCode.S then 
            C.B=0
        elseif k==Enum.KeyCode.A then 
            C.L=0 
        elseif k==Enum.KeyCode.D then 
            C.R=0 
        elseif k==Enum.KeyCode.E then 
            C.Q=0 
        elseif k==Enum.KeyCode.Q then 
            C.E=0 
        end 
    end)
    
    local lM=Vector3.new(0,0,0)
    tC=R.Heartbeat:Connect(function()
        pcall(function()
            local PM=LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
            local CM=require(PM:WaitForChild("ControlModule"))
            local m=CM:GetMoveVector()
            
            if m.Magnitude>0.1 then 
                lM=m 
                if m.Z<-0.1 then 
                    C.F=math.abs(m.Z)*(v and vehicleflyspeed or 1)
                    C.B=0 
                elseif m.Z>0.1 then 
                    C.B=-m.Z*(v and vehicleflyspeed or 1)
                    C.F=0 
                else 
                    C.F=0 
                    C.B=0 
                end
                
                if m.X>0.1 then 
                    C.R=m.X*(v and vehicleflyspeed or 1)
                    C.L=0 
                elseif m.X<-0.1 then 
                    C.L=math.abs(m.X)*-(v and vehicleflyspeed or 1)
                    C.R=0 
                else 
                    C.L=0 
                    C.R=0 
                end
            else 
                if lM.Magnitude>0 then 
                    C.F=0 
                    C.B=0 
                    C.L=0 
                    C.R=0 
                    lM=Vector3.new(0,0,0)
                end 
            end 
        end)
    end)
    
    FLY()
end

function NOFLY()
    FLYING=false 
    if fD or fU then fD:Disconnect()fU:Disconnect()end 
    if tC then tC:Disconnect()tC=nil end
    if seatConnection then seatConnection:Disconnect()seatConnection=nil end
    
    local v = getVehicle()
    if v then
        for _, seat in pairs(v:GetDescendants()) do
            if seat:IsA("VehicleSeat") then
                seat.Disabled = false
            end
        end
    end
    
    scriptAddedParts={}
end

-- GUI作成
local m=Instance.new("ScreenGui")
local F=Instance.new("Frame")
local u=Instance.new("TextButton")
local d=Instance.new("TextButton")
local o=Instance.new("TextButton")
local t=Instance.new("TextLabel")
local pl=Instance.new("TextButton")
local sp=Instance.new("TextBox")
local mi=Instance.new("TextButton")
local c=Instance.new("TextButton")
local mn=Instance.new("TextButton")
local mn2=Instance.new("TextButton")
local nc=Instance.new("TextButton")
local t2=Instance.new("TextLabel")

m.Name="main"
m.Parent=LocalPlayer:WaitForChild("PlayerGui")
m.ZIndexBehavior=Enum.ZIndexBehavior.Sibling 
m.ResetOnSpawn=false

F.Parent=m 
F.BackgroundColor3=Color3.fromRGB(163,255,137)
F.BorderColor3=Color3.fromRGB(103,221,213)
F.Position=UDim2.new(0.1,0,0.38,0)
F.Size=UDim2.new(0,190,0,85)
F.Active=true 
F.Draggable=false

u.Name="up"
u.Parent=F 
u.BackgroundColor3=Color3.fromRGB(79,255,152)
u.Size=UDim2.new(0,44,0,28)
u.Font=Enum.Font.SourceSans 
u.Text="UP"
u.TextColor3=Color3.new(0,0,0)
u.TextSize=14

d.Name="down"
d.Parent=F 
d.BackgroundColor3=Color3.fromRGB(215,255,121)
d.Position=UDim2.new(0,0,0.33,0)
d.Size=UDim2.new(0,44,0,28)
d.Font=Enum.Font.SourceSans 
d.Text="DOWN"
d.TextColor3=Color3.new(0,0,0)
d.TextSize=14

o.Name="onof"
o.Parent=F 
o.BackgroundColor3=Color3.fromRGB(255,249,74)
o.Position=UDim2.new(0.7,0,0.33,0)
o.Size=UDim2.new(0,56,0,28)
o.Font=Enum.Font.SourceSans 
o.Text="vFly"
o.TextColor3=Color3.new(0,0,0)
o.TextSize=14

t.Name="title"
t.Parent=F 
t.BackgroundColor3=Color3.fromRGB(242,60,255)
t.Position=UDim2.new(0.47,0,0,0)
t.Size=UDim2.new(0,100,0,28)
t.Font=Enum.Font.SourceSans 
t.Text="vFLY GUI"
t.TextColor3=Color3.new(0,0,0)
t.TextScaled=true 
t.TextSize=14 
t.TextWrapped=true

pl.Name="plus"
pl.Parent=F 
pl.BackgroundColor3=Color3.fromRGB(133,145,255)
pl.Position=UDim2.new(0.23,0,0,0)
pl.Size=UDim2.new(0,45,0,28)
pl.Font=Enum.Font.SourceSans 
pl.Text="+"
pl.TextColor3=Color3.new(0,0,0)
pl.TextScaled=true 
pl.TextSize=14 
pl.TextWrapped=true

sp.Name="speed"
sp.Parent=F 
sp.BackgroundColor3=Color3.fromRGB(255,85,0)
sp.Position=UDim2.new(0.47,0,0.33,0)
sp.Size=UDim2.new(0,44,0,28)
sp.Font=Enum.Font.SourceSans 
sp.Text="1"
sp.TextColor3=Color3.new(0,0,0)
sp.TextScaled=true 
sp.TextSize=14 
sp.TextWrapped=true
sp.ClearTextOnFocus=false

mi.Name="mine"
mi.Parent=F 
mi.BackgroundColor3=Color3.fromRGB(123,255,247)
mi.Position=UDim2.new(0.23,0,0.33,0)
mi.Size=UDim2.new(0,45,0,29)
mi.Font=Enum.Font.SourceSans 
mi.Text="-"
mi.TextColor3=Color3.new(0,0,0)
mi.TextScaled=true 
mi.TextSize=14 
mi.TextWrapped=true

nc.Name="noclip"
nc.Parent=F 
nc.BackgroundColor3=Color3.fromRGB(255,150,200)
nc.Position=UDim2.new(0,0,0.67,0)
nc.Size=UDim2.new(0,190,0,28)
nc.Font=Enum.Font.SourceSans 
nc.Text="Noclip: OFF"
nc.TextColor3=Color3.new(0,0,0)
nc.TextSize=14

c.Name="Close"
c.Parent=F 
c.BackgroundColor3=Color3.fromRGB(225,25,0)
c.Font="SourceSans"
c.Size=UDim2.new(0,45,0,28)
c.Text="X"
c.TextSize=30 
c.Position=UDim2.new(0,0,0,-28)

mn.Name="minimize"
mn.Parent=F 
mn.BackgroundColor3=Color3.fromRGB(192,150,230)
mn.Font="SourceSans"
mn.Size=UDim2.new(0,45,0,28)
mn.Text="-"
mn.TextSize=40 
mn.Position=UDim2.new(0,45,0,-28)

mn2.Name="minimize2"
mn2.Parent=F 
mn2.BackgroundColor3=Color3.fromRGB(192,150,230)
mn2.Font="SourceSans"
mn2.Size=UDim2.new(0,45,0,28)
mn2.Text="+"
mn2.TextSize=40 
mn2.Position=UDim2.new(0,45,0,-28)
mn2.Visible=false

t2.Name="title2"
t2.Parent=F 
t2.BackgroundColor3=Color3.fromRGB(242,60,255)
t2.Position=UDim2.new(0,90,0,-28)
t2.Size=UDim2.new(0,100,0,28)
t2.Font=Enum.Font.SourceSans 
t2.Text="vFLY GUI"
t2.TextColor3=Color3.new(0,0,0)
t2.TextScaled=true 
t2.TextSize=14 
t2.TextWrapped=true
t2.Visible=false

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="野獣のちんちん";
    Text="R15対応+降車修正版が起動しました";
    Icon="rbxthumb://type=Asset&id=5107182114&w=150&h=150"
})

-- vFlyボタン
o.MouseButton1Down:connect(function()
    if FLYING then 
        NOFLY()
        o.BackgroundColor3=Color3.fromRGB(255,249,74)
        if NOCLIP_ENABLED then
            toggleNoclip(false)
            nc.Text="Noclip: OFF"
            nc.BackgroundColor3=Color3.fromRGB(255,150,200)
        end
    else 
        sFLY(true)
        o.BackgroundColor3=Color3.fromRGB(74,255,87)
    end 
end)

-- Noclipボタン
nc.MouseButton1Down:connect(function()
    if NOCLIP_ENABLED then 
        toggleNoclip(false)
        nc.Text="Noclip: OFF"
        nc.BackgroundColor3=Color3.fromRGB(255,150,200)
    else 
        toggleNoclip(true)
        nc.Text="Noclip: ON"
        nc.BackgroundColor3=Color3.fromRGB(100,255,150)
    end 
end)

-- UP/DOWNボタン
local ti 
u.MouseButton1Down:connect(function()
    ti=u.MouseEnter:connect(function()
        while ti do 
            wait()
            local ch=LocalPlayer.Character 
            local r=gR(ch)
            if r then r.CFrame=r.CFrame*CFrame.new(0,1,0)end 
        end 
    end)
end)
u.MouseLeave:connect(function()if ti then ti:Disconnect()ti=nil end end)

local di 
d.MouseButton1Down:connect(function()
    di=d.MouseEnter:connect(function()
        while di do 
            wait()
            local ch=LocalPlayer.Character 
            local r=gR(ch)
            if r then r.CFrame=r.CFrame*CFrame.new(0,-1,0)end 
        end 
    end)
end)
d.MouseLeave:connect(function()if di then di:Disconnect()di=nil end end)

-- 速度調整ボタン
pl.MouseButton1Down:connect(function()
    vehicleflyspeed=vehicleflyspeed+1 
    sp.Text=tostring(vehicleflyspeed)
end)

mi.MouseButton1Down:connect(function()
    if vehicleflyspeed==1 then 
        sp.Text='cannot be less than 1'
        wait(1)
        sp.Text=tostring(vehicleflyspeed)
    else 
        vehicleflyspeed=vehicleflyspeed-1 
        sp.Text=tostring(vehicleflyspeed)
    end 
end)

-- 数字を直接入力したときの処理
sp.FocusLost:Connect(function(enterPressed)
    local inputNum = tonumber(sp.Text)
    if inputNum and inputNum >= 1 then
        vehicleflyspeed = math.floor(inputNum)
        sp.Text = tostring(vehicleflyspeed)
    else
        sp.Text = tostring(vehicleflyspeed)
    end
end)

-- 閉じるボタン
c.MouseButton1Click:Connect(function()
    NOFLY()
    toggleNoclip(false)
    m:Destroy()
end)

-- 最小化/最大化
mn.MouseButton1Click:Connect(function()
    u.Visible=false 
    d.Visible=false 
    o.Visible=false 
    pl.Visible=false 
    sp.Visible=false 
    mi.Visible=false 
    nc.Visible=false 
    mn.Visible=false 
    mn2.Visible=true 
    t.Visible=false 
    t2.Visible=true 
    F.BackgroundTransparency=1 
    c.BackgroundTransparency=1 
    c.TextTransparency=1
end)

mn2.MouseButton1Click:Connect(function()
    u.Visible=true 
    d.Visible=true 
    o.Visible=true 
    pl.Visible=true 
    sp.Visible=true 
    mi.Visible=true 
    nc.Visible=true 
    mn.Visible=true 
    mn2.Visible=false 
    t.Visible=true 
    t2.Visible=false 
    F.BackgroundTransparency=0 
    c.BackgroundTransparency=0 
    c.TextTransparency=0
end)

-- ドラッグ機能
local dragging
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    F.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

t.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = F.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

t.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

t2.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = F.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

t2.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

U.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- リスポーン時の処理
LocalPlayer.CharacterAdded:Connect(function()
    wait(0.7)
    NOFLY()
    toggleNoclip(false)
    originalCanCollideStates={}
    
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = 999999999
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end)
end)
