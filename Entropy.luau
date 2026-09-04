local OrionLib
do
local _ok,_err=pcall(function()
OrionLib=loadstring(game:HttpGet("https://pastefy.app/3KUufD9g/raw"))()
end)
if not _ok or not OrionLib then
if getgenv and getgenv().OrionLib then
OrionLib=getgenv().OrionLib
else
error("[LUVIAL] HttpGuard: OrionLib load failed: "..tostring(_err),0)
end
end
if getgenv then getgenv().OrionLib=OrionLib end
end
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local HRP = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local rs = ReplicatedStorage
local DestroyToy = rs.MenuToys.DestroyToy
local SetNetOwner = rs.GrabEvents.SetNetworkOwner
local SpawnToy = rs.MenuToys.SpawnToyRemoteFunction
local Struggle = rs.CharacterEvents.Struggle
local Ragdoll = rs.CharacterEvents.RagdollRemote
local StickyEvent = rs.PlayerEvents.StickyPartEvent
local inv = workspace[plr.Name.."SpawnedInToys"]
local PlayerGui = plr:WaitForChild("PlayerGui")
local State = {
cons = {},
AntiGrabEnabled = false,
antiGrabConnection = nil,
AntiStickyEnabled = false,
AntiNetworkOwnerEnabled = false,
spawnedHamburger = nil,
monitorConnection = nil,
spawnInProgress = false,
heartBeatConnection = nil,
AntiKickEnabled = false,
antiKickRunning = false,
AntiKickKunaiEnabled = false,
kunaiMessageGui = nil,
kunaiTextLabel = nil,
currentKunai = nil,
kunaiCheckLoop = nil,
fadeInInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear),
fadeOutInfo = TweenInfo.new(0.6, Enum.EasingStyle.Linear),
AutoResetEnabled = false,
autoResetConnection = nil,
AntiKillEnabled = false,
antiKillConn = nil,
AntiBurnEnabled = false,
antiBurnConnection = nil,
AntiExplodeEnabled = false,
antiExplodeConn = nil,
AntiVoidEnabled = false,
AntiLagEnabled = false,
Lines = 0,
AutoAntiLagEnabled = false,
autoAntiLagRunning = false,
lagger = nil,
AntiPaintEnabled = false,
antiPaintConnection = nil,
AntiInputLagEnabled = false,
inputLagRunning = false,
GucciTractorEnabled = false,
gucciTractorObj = nil,
GucciTrainEnabled = false,
GucciBlobmanEnabled = false,
gucciBlobmanObj = nil,
AutoGucciBlobEnabled = false,
autoGucciRunning = false,
autoGucciConn = nil,
autoGucciLoopRunning = false,
blobmanAuraEnabled = false,
blobmanAuraMode = "Kill Aura",
blobmanAllEnabled = false,
blobmanAllMode = "All Kill",
blobmanAuraRunning = false,
blobmanAllRunning = false,
targetWalkSpeed = 16,
targetJumpPower = 50,
speedBoostActive = false,
currentBlobmanSpeed = 16,
speedConnection = nil,
}
local function getplot()
for i = 1, 5 do
local plot = workspace.Plots:FindFirstChild("Plot"..i)
local value = plot and plot.PlotSign and plot.PlotSign.ThisPlotsOwners and plot.PlotSign.ThisPlotsOwners:FindFirstChild("Value")
if plot and value and value.Value and value.Value:find(plr.Name) then
return plot
end
end
return nil
end
local function spawntoy(toy, cf)
if not plr.CanSpawnToy.Value then
plr.CanSpawnToy.Changed:Wait()
end
local t
local toyadded
toyadded = inv.ChildAdded:Connect(function(c)
if c.Name == toy then
t = c
toyadded:Disconnect()
end
end)
task.spawn(function()
SpawnToy:InvokeServer(toy, cf, Vector3.new(0,0,0))
end)
local time = tick() + 1
repeat task.wait() until t or tick() > time
if t then
return t
else
local plot = getplot()
if plot then
return workspace.PlotItems[plot.Name]:FindFirstChild(toy) or workspace.PlotItems[plot.Name]:WaitForChild(toy, 0.5)
end
end
return nil
end
local function sno(obj)
SetNetOwner:FireServer(obj, obj.CFrame)
end
local function stvel(hrp)
hrp.AssemblyLinearVelocity = Vector3.zero
hrp.AssemblyAngularVelocity = Vector3.zero
end
plr.CharacterAdded:Connect(function(c)
task.wait(0.1)
if c then
HRP = c:FindFirstChild("HumanoidRootPart") or c:WaitForChild("HumanoidRootPart", 1)
hum = c:FindFirstChild("Humanoid") or c:WaitForChild("Humanoid", 1)
char = c
end
end)
local Window = OrionLib:MakeWindow({
Name = "ΔS ≥ 0 Test",
Name2 = "Entropy Hub made by LOL",
Name3 = "https://discord.gg/a25NUYQPYU",
TitleTime = 10,
ResizeEnabled = true,
HidePremium = false,
SaveConfig = true,
ConfigFolder = "ΔS ≥ 0",
IntroEnabledLong = true,
IntroText = false,
FreeMouse = true,
KeyToOpenWindow = "M",
})
local WelTab = Window:MakeTab({Name = "Welcome",Icon = "", PremiumOnly = false})
local DefenceTab = Window:MakeTab({Name = "Defence",Icon = "",PremiumOnly = false,})
local BlobmanTab = Window:MakeTab({Name = "Blobman",Icon = "",PremiumOnly = false,})
WelTab:AddParagraph("Discord server", "For support and the latest information, click here!\n👇Click to copy")
WelTab:AddButton({
Name = "Copy Discord Link",
Callback = function()
setclipboard("https://discord.gg/a25NUYQPYU")
OrionLib:MakeNotification({Name = "Copy completed", Content = "Discord link copied!", Time = 3})
end
})
local GrabSection = DefenceTab:AddSection({
Name = "Anti Grab"
})
DefenceTab:AddToggle({
Name = "Anti Grab",
Description = "Prevents grab attacks",
Callback = function(Value)
State.AntiGrabEnabled = Value
if Value then
if State.antiGrabConnection then State.antiGrabConnection:Disconnect() end
State.antiGrabConnection = RunService.Heartbeat:Connect(function()
if plr.IsHeld and plr.IsHeld.Value then
local char = plr.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.Velocity = Vector3.new()
char.HumanoidRootPart.Anchored = true
Struggle:FireServer(plr)
Ragdoll:FireServer(char.HumanoidRootPart, 0)
end
else
local char = plr.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.Anchored = false
end
end
end)
else
if State.antiGrabConnection then
State.antiGrabConnection:Disconnect()
State.antiGrabConnection = nil
end
local char = plr.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.Anchored = false
end
end
end
})
local function setTouchQuery(state)
local char = Workspace:FindFirstChild(plr.Name)
if not char then return end
for _, v in ipairs(char:GetChildren()) do
if v:IsA("Part") or v:IsA("BasePart") then
v.CanTouch = state
v.CanQuery = state
end
end
end
DefenceTab:AddToggle({
Name = "Anti Sticky",
Description = "Prevents sticky attacks",
Callback = function(Value)
State.AntiStickyEnabled = Value
if Value then
setTouchQuery(false)
else
setTouchQuery(true)
end
end
})
local function getPlayerPosition()
local char = plr.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if root then
return root.CFrame
end
return CFrame.new(0, 0, 0)
end
local function spawnAndGrabNetwork()
if State.spawnInProgress then return end
State.spawnInProgress = true

