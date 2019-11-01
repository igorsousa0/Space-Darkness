local vol = {}

vol.music = 1
vol.effect = 1
vol.musicCurrent = 10
vol.effectCurrent = 10
vol.musicWidth = 64
vol.effectWidth = 64
local volume = 64/vol.musicCurrent

function vol.updateBar(length,type)
    if(type == "up") then
        return length + volume
    end    
    if(type == "down") then
        return length - volume
    end    
end    

function vol.setGeneral(music,effect)
    vol.musicWidth = music
    vol.effectWidth = effect
end

function vol.getMusic()
    return vol.musicWidth
end   

function vol.getEffect()
    return vol.effectWidth
end    
return vol