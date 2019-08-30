local composer = require( "composer" )

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

math.randomseed( os.time() )

local lives = 5
local score = 0
local died = false

local playerAttack = {}
local gameLoopTimer
local bossLife = 20
local livesText
local scoreText
local pauseTest = 0
local player_attack1
local player_attack2
local contadorAttack = 0
local contadorText
local attackCurrent = 0
local attackText
local hp_lost
local hp_boss_lost
local hp_player_lost

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()


local offsetRectParams = { halfWidth=10, halfHeight=10}
local hitboxBoss = { halfWidth=38, halfHeight=51}


--[[local function gotoSelect()
	composer.gotoScene( "fase1", { time=800, effect="crossFade" } )
end--]]

function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.pause()

    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup ) 

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
    bossMage.y = display.contentCenterY - 200
    physics.addBody( bossMage, "dynamic", { box=hitboxBoss } )
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
    local hp_glass = display.newImageRect(uiGroup, "/UI/Hp/2/Glass3.png", 120,18 )
    hp_glass.x = display.contentCenterX - 90
    hp_glass.y = display.contentCenterY - 260
    hp_glass.alpha = 0.9

    local hp_player = display.newImageRect(uiGroup, "/UI/Hp/2/Health3.png", 110,15 )
    local hp_lost = hp_player.width/lives
    hp_player.x = display.contentCenterX - 90
    hp_player.y = display.contentCenterY - 260
    hp_player.alpha = 0.6

    local hp_glass1 = display.newImageRect(uiGroup, "/UI/Hp/2/Glass2.png", 120,18 )
    hp_glass1.x = display.contentCenterX + 40
    hp_glass1.y = display.contentCenterY - 260
    hp_glass1.alpha = 0.9

    local hp_boss = display.newImageRect(uiGroup, "/UI/Hp/2/Health2.png", 110,15 )
    local hp_bossLost = hp_boss.width/bossLife
    hp_boss.x = display.contentCenterX + 40
    hp_boss.y = display.contentCenterY - 260
    hp_boss.alpha = 0.6

    local menu_pause = display.newImageRect(uiGroup, "/UI/transparentDark12.png", 40,40)
    menu_pause.x = display.contentCenterX + 130
    menu_pause.y = display.contentCenterY - 255
    menu_pause:scale(0.8,0.8)

    contadorText = display.newText(uiGroup,"Dano Acumulado: " .. contadorAttack, ship.x - 90,ship.y + 50, native.systemFont, 15)
    attackText = display.newText(uiGroup,"Dano Atual: " .. attackCurrent, ship.x + 110,ship.y + 50, native.systemFont, 15)
    
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
        if (ship.x < display.contentCenterX) then 
            ship:setSequence("leftShip")
            ship:play()
        elseif (ship.x > display.contentCenterX) then
            ship:setSequence("rightShip")
            ship:play()
        end
        if(( event.x > 40 and event.x < display.contentWidth-40) and (event.y > 30 and event.y < display.contentHeight-30)) then
            ship.x = event.x - ship.touchOffsetX
            ship.y = event.y - ship.touchOffsetY
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
    explosionAttack.x = hitboxExplosion.x
    explosionAttack.y = hitboxExplosion.y
    transition.to(explosionAttack, {time=500, 
    onComplete = function() display.remove(explosionAttack) end
    })
    explosionAttack:scale(0.4,0.4)
    explosionAttack:play()
end
local function restoreShip()
 
    ship.isBodyActive = false
 
    -- Fade in the ship
    transition.to( ship, { alpha=1, time=2000,
        onComplete = function()
            ship.isBodyActive = true
            died = false
        end
    } )
end

local function restoreBoss()
    
    bossMage.isBodyActive = false
    -- Fade in the ship
    transition.to( bossMage, { alpha=1, time=500,
        onComplete = function()
            bossMage.isBodyActive = true
        end
    } )
end


local function updateAttackCurrent()
    for k,v in pairs(playerAttack) do
        if (k == 1 and v == "attack1") then
            attackCurrent = 1
        elseif (k == 1 and v == "attack2") then
            attackCurrent = 3
        end    
        attackText.text = "Dano Atual: " .. attackCurrent   
    end
