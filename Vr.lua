local HttpService = game:GetService("HttpService")

local raw = HttpService:GetAsync(
"https://raw.githubusercontent.com/tksuki/Script/refs/heads/main/Vm.lua"
)

local data = HttpService:JSONDecode(raw)

print("読めた")
