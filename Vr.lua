local HttpService = game:GetService("HttpService")

local raw = game:HttpGet(
"https://raw.githubusercontent.com/tksuki/Script/refs/heads/main/Vm.lua"
)

local data = HttpService:JSONDecode(raw)

local c = 0

for _,note in ipairs(data.tracks[1].notes) do
    print(note.midi, note.time)

    c = c + 1
    if c >= 10 then break end
end
