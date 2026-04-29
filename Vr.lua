local HttpService = game:GetService("HttpService")

local raw = game:HttpGet(
"https://raw.githubusercontent.com/tksuki/Script/refs/heads/main/Vm.lua"
)

local data = HttpService:JSONDecode(raw)

print(data.header.ppq)
print(#data.tracks)