end  

local function attack()
    if (playerAttack[1] ~= nil) then
        if (playerAttack[1] == "attack1") then
            local attack1 = display.newImageRect(mainGroup, "/Sprites/Item/damage1.png", 36,37 )
            physics.addBody( attack1, "dynamic", { box=offsetRectParams } )
            attack1.isBullet = true
            attack1.x = ship.x
            attack1.y = ship.y
            attack1.myName = "attack3"
            contadorAttack = contadorAttack - 1
            contadorText.text = "Dano Acumulado: " .. contadorAttack 
            transition.to(attack1, {time=1000, y = bossMage.y, 
            onComplete = function() display.remove(attack1) end
            })
        elseif (playerAttack[1] == "attack2") then
            local attack2 = display.newImageRect(mainGroup, "/Sprites/Item/damage2.png", 46,47 )
            physics.addBody( attack2, "dynamic", { box=offsetRectParams } )
            attack2.isBullet = true
            attack2.x = ship.x
            attack2.y = ship.y
            attack2.myName = "attack4"
            contadorAttack = contadorAttack - 3
            contadorText.text = "Dano Acumulado: " .. contadorAttack 
            transition.to(attack2, {time=1000, y = bossMage.y, 
            onComplete = function() display.remove(attack2) end
            })
        end  
        if (contadorAttack == 0) then
            attackCurrent = 0
            attackText.text = "Dano Atual: " .. attackCurrent
        end
        table.remove(playerAttack,1)    
        updateAttackCurrent()
    end          
end
 
local function endGame()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function victoryEnd()
    composer.gotoScene( "fimFase", { time=800, effect="crossFade" } )
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
                hp_player_lost = hp_player.width - hp_lost
                transition.to(hp_player, { width = hp_player_lost, time=500,})
                if ( lives == 0 ) then
                    display.remove( ship )
                    timer.cancel(hitbox)
                    timer.cancel(bossFire)
                    timer.cancel(gerenation)
                    timer.performWithDelay( 2000, endGame )
                else
                    ship.alpha = 0.5
                    timer.performWithDelay( 1000, restoreShip )
                end
            end
        end

        if (( obj1.myName == "ship" and obj2.myName == "attack1" ) or
        (obj1.myName == "attack1" and obj2.myName == "ship"))
        then
            --bossLife = bossLife - 1
            contadorAttack = contadorAttack + 1
            contadorText.text = "Dano Acumulado: " .. contadorAttack
            table.insert(playerAttack, "attack1")
            updateAttackCurrent()
            display.remove(player_attack1)
            --hp_boss.width = hp_boss.width - hp_bossLost      
        end
        if ( ( obj1.myName == "ship" and obj2.myName == "attack2" ) or
        ( obj1.myName == "attack2" and obj2.myName == "ship" ))
        then
            --bossLife = bossLife - 3
            contadorAttack = contadorAttack + 3
            contadorText.text = "Dano Acumulado: " .. contadorAttack
            table.insert(playerAttack, "attack2")
            updateAttackCurrent()
            display.remove(player_attack2)           
        end
        if ( ( obj1.myName == "boss" and obj2.myName == "attack3" ) or
        ( obj1.myName == "attack3" and obj2.myName == "boss" )) 
        then
            bossLife = bossLife - 1
            if (bossMage.isBodyActive == true) then
                hp_boss_lost = hp_boss.width - hp_bossLost
            end     
            bossMage.alpha = 0.5
            timer.performWithDelay( 1000, restoreBoss ) 
            transition.to(hp_boss, { width = hp_boss_lost, time=500,}) 
            if (obj1.myName == "attack3") then
                display.remove(obj1)
            else
                display.remove(obj2)
            end 
            print(bossLife)        
        end
        if ( ( obj1.myName == "boss" and obj2.myName == "attack4" ) or
        ( obj1.myName == "attack4" and obj2.myName == "boss" )) 
        then
            bossLife = bossLife - 3
            if (bossMage.isBodyActive == true) then
                hp_boss_lost = hp_boss.width - (hp_bossLost * 3)
            end    
            bossMage.alpha = 0.5
            timer.performWithDelay( 1000, restoreBoss ) 
            transition.to(hp_boss, { width = hp_boss_lost, time=500,})
            if (obj1.myName == "attack4") then
                display.remove(obj1)
            else
                display.remove(obj2)
            end 
            print(bossLife) 
        end
        if ( bossLife <= 0) then
            bossMage:setSequence("deadMage")
            bossMage:play()
            timer.cancel(hitbox)
            timer.cancel(bossFire)
            timer.cancel(gerenation)
            transition.to(bossMage, {time=1000, 
            onComplete = function() display.remove(bossMage) victoryEnd() end
            })
        end      
    end    
