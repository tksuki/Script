local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local menuToysFolder = ReplicatedStorage:WaitForChild("MenuToys")
local SpawnToyRF = menuToysFolder:WaitForChild("SpawnToyRemoteFunction")
local DeleteToyRE = menuToysFolder:WaitForChild("DestroyToy")

local grabEventsFolder = ReplicatedStorage:WaitForChild("GrabEvents")
local setNetworkOwnerEvent = grabEventsFolder:WaitForChild("SetNetworkOwner")

local function waitForChild(parent, childName, timeout)
    local startTime = tick()
    while tick() - startTime < timeout do
        local child = parent:FindFirstChild(childName)
        if child then return child end
        task.wait(0.1)
    end
    return nil
end

local function SetNetworkOwner(part, cf)
    if not part or not part.Parent then return end
    pcall(function()
        setNetworkOwnerEvent:FireServer(part, cf)
    end)
end

local function SetBarrierCollision(state)
    for _, v in ipairs(Workspace.Plots:GetChildren()) do
        local barrier = v:FindFirstChild("Barrier")
        if barrier then
            for _, p in ipairs(barrier:GetChildren()) do
                if p:IsA("BasePart") then p.CanCollide = state end
            end
        end
    end
end

local function ExecuteBarrierDestroyer()
    local player = LocalPlayer
    local playerName = player.Name

    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end

    local originalPosition = player.Character.HumanoidRootPart.CFrame

    SpawnToyRF:InvokeServer(
        "FoodHamburger",
        player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0),
        Vector3.new(0, 34, 0)
    )

    task.wait(0.3)

    local toyFolder = waitForChild(Workspace, playerName .. "SpawnedInToys", 3)
    if not toyFolder then return false end

    local hamburger = waitForChild(toyFolder, "FoodHamburger", 3)
    if not hamburger then return false end

    local holdPart = waitForChild(hamburger, "HoldPart", 2)
    if not holdPart then return false end

    task.wait(0.1)
    holdPart.HoldItemRemoteFunction:InvokeServer(hamburger, Workspace[playerName])
    task.wait(0.3)

    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end

    player.Character.HumanoidRootPart.CFrame = CFrame.new(-521.46, 12.27, -175.27)
    task.wait(0.15)

    if hamburger and hamburger.Parent then
        pcall(function() DeleteToyRE:FireServer(hamburger) end)
    end
    task.wait(0.15)

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = originalPosition
    end

    SetBarrierCollision(false)

    task.wait(0.5)

    SpawnToyRF:InvokeServer("FireExtinguisher", player.Character.HumanoidRootPart.CFrame, Vector3.zero)
    task.wait(0.2)

    local extinguisher = waitForChild(toyFolder, "FireExtinguisher", 2)
    if not extinguisher then return false end

    local soundPart = extinguisher:FindFirstChild("SoundPart")
    if not soundPart then
        pcall(function() DeleteToyRE:FireServer(extinguisher) end)
        return false
    end

    SetNetworkOwner(soundPart, player.Character.HumanoidRootPart.CFrame)
    soundPart.CFrame = CFrame.new(-521.46, 12.27, -175.27)
    task.wait(2)

    if extinguisher and extinguisher.Parent then
        pcall(function() DeleteToyRE:FireServer(extinguisher) end)
    end

    return true
end

SetBarrierCollision(false)
local success = ExecuteBarrierDestroyer()
if not success then
    task.wait(0.5)
    ExecuteBarrierDestroyer()
end