task.spawn(function()
pcall(function()
local char = workspace:FindFirstChild(plr.Name)
if not char then State.spawnInProgress = false return end
local hum = char:FindFirstChild("Humanoid")
if not hum or hum.Health <= 0 then State.spawnInProgress = false return end
local playerCFrame = getPlayerPosition()
local spawnPosition = playerCFrame * CFrame.new(0, 1, -1.5)
local vectorPosition = Vector3.new(spawnPosition.X, spawnPosition.Y, spawnPosition.Z)
SpawnToy:InvokeServer(
"FoodHamburger",
spawnPosition,
vectorPosition
)
local spawnedToys = workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
if spawnedToys then
local newObj = spawnedToys:FindFirstChild("FoodHamburger")
if newObj then
if State.monitorConnection then
State.monitorConnection:Disconnect()
State.monitorConnection = nil
end
State.monitorConnection = newObj.AncestryChanged:Connect(function()
if not newObj.Parent then
State.spawnedHamburger = nil
end
end)

local holdPart = newObj:FindFirstChild("HoldPart")
local startTime = tick()
while not holdPart and tick() - startTime < 0.005 do
holdPart = newObj:FindFirstChild("HoldPart")
task.wait(0.0001)
end

if holdPart then
pcall(function()
holdPart.HoldItemRemoteFunction:InvokeServer(newObj, char)
end)
State.spawnedHamburger = newObj
end
end
end
end)
State.spawnInProgress = false
end)
end
local function antiNetworkOwnerLoop()
if State.heartBeatConnection then
State.heartBeatConnection:Disconnect()
State.heartBeatConnection = nil
end

