local HttpService = game:GetService("HttpService")

local raw = game:HttpGet(
"https://raw.githubusercontent.com/tksuki/Script/refs/heads/main/Vm.lua"
)

local data = HttpService:JSONDecode(raw)

for _,note in ipairs(data.tracks[1].notes) do
    print(note.midi, note.time)
    break
end
