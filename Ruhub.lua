-- the key saves, click M to unlock mouse/close gui! It may a few seconds to load when first running!

getgenv().RuHubSettings = {
    UnlockMouse = true, -- set to false to stop unlocking mouse
    LoadLastConfig =  false, -- set to true to load your saved config
    RemoveEndGrabEarly = true -- set to false to not remove endgrabearly
}

loadstring(game:HttpGet("https://gitlab.com/cooldawghaha/gitlabswitch/-/raw/main/RuHubFTAP.lua"))()
