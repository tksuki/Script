local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== 設定 =====
local GUI_NAME = "AdminPanelGui"
local PANEL_NAME = "AdminPanel"
-- ================

local enabled = true

-- トグルGUI作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminForceToggle"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0,120,0,40)
button.Position = UDim2.new(0,20,0,200)
button.Text = "Admin: ON"
button.BackgroundColor3 = Color3.fromRGB(0,170,0)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
	enabled = not enabled
	
	if enabled then
		button.Text = "Admin: ON"
		button.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		button.Text = "Admin: OFF"
		button.BackgroundColor3 = Color3.fromRGB(170,0,0)
	end
end)

-- 強制表示ループ
RunService.RenderStepped:Connect(function()
	if not enabled then return end
	
	local adminGui = playerGui:FindFirstChild(GUI_NAME)
	
	-- 無かったらStarterGuiからコピー
	if not adminGui then
		local starterGui = game:GetService("StarterGui")
		local original = starterGui:FindFirstChild(GUI_NAME)
		if original then
			adminGui = original:Clone()
			adminGui.Parent = playerGui
		end
	end
	
	if adminGui then
		adminGui.Enabled = true
		
		local panel = adminGui:FindFirstChild(PANEL_NAME, true)
		if panel and panel:IsA("GuiObject") then
			panel.Visible = true
		end
	end
end)
