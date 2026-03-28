local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local enabled = false

-- GUI作成
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0,150,0,50)
button.Position = UDim2.new(0,20,0,100)
button.Text = "Auto Prompt: OFF"
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
	enabled = not enabled
	button.Text = enabled and "Auto Prompt: ON" or "Auto Prompt: OFF"
end)

-- 自動検出ループ
RunService.RenderStepped:Connect(function()
	if not enabled then return end
	
	for _, prompt in pairs(workspace:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local distance = (char.HumanoidRootPart.Position - prompt.Parent.Position).Magnitude
				
				if distance <= prompt.MaxActivationDistance then
					fireproximityprompt(prompt)
				end
			end
		end
	end
end)
