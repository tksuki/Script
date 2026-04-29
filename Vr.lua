local HttpService = game:GetService("HttpService")

local raw = game:HttpGet(
"https://raw.githubusercontent.com/tksuki/Script/refs/heads/main/Vm.lua"
)

local data = HttpService:JSONDecode(raw)

local map = {
 [60]="A",
 [61]="W",
 [62]="S",
 [63]="E",
 [64]="D",
 [65]="F",
 [66]="T",
 [67]="G",
 [68]="Y",
 [69]="H",
 [70]="U",
 [71]="J",
 [72]="K"
}

for _,note in ipairs(data.tracks[1].notes) do
    print(map[note.midi])
    break
end