end

local function pauseGame()
    
    pauseTest = pauseTest + 1
    if (pauseTest == 1) then
    physics.pause()
    timer.pause(bossFire)
    timer.pause(hitbox)
    timer.pause(bossMove)
    timer.pause(gerenation)
    transition.pause()
    bossMage:pause()
    ship:removeEventListener("touch", dragShip)
    if(explosionAttack ~= nil) then
        if(explosionAttack.isPlaying == true) then
            explosionAttack:pause()
        end
    end        
    else 
        pauseTest = 0
        physics.start()
        timer.resume(bossFire)
        timer.resume(hitbox)
        timer.resume(bossMove)
        timer.resume(gerenation)
        transition.resume()
        bossMage:play()
        ship:addEventListener( "touch", dragShip )
        if(explosionAttack ~= nil) then
            if(explosionAttack.isPlaying == false) then
                explosionAttack:play()
            end
        end    
    end    
end

local function generationItem()
    
    local selectItem = math.random(1,2)
    if (selectItem == 1) then
        player_attack1 = display.newImageRect(mainGroup, "/Sprites/Item/damage1.png", 36,37 )
        physics.addBody( player_attack1, "dynamic", { box=offsetRectParams } )
        player_attack1.x = math.random(25, 295)
        player_attack1.y = math.random(220, 494)
        player_attack1:toBack()
        player_attack1.myName = "attack1"
        transition.to(player_attack1, {time=2000, 
        onComplete = function() display.remove(player_attack1) end
        })
    elseif (selectItem == 2) then
        player_attack2 = display.newImageRect(mainGroup, "/Sprites/Item/damage2.png", 46,47 )
        physics.addBody( player_attack2, "dynamic", { box=offsetRectParams } )
        player_attack2.x = math.random(25, 295)
        player_attack2.y = math.random(220, 494)
        player_attack2:toBack()
        player_attack2.myName = "attack2"
        transition.to(player_attack2, {time=2000, 
        onComplete = function() display.remove(player_attack2) end
        })
    end
end

local function hitboxAttack()
    hitboxExplosion = display.newImageRect(mainGroup, "/Sprites/Effects/hitbox.png", 46,47 )
    physics.addBody( hitboxExplosion, "dynamic", { box=offsetRectParams } )
    hitboxExplosion.myName = "hitexplosion"
    hitboxExplosion.x = math.random(25, 295)
    hitboxExplosion.y = math.random(116, 494)
    transition.to(hitboxExplosion, {alpha = 0, time=500, 
    onComplete = function() display.remove(hitboxExplosion) bossAttack() end
    })
    hitboxExplosion:scale(0.6,0.6)
end  

    bossFire = timer.performWithDelay( 2000, fireLaser, 0)
    hitbox = timer.performWithDelay( 2000, hitboxAttack, 0)
    bossMove = timer.performWithDelay( 300, bossMove, 0 )
    gerenation = timer.performWithDelay( 4000, generationItem, 0)
    ship:addEventListener( "touch", dragShip )
    ship:addEventListener( "tap", attack )
    Runtime:addEventListener( "collision", onCollision )
    menu_pause:addEventListener( "tap", pauseGame)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
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
        Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
        composer.removeScene( "fase1" )
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

return scene