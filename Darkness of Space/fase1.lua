local composer = require( "composer" )

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed( os.time() )

local lives = 5
local score = 0
local died = false

local bossTable = {}
local gameLoopTimer
local bossLife = 1
local livesText
local scoreText
local pauseTest = 0
local player_attack1
local player_attack2

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local background = display.newImageRect(backGroup ,"/Background/1/back.png", 360, 570)
background.x = display.contentCenterX
background.y = display.contentCenterY

local offsetRectParams = { halfWidth=10, halfHeight=10}

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

local sheet_options_explosionAttack =
{
    width = 512,
    height = 512,
    numFrames = 64
}

local sequences_explosionAttack = {
    {
        name = "standAnimation",
        start = 1,
        count = 64,
        time = 650,
        loopCount = 0,
        loopDirection = "forward"
    }
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
local sheet_explosionAttack = graphics.newImageSheet( "/Sprites/Effects/explosion 3.png", sheet_options_explosionAttack )

-- Primeiro Boss --
local bossMage = display.newSprite(mainGroup, sheet_bossMage, sequences_bossMage)
bossMage.x = display.contentCenterX
bossMage.y = display.contentCenterY - 220
bossMage.myName = "boss"
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

-- UI --
local hp_glass = display.newImageRect(uiGroup, "/UI/Hp/Glass1.png", 18,110 )
hp_glass.x = display.contentCenterX - 135
hp_glass.y = display.contentCenterY + 210
hp_glass.alpha = 0.9


local hp_player = display.newImageRect(uiGroup, "/UI/Hp/Health1.png", 17,110 )
hp_player.x = display.contentCenterX - 135
hp_player.y = display.contentCenterY + 210
hp_player.alpha = 0.6

local menu_pause = display.newImageRect(uiGroup, "/UI/transparentDark12.png", 48,48)
menu_pause.x = display.contentCenterX + 120
menu_pause.y = display.contentCenterY - 250
menu_pause:scale(0.8,0.8)

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

local function bossAttack()
    explosionAttack = display.newSprite(mainGroup ,sheet_explosionAttack, sequences_explosionAttack)
    physics.addBody( explosionAttack, "dynamic", { box=offsetRectParams } )
    explosionAttack.isBullet = true
    explosionAttack.myName = "explosion"
    explosionAttack.x = math.random(25, 295)
    explosionAttack.y = math.random(116, 494)
    transition.to(explosionAttack, {time=500, 
    onComplete = function() display.remove(explosionAttack) end
    })
    explosionAttack:scale(0.4,0.4)
    explosionAttack:play()
end
local function restoreShip()
 
    ship.isBodyActive = false
 
    -- Fade in the ship
    transition.to( ship, { alpha=1, time=4000,
        onComplete = function()
            ship.isBodyActive = true
            died = false
        end
    } )
end

local function endGame()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "ship" and obj2.myName == "flameball" ) or
        ( obj1.myName == "flameball" and obj2.myName == "ship" ) or
        ( obj1.myName == "ship" and obj2.myName == "explosion" ) or
        ( obj1.myName == "explosion" and obj2.myName == "ship" ))
        then
            if ( died == false ) then
                died = true
                lives = lives - 1
                hp_player.height = hp_player.height - 22
                if ( lives == 0 ) then
                    display.remove( ship )
                else
                    ship.alpha = 0.5
                    timer.performWithDelay( 1000, restoreShip )
                end
            end
        end

        if ( ( obj1.myName == "ship" and obj2.myName == "attack1" ) or
        ( obj1.myName == "attack1" and obj2.myName == "ship" ))
        then
            if ( died == false ) then
                died = true
                bossLife = bossLife - 1
                if ( bossLife == 0 ) then
                    bossMage:setSequence("deadMage")
                    bossMage:play()
                    transition.to(bossMage, {time=1000, 
                    onComplete = function() display.remove(bossMage) end
                    })
                    timer.cancel(bossAttack)
                    timer.cancel(bossFire)
                    timer.cancel(gerenation)
                end
            end        
        end
    end    
end

local function pauseGame()
    
    pauseTest = pauseTest + 1
    if (pauseTest == 1) then
    physics.pause()
    timer.pause(bossFire)
    timer.pause(bossAttack)
    timer.pause(bossMove)
    timer.pause(gerenation)
    transition.pause()
    bossMage:pause()
    ship:removeEventListener("touch", dragShip)
        if(explosionAttack.isPlaying == true) then
            explosionAttack:pause()
        end    
    else 
        pauseTest = 0
        physics.start()
        timer.resume(bossFire)
        timer.resume(bossAttack)
        timer.resume(bossMove)
        timer.resume(gerenation)
        transition.resume()
        bossMage:play()
        ship:addEventListener( "touch", dragShip )
        if(explosionAttack.isPlaying == false) then
            explosionAttack:play()
        end
    end    
end

local function generationItem()
    
    local selectItem = math.random(1,2)
    if (selectItem == 1) then
        player_attack1 = display.newImageRect(mainGroup, "/Sprites/Item/damage1.png", 36,37 )
        physics.addBody( player_attack1, "dynamic", { box=offsetRectParams } )
        player_attack1.x = math.random(25, 295)
        player_attack1.y = math.random(116, 494)
        player_attack1.myName = "attack1"
        transition.to(player_attack1, {time=2000, 
        onComplete = function() display.remove(player_attack1) end
        })
    elseif (selectItem == 2) then
        player_attack2 = display.newImageRect(mainGroup, "/Sprites/Item/damage2.png", 46,47 )
        physics.addBody( player_attack2, "dynamic", { box=offsetRectParams } )
        player_attack2.x = math.random(25, 295)
        player_attack2.y = math.random(116, 494)
        player_attack2.myName = "attack2"
        transition.to(player_attack2, {time=2000, 
        onComplete = function() display.remove(player_attack2) end
        })
    end
end


--[[local function gotoSelect()
	composer.gotoScene( "fase1", { time=800, effect="crossFade" } )
end--]]

function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		--audio.play(musicaFundo, {channel = 1, loops = -1 } )
		--som.somTema();
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		--som.onClose();
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

bossFire = timer.performWithDelay( 2000, fireLaser, 0 )
bossAttack = timer.performWithDelay( 1000, bossAttack, 0)
bossMove = timer.performWithDelay( 300, bossMove, 0 )
gerenation = timer.performWithDelay( 4000, generationItem, 0 )
ship:addEventListener( "touch", dragShip )
Runtime:addEventListener( "collision", onCollision )
menu_pause:addEventListener( "tap", pauseGame)

return scene