-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed( os.time() )

local lives = 3
local score = 0
local died = false

local bossTable = {}
local gameLoopTimer
local livesText
local scoreText

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local background = display.newImageRect(backGroup ,"/Background/1/back.png", 360, 570)
background.x = display.contentCenterX
background.y = display.contentCenterY

local sheet_options_ship =
{
    width = 16,
    height = 24,
    numFrames = 10
}

local sheet_options_bossMage =
{
    width = 45,
    height = 51,
    numFrames = 12
}

local sheet_options_flameball =
{
    width = 32,
    height = 32,
    numFrames = 4
}

local sequences_flameball = {
    {
        name = "standAnimation",
        start = 1,
        count = 4,
        time = 650,
        loopCount = 0,
        loopDirection = "forward"
    }
}

local sequences_bossMage = {
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

local sheet_ship = graphics.newImageSheet( "/Sprites/Ship/ship.png", sheet_options_ship )
local sheet_bossMage = graphics.newImageSheet( "/Sprites/Boss/disciple.png", sheet_options_bossMage)
local sheet_flameball = graphics.newImageSheet( "/Sprites/Boss/flameball.png", sheet_options_flameball )

-- Primeiro Boss --
local bossMage = display.newSprite(mainGroup, sheet_bossMage, sequences_bossMage)
bossMage.x = display.contentCenterX
bossMage.y = display.contentCenterY - 220
bossMage:scale(2,2)
bossMage:setSequence("normalMage")
bossMage:play()

-- Nave --
local ship = display.newSprite(mainGroup, sheet_ship, sequences_ship)
ship.x = display.contentCenterX
ship.y = display.contentCenterY + 220
physics.addBody( ship, { radius=30, isSensor=true } )
ship.myName = "ship"
ship:scale(2.5,2.5)
ship:setSequence("normalShip")
ship:play()

-- Função de movimentação da Nave --
local function dragShip( event )
 
    local ship = event.target
    local phase = event.phase

    if ( "began" == phase ) then
        display.currentStage:setFocus(ship)
        ship.touchOffsetX = event.x - ship.x
        ship.touchOffsetY = event.y - ship.y
    elseif ( "moved" == phase ) then
        -- Move the ship to the new touch position
        ship.x = event.x - ship.touchOffsetX
        ship.y = event.y - ship.touchOffsetY 
        if (ship.x < display.contentCenterX) then 
            ship:setSequence("leftShip")
            ship:play()
        elseif (ship.x > display.contentCenterX) then
            ship:setSequence("rightShip")
            ship:play()
        end       
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
        ship:setSequence("normalShip")
        ship:play()    
    end
    
    return true
end

local function bossMove()
    transition.to(bossMage, {time = 4000, x = ship.x})
end

local function fireLaser()
    local flameball = display.newSprite(mainGroup ,sheet_flameball, sequences_flameball)
    physics.addBody( flameball, "dynamic", { isSensor=true } )
    flameball.isBullet = true
    flameball.myName = "flameball"
    flameball.x = bossMage.x
    flameball.y = bossMage.y
    transition.to(flameball, {y=800, time=4000, 
        onComplete = function() display.remove(flameball) end
    }) 
    flameball:scale(1.5,1.5)
    flameball:play()
end

timer.performWithDelay( 2000, fireLaser, 0 )
timer.performWithDelay( 300, bossMove, 0 )
ship:addEventListener( "touch", dragShip )
