local vol = {}

vol.music = 1
vol.effect = 1
vol.musicCurrent = 10
vol.effectCurrent = 10
vol.musicWidth = 0 
vol.effectWidth = 0
local volume

function vol.updateBar(length,type)
    if(type == "up") then
        return length + volume
    end    
    if(type == "down") then
        return length - volume
    end    
end    

function vol.setWidth(length)
    volume = length/vol.musicCurrent
end

function vol.setGeneralWidth(music,effect)
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