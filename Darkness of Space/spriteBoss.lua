local sprite = {}

local sheet_options_boss1 =
{
    width = 45,
    height = 51,
    numFrames = 12
}

local sequences_boss1 = {
    {
        name = "normalMage",
        start = 1,
        count = 4,
        time = 650,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "deadMage",
        start = 1,
        count = 12,
        time = 1200,
        loopCount = 0,
        loopDirection = "forward"


    }
}

local sheet_options_boss2 = 
{
    width = 120,
    height = 100,
    numFrames = 20,
}

local sequences_boss2 = {
    {
        name = "normalMage",
        start = 1,
        count = 5,
        time = 650,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "deadMage",
        start = 1,
        count = 17,
        time = 1400,
        loopCount = 0,
        loopDirection = "forward"
    }
}

local sheet_options_boss3 =
{
    width = 85,
    height = 94,
    numFrames = 8
}

local sequences_boss3 = {
    {
        name = "normalMage",
        start = 1,
        count = 8,
        time = 650,
        loopCount = 0,
        loopDirection = "forward"
    }
}

local sheet_options_boss4 = 
{
    width = 87,
    height = 110,
    numFrames = 8
}

local sheet_boss1 = graphics.newImageSheet( "Sprites/Boss/disciple.png", sheet_options_boss1)
local sheet_boss2 = graphics.newImageSheet( "Sprites/Boss/boss2.png", sheet_options_boss2 )
local sheet_boss3 = graphics.newImageSheet( "Sprites/Boss/mage1.png", sheet_options_boss3)
local sheet_boss4 = graphics.newImageSheet( "Sprites/Boss/mage-3-87x110.png", sheet_options_boss4)

function sprite.loadBoss(level,group)
    if(level == 1) then
        return display.newSprite(group,sheet_boss1,sequences_boss1)
    end   
    if(level == 2) then
        return display.newSprite(group,sheet_boss2,sequences_boss2)
    end  
    if(level == 3) then
        return display.newSprite(group,sheet_boss3,sequences_boss3) 
    end    
    if(level == 4) then
        return display.newSprite(group,sheet_boss4,sequences_boss3)
    end
end    

return sprite