State.heartBeatConnection = RunService.Heartbeat:Connect(function()
if not State.AntiNetworkOwnerEnabled then
State.heartBeatConnection:Disconnect()
State.heartBeatConnection = nil
return
end

pcall(function()
local char = workspace:FindFirstChild(plr.Name)
if not char then return end
local hum = char:FindFirstChild("Humanoid")
if not hum or hum.Health <= 0 then return end
if not State.spawnedHamburger or not State.spawnedHamburger.Parent then
if not State.spawnInProgress then
spawnAndGrabNetwork()
end
return
end
local holdPart = State.spawnedHamburger:FindFirstChild("HoldPart")
if not holdPart then
State.spawnedHamburger = nil
if not State.spawnInProgress then
spawnAndGrabNetwork()
end
return
end
local grabOk = pcall(function()
holdPart.HoldItemRemoteFunction:InvokeServer(State.spawnedHamburger, char)
end)
if not grabOk then
State.spawnedHamburger = nil
if not State.spawnInProgress then
spawnAndGrabNetwork()
end
return
end
task.wait(0.0001)
local currentCF = getPlayerPosition()
pcall(function()
holdPart.DropItemRemoteFunction:InvokeServer(State.spawnedHamburger, currentCF, Vector3.new(0, 115, 0))
end)
end)
end)
end
plr.CharacterAdded:Connect(function()
if State.AntiNetworkOwnerEnabled then
task.wait(0.01)
if State.monitorConnection then
State.monitorConnection:Disconnect()
State.monitorConnection = nil
end
State.spawnedHamburger = nil
State.spawnInProgress = false
spawnAndGrabNetwork()
end
end)
DefenceTab:AddToggle({
Name = "Anti Network Owner",
Description = "Prevents network owner related attacks",
Callback = function(Value)
State.AntiNetworkOwnerEnabled = Value
if State.AntiNetworkOwnerEnabled then
if State.monitorConnection then
State.monitorConnection:Disconnect()
State.monitorConnection = nil
end
State.spawnedHamburger = nil
State.spawnInProgress = false

task.spawn(spawnAndGrabNetwork)
task.spawn(antiNetworkOwnerLoop)
else
if State.heartBeatConnection then
State.heartBeatConnection:Disconnect()
State.heartBeatConnection = nil
end
if State.monitorConnection then
State.monitorConnection:Disconnect()
State.monitorConnection = nil
end
State.spawnedHamburger = nil
State.spawnInProgress = false
end
end
})
local KickSection = DefenceTab:AddSection({
Name = "Anti Kick"
})
DefenceTab:AddToggle({
Name = "Anti Kick",
Description = "Prevents kick attacks",
Callback = function(Value)
State.AntiKickEnabled = Value
if Value then
State.antiKickRunning = true
task.spawn(function()
task.wait(0.1)
if not inv:FindFirstChild("NinjaShuriken1") then
repeat task.wait() until plr.CanSpawnToy.Value
local shu
local part
while State.AntiKickEnabled and State.antiKickRunning and task.wait() do
pcall(function()
local chara = plr.Character
if not shu or not inv:FindFirstChild("NinjaShuriken1") and not workspace.PlotItems:FindFirstChild("NinjaShuriken1", true) then
shu = spawntoy("NinjaShuriken", HRP.CFrame * CFrame.new(5, 10, 20))
if shu then shu.Name = "NinjaShuriken1" end
part = shu and shu:WaitForChild("StickyPart", 0.3)
if part then sno(part) end
end
if shu and shu:FindFirstChild("StickyPart") and shu.StickyPart:FindFirstChild("PartOwner") and shu.StickyPart.PartOwner.Value ~= plr.Name then
if part then sno(part) end
end
if part and part:FindFirstChild("StickyWeld") and part.StickyWeld.Part1 ~= chara.HumanoidRootPart.FirePlayerPart then
if part then sno(part) end
StickyEvent:FireServer(part, chara.HumanoidRootPart.FirePlayerPart, CFrame.new(0,0,0,1,0,0,0,0,-1,0,1,0))
end
task.wait(0.2)
if shu and shu:FindFirstChild("StickyPart") and part and (part.Position - HRP.Position).Magnitude > 30 then
if inv:FindFirstChild("NinjaShuriken1") then DestroyToy:FireServer(inv.NinjaShuriken1) end
shu = spawntoy("NinjaShuriken", HRP.CFrame * CFrame.new(5, 10, 20))
if shu then shu.Name = "NinjaShuriken1" end
if part then sno(part) end
end
end)
end
end
end)
else
State.antiKickRunning = false
if inv:FindFirstChild("NinjaShuriken1") then DestroyToy:FireServer(inv.NinjaShuriken1) end
end
end
})
local function getRightLeg(char)
return char:FindFirstChild("Right Leg")
or char:FindFirstChild("RightFoot")
or char:FindFirstChild("RightLowerLeg")
or char:FindFirstChild("RightUpperLeg")
end
local function cleanupMyKunaiToys()
if not inv then return end
for _, toy in ipairs(inv:GetChildren()) do
if toy.Name == "NinjaKunai" then
pcall(function()
DestroyToy:FireServer(toy)
end)
end
end
end
local function createKunaiMessageGui()
if State.kunaiMessageGui then return end
State.kunaiMessageGui = Instance.new("ScreenGui")
State.kunaiMessageGui.Name = "KunaiMessageGui"
State.kunaiMessageGui.ResetOnSpawn = false
State.kunaiMessageGui.Parent = PlayerGui
State.kunaiTextLabel = Instance.new("TextLabel")
State.kunaiTextLabel.Size = UDim2.new(0, 480, 0, 38)
State.kunaiTextLabel.Position = UDim2.new(0, 16, 1, -60)
State.kunaiTextLabel.AnchorPoint = Vector2.new(0, 1)
State.kunaiTextLabel.BackgroundTransparency = 1
State.kunaiTextLabel.TextColor3 = Color3.fromRGB(255, 240, 120)
State.kunaiTextLabel.Font = Enum.Font.Code
State.kunaiTextLabel.TextSize = 18
State.kunaiTextLabel.TextXAlignment = Enum.TextXAlignment.Left
State.kunaiTextLabel.TextTransparency = 1
State.kunaiTextLabel.RichText = true
State.kunaiTextLabel.Parent = State.kunaiMessageGui
end
local function isKunaiAttached()
if not State.AntiKickKunaiEnabled then return false end
if not inv then return false end
local kunai = nil
for _, obj in inv:GetChildren() do
if obj.Name == "NinjaKunai" then kunai = obj break end
end
if not kunai or not kunai:FindFirstChild("StickyPart") then return false end
local leg = getRightLeg(plr.Character)
if not leg then return false end
local dist = (kunai.StickyPart.Position - leg.Position).Magnitude
return dist < 7
end
local function attachKunai(isReattach)
cleanupMyKunaiToys()
local char = plr.Character
if not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local rightLeg = getRightLeg(char)
if not rightLeg then return end
local spawnCFrame = hrp.CFrame * CFrame.new(0, 0, -3.5)
task.spawn(function()
pcall(function()
SpawnToy:InvokeServer("NinjaKunai", spawnCFrame, Vector3.new(0, 0, 0))
end)
end)
task.wait(0.1)
local kunai = nil
for i = 1, 15 do
kunai = inv:FindFirstChild("NinjaKunai")
if kunai and kunai:FindFirstChild("StickyPart") then break end
task.wait(0.05)
end
if not kunai or not kunai:FindFirstChild("StickyPart") then
if not isReattach then
task.delay(0.3, function()
if State.AntiKickKunaiEnabled then attachKunai(true) end
end)
end
return
end
local sticky = kunai.StickyPart
for i = 1, 25 do
task.spawn(function()
pcall(function()
local randOffset = CFrame.new(
math.random(-10,10)/100,
math.random(-10,10)/100,
math.random(-8,8)/100
)
SetNetOwner:FireServer(sticky, rightLeg.CFrame * randOffset)
end)
end)
end
local attachCFrame = CFrame.new(0.04, 0.48, 0.02) * CFrame.Angles(0, math.rad(1), math.rad(-90))
for i = 1, 20 do
task.spawn(function()
pcall(function()
StickyEvent:FireServer(sticky, rightLeg, attachCFrame)
end)
end)
end
task.spawn(function()
for _, v in kunai:GetDescendants() do
if v:IsA("BasePart") then
v.Transparency = 0.7
elseif v:IsA("Decal") or v:IsA("Texture") then
v.Transparency = 0.7
end
end
end)
State.currentKunai = kunai
end
DefenceTab:AddToggle({
Name = "Anti Kick Kunai (BETA)",
Description = "Protects against kick kunai attacks",
Callback = function(Value)
State.AntiKickKunaiEnabled = Value
if Value then
createKunaiMessageGui()
attachKunai(false)
if State.kunaiCheckLoop then
task.cancel(State.kunaiCheckLoop)
end
State.kunaiCheckLoop = task.spawn(function()
while State.AntiKickKunaiEnabled do
task.wait(1.5)
if not isKunaiAttached() then
attachKunai(true)
end
end
end)
else
if State.kunaiCheckLoop then
task.cancel(State.kunaiCheckLoop)
State.kunaiCheckLoop = nil
end
cleanupMyKunaiToys()
State.currentKunai = nil
if State.kunaiTextLabel then
State.kunaiTextLabel.Text = ""
State.kunaiTextLabel.TextTransparency = 1
end
end
end
})
DefenceTab:AddToggle({
Name = "Auto Reset",
Description = "Automatically reset when flying",
Callback = function(Value)
State.AutoResetEnabled = Value
if Value then
if State.autoResetConnection then State.autoResetConnection:Disconnect() end
State.autoResetConnection = rs.GameCorrectionEvents.GameCorrectionsNotify.OnClientEvent:Connect(function(r)
if r == "Flying" then
hum:ChangeState("Dead")
end
end)
else
if State.autoResetConnection then
State.autoResetConnection:Disconnect()
State.autoResetConnection = nil
end
end
end
})
DefenceTab:AddToggle({
Name = "Anti Loop Kill",
Description = "Prevents loop kill attacks",
Callback = function(Value)
if Value then
if State.antiKillConn then State.antiKillConn:Disconnect() end
State.antiKillConn = plr.CharacterAdded:Connect(function(ch)
local hrp = ch:WaitForChild("HumanoidRootPart")
hrp.CFrame = CFrame.new(524.7039794921875, 93.71200561523438, -375.0409851074219)
end)
else
if State.antiKillConn then
State.antiKillConn:Disconnect()
State.antiKillConn = nil
end
end
end
})
local BurnExplosionSection = DefenceTab:AddSection({
Name = "Anti Burn & Explosion"
})
local apagarfogo = workspace.Map.Hole.PoisonBigHole:FindFirstChild("ExtinguishPart")
if apagarfogo then
apagarfogo.Size = Vector3.new(0.5, 0.5, 0.5)
apagarfogo.Transparency = 1
if apagarfogo:FindFirstChild("Tex") then
apagarfogo.Tex.Transparency = 1
end
end
DefenceTab:AddToggle({
Name = "Anti Burn",
Description = "Prevents burning attacks",
Callback = function(Value)
State.AntiBurnEnabled = Value
if Value then
if State.antiBurnConnection then State.antiBurnConnection:Disconnect() end
State.antiBurnConnection = RunService.Heartbeat:Connect(function()
local char = plr.Character
if char and char:FindFirstChild("HumanoidRootPart") then
local hrp = char.HumanoidRootPart
local firePlayerPart = hrp:FindFirstChild("FirePlayerPart")
local canBurn = firePlayerPart and firePlayerPart:FindFirstChild("CanBurn")
if canBurn and canBurn.Value then
if apagarfogo then
apagarfogo.CFrame = firePlayerPart.CFrame * CFrame.new(math.random(-1,1), math.random(-1,1), math.random(-1,1))
task.wait()
apagarfogo.Position = Vector3.new(0, -100, 0)
end
end
end
end)
else
if State.antiBurnConnection then
State.antiBurnConnection:Disconnect()
State.antiBurnConnection = nil
end
end
end
})
DefenceTab:AddToggle({
Name = "Anti Explode",
Description = "Prevents explosion attacks",
Callback = function(Value)
if Value then
if State.antiExplodeConn then State.antiExplodeConn:Disconnect() end
State.antiExplodeConn = workspace.ChildAdded:Connect(function(c)
if c.Name == "Part" then
if (c.Position - HRP.Position).Magnitude < 40 and hum.Ragdolled.Value == true then
HRP.Anchored = true
task.wait(0.01)
HRP.Anchored = false
stvel(HRP)
hum:ChangeState(Enum.HumanoidStateType.Running)
end
end
end)
else
if State.antiExplodeConn then
State.antiExplodeConn:Disconnect()
State.antiExplodeConn = nil
end
end
end
})
local VoidLagSection = DefenceTab:AddSection({
Name = "Anti Void & Lag"
})
DefenceTab:AddToggle({
Name = "Anti Void",
Description = "Prevents falling into the void",
Callback = function(Value)
State.AntiVoidEnabled = Value
if Value then
workspace.FallenPartsDestroyHeight = 0/0
else
workspace.FallenPartsDestroyHeight = -100
end
end
})
DefenceTab:AddToggle({
Name = "Anti Lag",
Description = "Reduces lag",
Callback = function(Value)
State.AntiLagEnabled = Value
plr.PlayerScripts.CharacterAndBeamMove.Enabled = not Value
end
})
DefenceTab:AddToggle({
Name = "Auto Anti Lag",
Description = "Automatically detects and reduces lag",
Callback = function(Value)
State.AutoAntiLagEnabled = Value
if Value then
State.autoAntiLagRunning = true
task.spawn(function()
while State.AutoAntiLagEnabled and State.autoAntiLagRunning and task.wait() do
if State.Lines > 100 then
plr.PlayerScripts.CharacterAndBeamMove.Enabled = false
State.Lines = 0
end
end
end)
else
State.autoAntiLagRunning = false
plr.PlayerScripts.CharacterAndBeamMove.Enabled = true
end
end
})
workspace.DescendantAdded:Connect(function(d)
if d.Name == "GrabBeam" then
State.Lines = State.Lines + 1
State.lagger = d.Parent.Parent.Parent
end
end)
local PaintInputSection = DefenceTab:AddSection({
Name = "Anti Paint & Input"
})
DefenceTab:AddToggle({
Name = "Anti Paint",
Description = "Prevents paint attacks",
Callback = function(Value)
if Value then
if State.antiPaintConnection then State.antiPaintConnection:Disconnect() end
State.antiPaintConnection = workspace.DescendantAdded:Connect(function(d)
if d.Name == "PaintPlayerPart" then
task.wait(0.1)
d:Destroy()
end
end)
for i, v in pairs(workspace:GetDescendants()) do
if v.Name == "PainPlayerPart" then
v:Destroy()
end
end
else
if State.antiPaintConnection then
State.antiPaintConnection:Disconnect()
State.antiPaintConnection = nil
end
end
end
})
DefenceTab:AddToggle({
Name = "Anti Input Lag",
Description = "Reduces input delay",
Callback = function(Value)
State.AntiInputLagEnabled = Value
if Value then
State.inputLagRunning = true
local burger = inv:FindFirstChild("FoodCoconut") or spawntoy("FoodCoconut", HRP.CFrame)
if burger then burger.Name = "burger" end
task.spawn(function()
while State.AntiInputLagEnabled and State.inputLagRunning and task.wait() do
task.spawn(function()
if burger then
burger.HoldPart.HoldItemRemoteFunction:InvokeServer(burger, char)
end
end)
task.wait(0.1)
task.spawn(function()
if burger then
burger.HoldPart.DropItemRemoteFunction:InvokeServer(burger, CFrame.new(0, 1e9, 0), Vector3.zero)
end
end)
if (burger and burger.HoldPart.RigidConstraint.Attachment1 and burger.HoldPart.RigidConstraint.Attachment1 ~= char["Left Arm"].LeftGripAttachment) or (not burger or not burger.Parent) then
if inv:FindFirstChild("burger") then
DestroyToy:FireServer(inv.burger)
end
burger = spawntoy("FoodCoconut", HRP.CFrame)
repeat task.wait() until burger
if burger then burger.Name = "burger" end
end
end
end)
else
State.inputLagRunning = false
if inv:FindFirstChild("burger") then
DestroyToy:FireServer(inv.burger)
end
end
end
})
local GucciSection = DefenceTab:AddSection({
Name = "Anti Gucci"
})
DefenceTab:AddToggle({
Name = "Gucci (Invisible)",
Description = "Tractor-based Gucci protection",
Callback = function(Value)
if Value then
pcall(function()
local pal, pal2
pal2 = plr.PlayerGui.MenuGui.Menu.TabContents.ToyDestroy.Contents.ChildAdded:Connect(function(c)
if c.Name == "TractorGreen" then
pal = c
task.wait()
pal2:Disconnect()
end
end)
task.spawn(function()
task.wait(1)
if pal and pal.ViewItemButton then
local mess = pal.ViewItemButton.NewMessage:Clone()
mess.Name = "Gucci2"
mess.TextColor3 = Color3.fromRGB(255, 255, 255)
mess.Text = "Anti Gucci"
mess.Visible = true
mess.Parent = pal.ViewItemButton
end
end)
end)
State.gucciTractorObj = spawntoy("TractorGreen", HRP.CFrame * CFrame.new(5, 5, 20))
if State.gucciTractorObj then State.gucciTractorObj.Name = "tractorgucci" end
repeat task.wait() until State.gucciTractorObj
State.gucciTractorObj:WaitForChild("VehicleSeat", 3):Sit(hum)
task.spawn(function()
local endTime = tick() + 3
while tick() < endTime do
Ragdoll:FireServer(HRP, 0)
task.wait()
end
end)
task.wait()
while State.gucciTractorObj and State.gucciTractorObj.VehicleSeat.Occupant ~= hum do task.wait() end
hum:ChangeState(Enum.HumanoidStateType.Jumping)
sno(State.gucciTractorObj.Part)
task.wait(0.2)
if State.gucciTractorObj then
State.gucciTractorObj.VehicleSeat.CFrame = CFrame.new(0, 0/0, 0)
end
else
if inv:FindFirstChild("tractorgucci") then
DestroyToy:FireServer(inv.tractorgucci)
end
for i = 1, 30 do
hum.Sit = true
task.wait()
hum.Sit = false
end
end
end
})
DefenceTab:AddToggle({
Name = "Gucci (Train)",
Description = "Train-based Gucci protection",
Callback = function(Value)
if Value then
local pos = HRP.CFrame
workspace.Map.AlwaysHereTweenedObjects.Train.Object.ObjectModel.Seat:Sit(hum)
task.spawn(function()
local endTime = tick() + 3
while tick() < endTime do
Ragdoll:FireServer(HRP, 0)
task.wait()
end
end)
task.wait(0.2)
hum:ChangeState(Enum.HumanoidStateType.Jumping)
task.wait(0.2)
HRP.CFrame = pos
else
for i = 1, 30 do
hum.Sit = true
task.wait()
hum.Sit = false
end
end
end
})
DefenceTab:AddToggle({
Name = "Gucci (Blobman)",
Description = "Blobman-based Gucci protection",
Callback = function(Value)
if Value then
pcall(function()
local pal, pal2
pal2 = plr.PlayerGui.MenuGui.Menu.TabContents.ToyDestroy.Contents.ChildAdded:Connect(function(c)
if c.Name == "CreatureBlobman" then
pal = c
task.wait()
pal2:Disconnect()
end
end)
task.spawn(function()
task.wait(1)
if pal and pal.ViewItemButton then
local mess = pal.ViewItemButton.NewMessage:Clone()
mess.Name = "Gucci1"
mess.TextColor3 = Color3.fromRGB(255, 255, 255)
mess.Text = "Anti Gucci"
mess.Visible = true
mess.Parent = pal.ViewItemButton
end
end)
end)
State.gucciBlobmanObj = spawntoy("CreatureBlobman", HRP.CFrame * CFrame.new(5, 5, 20))
repeat task.wait() until State.gucciBlobmanObj
State.gucciBlobmanObj:WaitForChild("VehicleSeat", 3):Sit(hum)
task.spawn(function()
local endTime = tick() + 3
while tick() < endTime do
Ragdoll:FireServer(HRP, 0)
task.wait()
end
end)
task.wait()
while State.gucciBlobmanObj and State.gucciBlobmanObj.VehicleSeat.Occupant ~= hum do task.wait() end
hum:ChangeState(Enum.HumanoidStateType.Jumping)
task.wait()
if State.gucciBlobmanObj then
State.gucciBlobmanObj.VehicleSeat.CFrame = CFrame.new(0, 0/0, 0)
end
else
if inv:FindFirstChild("CreatureBlobman") then
DestroyToy:FireServer(inv.CreatureBlobman)
end
for i = 1, 30 do
hum.Sit = true
task.wait()
hum.Sit = false
end
end
end
})
local function autoGucciFunction()
if not State.AutoGucciBlobEnabled then return end

