local sprite = {}

local sheet_options_ship =
{
    width = 16,
    height = 24,
    numFrames = 10
}

local sequences_ship = {
    {
        name = "normalShip",
        frames = {3,8},
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "leftShip",
        frames = {7,6},
        time = 400,
        loopCount = 0,
        loopDirection = "forward"


    },
    {
        name = "rightShip",
        frames = {9,10},
        time = 400,
        loopCount = 0,
        loopDirection = "forward"


    }
}

local sheet_ship = graphics.newImageSheet( "Sprites/Ship/ship.png", sheet_options_ship )

function sprite.loadPlayer(group)
    return display.newSprite(group, sheet_ship, sequences_ship)
end    

return sprite