local currentChar = plr.Character
local currentHum = currentChar and currentChar:FindFirstChild("Humanoid")

local isDead = (not currentHum or currentHum.Health <= 0 or currentHum:GetState() == Enum.HumanoidStateType.Dead)

if isDead then
task.wait(1)
currentChar = plr.Character
currentHum = currentChar and currentChar:FindFirstChild("Humanoid")
if not currentChar or not currentHum then
return
end
end

local blobb
repeat task.wait() until plr.IsHeld == nil or plr.IsHeld.Value == false

local currentChar2 = plr.Character
local currentHum2 = currentChar2 and currentChar2:FindFirstChild("Humanoid")
if not currentChar2 or not currentHum2 then return end

currentHum2.Sit = true
task.wait(0.1)
currentHum2.Sit = false

pcall(function()
local pal, pal2
pal2 = plr.PlayerGui.MenuGui.Menu.TabContents.ToyDestroy.Contents.ChildAdded:Connect(function(c)
if c.Name == "CreatureBlobman" then
pal = c
task.wait()
pal2:Disconnect()
end
end)
task.spawn(function()
task.wait(1)
if pal and pal.ViewItemButton then
local mess = pal.ViewItemButton.NewMessage:Clone()
mess.Name = "Gucci1"
mess.TextColor3 = Color3.fromRGB(255, 255, 255)
mess.Text = "Anti Gucci"
mess.Visible = true
mess.Parent = pal.ViewItemButton
end
end)
end)

if inv:FindFirstChild("autogucci") then
DestroyToy:FireServer(inv.autogucci)
end

local currentHRP = currentChar2:FindFirstChild("HumanoidRootPart")
local currentHum3 = currentChar2:FindFirstChild("Humanoid")

blobb = spawntoy("CreatureBlobman", (currentHRP or HRP).CFrame * CFrame.new(5, 5, 20))
repeat task.wait() until blobb
blobb.Name = "autogucci"

local vehicleSeat = blobb:WaitForChild("VehicleSeat", 3)
if vehicleSeat and currentHum3 then
vehicleSeat:Sit(currentHum3)
end

task.spawn(function()
local endTime = tick() + 3
while tick() < endTime do
Ragdoll:FireServer(currentHRP or HRP, 0)
task.wait()
end
end)

if State.autoGucciConn then State.autoGucciConn:Disconnect() end
State.autoGucciConn = blobb.Destroying:Once(function()
autoGucciFunction()
end)

task.wait()
while blobb.VehicleSeat.Occupant ~= currentHum3 and task.wait() do end
if currentHum3 then
currentHum3:ChangeState(Enum.HumanoidStateType.Jumping)
end
task.wait()

repeat task.wait() sno(blobb.RightDetector) until blobb.Head:FindFirstChild("PartOwner")
task.wait(0.1)
blobb.VehicleSeat.CFrame = CFrame.new(0, 0/0, 0)
end
plr.CharacterAdded:Connect(function(newChar)
task.wait(1)
if State.AutoGucciBlobEnabled then
autoGucciFunction()
end
end)
DefenceTab:AddToggle({
Name = "Auto Gucci (Blobman)",
Description = "Automatically runs Gucci protection (auto-restart on death)",
Callback = function(Value)
State.AutoGucciBlobEnabled = Value
if Value then
State.autoGucciRunning = true
State.autoGucciLoopRunning = true
task.spawn(function()
task.wait(0.5)
autoGucciFunction()
end)
task.spawn(function()
while State.AutoGucciBlobEnabled and State.autoGucciLoopRunning and task.wait(0.5) do
local currentChar = plr.Character
local currentHum = currentChar and currentChar:FindFirstChild("Humanoid")
local isDead = (not currentHum or currentHum.Health <= 0 or currentHum:GetState() == Enum.HumanoidStateType.Dead)

if isDead then
task.wait(1)
elseif hum:GetState() == Enum.HumanoidStateType.Dead or not isnetworkowner(HRP) or not inv:FindFirstChild("autogucci") or (plr.IsHeld and plr.IsHeld.Value) then
autoGucciFunction()
end
end
end)
else
State.autoGucciRunning = false
State.autoGucciLoopRunning = false
if State.autoGucciConn then
State.autoGucciConn:Disconnect()
State.autoGucciConn = nil
end
if inv:FindFirstChild("autogucci") then
DestroyToy:FireServer(inv.autogucci)
end
local currentChar = plr.Character
local currentHum = currentChar and currentChar:FindFirstChild("Humanoid")
if currentHum then
for i = 1, 30 do
currentHum.Sit = true
task.wait()
currentHum.Sit = false
end
end
end
end
})
local UtilitySection = DefenceTab:AddSection({
Name = "Utilities"
})
DefenceTab:AddButton({
Name = "Delete Legs",
Description = "Removes your legs",
Callback = function()
if char:FindFirstChild("Left Leg") and char:FindFirstChild("Right Leg") then
local ll = char:FindFirstChild("Left Leg")
local rl = char:FindFirstChild("Right Leg")
local void = workspace.FallenPartsDestroyHeight
local pos = char.Torso.CFrame
workspace.FallenPartsDestroyHeight = -100
Ragdoll:FireServer(HRP, 2)
task.wait(0.5)
rl.CFrame = CFrame.new(0, -10000, 0)
ll.CFrame = CFrame.new(0, -10000, 0)
task.wait(0.3)
char.Torso.CFrame = CFrame.new(0, -9970, 0)
task.wait(0.5)
char.Torso.CFrame = pos
task.wait(0.5)
workspace.FallenPartsDestroyHeight = void
task.spawn(function()
if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
while task.wait() do
if plr.PlayerGui.ControlsGui.PCFrame.Stand.Visible == false then
hum.HipHeight = 2
else
hum.HipHeight = 0
end
end
end
end)
end
end
})
local function getBlobman()
local tFolder = Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
if tFolder then
local blob = tFolder:FindFirstChild("CreatureBlobman")
if blob then return blob end
end
local plotItems = Workspace:FindFirstChild("PlotItems")
if plotItems then
for _, plot in ipairs(plotItems:GetChildren()) do
local b = plot:FindFirstChild("CreatureBlobman")
if b and b:FindFirstChild("PlayerValue") and b.PlayerValue.Value == plr.Name then
return b
end
end
end
return nil
end
local function spawnBlobmanIfNeeded()
local existing = getBlobman()
if existing then return existing end
local char = plr.Character or plr.CharacterAdded:Wait()
if not char then return nil end
task.spawn(function()
pcall(function()
SpawnToy:InvokeServer("CreatureBlobman", char.Head.CFrame, Vector3.new(0, 0, 0))
end)
end)
for _ = 1, 50 do
local b = getBlobman()
if b then return b end
task.wait(0.05)
end
return nil
end
local function sitOnBlobman(blobman)
if not blobman then return end
local seat = blobman:FindFirstChild("VehicleSeat")
local char = plr.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if seat and hum and not seat.Occupant then
task.wait(0.1)
pcall(function()
seat:Sit(hum)
end)
end
end
local function isSittingOnBlobman()
local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
if not hum then return false end
local blob = getBlobman()
if not blob then return false end
local seat = blob:FindFirstChild("VehicleSeat")
return hum.Sit and hum.SeatPart == seat
end
local function ensureSitBlobman()
local blob = getBlobman()
if not blob then return false end
local seat = blob:FindFirstChild("VehicleSeat")
if not seat then return false end
local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
if hum and not hum.Sit then
seat:Sit(hum)
task.wait(0.6)
end
return isSittingOnBlobman()
end
local function resetBlobmanPhysics(blob)
if not blob then return end
for _, part in blob:GetDescendants() do
if part:IsA("BasePart") then
part.AssemblyLinearVelocity = Vector3.zero
part.AssemblyAngularVelocity = Vector3.zero
end
end
end
local function stabilizeBlobman(blob)
if not blob then return end
local seat = blob:FindFirstChild("VehicleSeat")
if not seat then return end
local char = plr.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if hrp then
seat.CFrame = seat.CFrame + (hrp.CFrame.Position - seat.Position) * 0.1
end
end
local function runAura(withHP, runningFlagGetter)
local hpToggle = false
while runningFlagGetter() do
task.wait(0.01)
local char = plr.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then continue end
local blobman = spawnBlobmanIfNeeded()
if not blobman then continue end
if not isSittingOnBlobman() then ensureSitBlobman() end
local scriptFolder = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
local detector = blobman:FindFirstChild("LeftDetector")
local weld = detector and detector:FindFirstChild("LeftWeld")
if not (scriptFolder and detector and weld) then continue end
local Grab = scriptFolder:FindFirstChild("CreatureGrab")
local Release = scriptFolder:FindFirstChild("CreatureRelease")
local Drop = scriptFolder:FindFirstChild("CreatureDrop")
if not (Grab and Release and Drop) then continue end
hpToggle = not hpToggle
for _, plr in ipairs(Players:GetPlayers()) do
if not runningFlagGetter() then break end
if plr ~= Players.LocalPlayer then
local c = plr.Character
local thrp = c and c:FindFirstChild("HumanoidRootPart")
local hum = c and c:FindFirstChildOfClass("Humanoid")
if thrp and hum and (hrp.Position - thrp.Position).Magnitude <= 30 then
pcall(function()
Grab:FireServer(detector, thrp, weld)
Release:FireServer(weld, thrp)
Drop:FireServer(weld, thrp)
if withHP then hum.Health = hpToggle and 0 or 100 end
end)
end
end
end
end
end
local function runSpeedJumpAura(runningFlagGetter)
while runningFlagGetter() do
task.wait(0.01)
local char = plr.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then continue end
local blobman = spawnBlobmanIfNeeded()
if not blobman then continue end
if not isSittingOnBlobman() then ensureSitBlobman() end
local scriptFolder = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
local detector = blobman:FindFirstChild("LeftDetector")
local weld = detector and detector:FindFirstChild("LeftWeld")
if not (scriptFolder and detector and weld) then continue end
local Grab = scriptFolder:FindFirstChild("CreatureGrab")
local Release = scriptFolder:FindFirstChild("CreatureRelease")
local Drop = scriptFolder:FindFirstChild("CreatureDrop")
if not (Grab and Release and Drop) then continue end
for _, plr in ipairs(Players:GetPlayers()) do
if not runningFlagGetter() then break end
if plr ~= Players.LocalPlayer then
local c = plr.Character
local thrp = c and c:FindFirstChild("HumanoidRootPart")
local hum = c and c:FindFirstChildOfClass("Humanoid")
if thrp and hum and (hrp.Position - thrp.Position).Magnitude <= 30 then
pcall(function()
Grab:FireServer(detector, thrp, weld)
Release:FireServer(weld, thrp)
Drop:FireServer(weld, thrp)
hum.WalkSpeed = State.targetWalkSpeed
hum.JumpPower = State.targetJumpPower
end)
end
end
end
end
end
local function runTPSpamAura(runningFlagGetter)
while runningFlagGetter() do
task.wait(0.01)
local char = plr.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then continue end
local blobman = spawnBlobmanIfNeeded()
if not blobman then continue end
if not isSittingOnBlobman() then ensureSitBlobman() end
local scriptFolder = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
local detector = blobman:FindFirstChild("LeftDetector")
local weld = detector and detector:FindFirstChild("LeftWeld")
if not (scriptFolder and detector and weld) then continue end
local Grab = scriptFolder:FindFirstChild("CreatureGrab")
local Release = scriptFolder:FindFirstChild("CreatureRelease")
local Drop = scriptFolder:FindFirstChild("CreatureDrop")
if not (Grab and Release and Drop) then continue end
for _, plr in ipairs(Players:GetPlayers()) do
if not runningFlagGetter() then break end
if plr ~= Players.LocalPlayer then
local c = plr.Character
local thrp = c and c:FindFirstChild("HumanoidRootPart")
if thrp and (hrp.Position - thrp.Position).Magnitude <= 30 then
pcall(function()
Grab:FireServer(detector, thrp, weld)
Release:FireServer(weld, thrp)
Drop:FireServer(weld, thrp)
thrp.CFrame = CFrame.new(0, 20, 0)
end)
end
end
end
end
end
local function tpAllWithBlobman(runningFlagGetter)
while runningFlagGetter() do
task.wait(0.1)
local char = plr.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then continue end
local blobman = spawnBlobmanIfNeeded()
if not blobman then continue end
if not isSittingOnBlobman() then ensureSitBlobman() end
for _, plr in ipairs(Players:GetPlayers()) do
if not runningFlagGetter() then break end
if plr ~= Players.LocalPlayer then
local c = plr.Character
local thrp = c and c:FindFirstChild("HumanoidRootPart")
if thrp then
pcall(function()
hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, -3)
end)
task.wait(0.2)
end
end
end
end
end
local function updateBlobmanAuraMode()
State.blobmanAuraRunning = State.blobmanAuraEnabled
if State.blobmanAuraEnabled then
if State.blobmanAuraMode == "Kill Aura" then
task.spawn(function() runAura(true, function() return State.blobmanAuraRunning end) end)
elseif State.blobmanAuraMode == "Destroy Aura" then
task.spawn(function() runAura(false, function() return State.blobmanAuraRunning end) end)
elseif State.blobmanAuraMode == "Speed/Jump Control" then
task.spawn(function() runSpeedJumpAura(function() return State.blobmanAuraRunning end) end)
elseif State.blobmanAuraMode == "Teleport Spam" then
task.spawn(function() runTPSpamAura(function() return State.blobmanAuraRunning end) end)
end
end
end
local function updateBlobmanAllMode()
State.blobmanAllRunning = State.blobmanAllEnabled
if State.blobmanAllEnabled then
if State.blobmanAllMode == "All Kill" then
task.spawn(function() runAura(true, function() return State.blobmanAllRunning end) end)
task.spawn(function() tpAllWithBlobman(function() return State.blobmanAllRunning end) end)
elseif State.blobmanAllMode == "All Destroy" then
task.spawn(function() runAura(false, function() return State.blobmanAllRunning end) end)
task.spawn(function() tpAllWithBlobman(function() return State.blobmanAllRunning end) end)
elseif State.blobmanAllMode == "All Speed/Jump" then
task.spawn(function() runSpeedJumpAura(function() return State.blobmanAllRunning end) end)
task.spawn(function() tpAllWithBlobman(function() return State.blobmanAllRunning end) end)
elseif State.blobmanAllMode == "All Teleport Spam" then
task.spawn(function() runTPSpamAura(function() return State.blobmanAllRunning end) end)
task.spawn(function() tpAllWithBlobman(function() return State.blobmanAllRunning end) end)
end
end
end
BlobmanTab:AddSection({
Name = "Aura"
})
BlobmanTab:AddDropdown({
Name = "Select Aura Mode",
Default = "Kill Aura",
Options = {"Kill Aura", "Destroy Aura", "Speed/Jump Control", "Teleport Spam"},
Callback = function(Value)
State.blobmanAuraMode = Value
if State.blobmanAuraEnabled then
State.blobmanAuraRunning = false
task.wait(0.1)
updateBlobmanAuraMode()
end
end
})
BlobmanTab:AddToggle({
Name = "Enable Aura",
Default = false,
Callback = function(Value)
State.blobmanAuraEnabled = Value
updateBlobmanAuraMode()
end
})
BlobmanTab:AddSection({
Name = "Speed/Jump Settings"
})
BlobmanTab:AddSlider({
Name = "Target Walk Speed",
Min = 0,
Max = 500,
Default = 16,
Increment = 1,
Callback = function(Value)
State.targetWalkSpeed = Value
end
})
BlobmanTab:AddSlider({
Name = "Target Jump Power",
Min = 0,
Max = 500,
Default = 50,
Increment = 1,
Callback = function(Value)
State.targetJumpPower = Value
end
})
BlobmanTab:AddSection({
Name = "All"
})
BlobmanTab:AddDropdown({
Name = "Select All Mode",
Default = "All Kill",
Options = {"All Kill", "All Destroy", "All Speed/Jump", "All Teleport Spam"},
Callback = function(Value)
State.blobmanAllMode = Value
if State.blobmanAllEnabled then
State.blobmanAllRunning = false
task.wait(0.1)
updateBlobmanAllMode()
end
end
})
BlobmanTab:AddToggle({
Name = "Enable All Mode",
Default = false,
Callback = function(Value)
State.blobmanAllEnabled = Value
updateBlobmanAllMode()
end
})
BlobmanTab:AddSection({
Name = "Blobman Speed Control"
})
local function moveBlobmanWithCFrame(deltaTime)
local blob = getBlobman()
if not blob or not State.speedBoostActive then return end
local seat = blob:FindFirstChild("VehicleSeat")
if not seat then return end
local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
if not hum then return end
local moveDir = hum.MoveDirection
if moveDir.Magnitude > 0 then
local moveVector = moveDir * State.currentBlobmanSpeed * deltaTime
seat.CFrame = seat.CFrame + moveVector
blob:SetPrimaryPartCFrame(blob:GetPivot() + moveVector)
resetBlobmanPhysics(blob)
stabilizeBlobman(blob)
end
end
local function startSpeedControl()
if State.speedConnection then State.speedConnection:Disconnect() end
if State.speedBoostActive then
State.speedConnection = RunService.Heartbeat:Connect(function(dt)
moveBlobmanWithCFrame(dt)
end)
end
end
local function stopSpeedControl()
if State.speedConnection then
State.speedConnection:Disconnect()
State.speedConnection = nil
end
end
BlobmanTab:AddToggle({
Name = "Blobman Speed",
Default = false,
Callback = function(Value)
State.speedBoostActive = Value
if Value then
spawnBlobmanIfNeeded()
task.wait(0.5)
ensureSitBlobman()
startSpeedControl()
else
stopSpeedControl()
end
end
})
BlobmanTab:AddSlider({
Name = "Blobman Movement Speed",
Min = 0,
Max = 200,
Default = 16,
Increment = 1,
Callback = function(Value)
State.currentBlobmanSpeed = Value
end
})
OrionLib:Init()
