local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

math.randomseed( os.time() )

local backgroundSong = audio.loadSound("audio/fase02/boss02.mp3")
local shotEffect = audio.loadSound("audio/effect/ship/laser.wav")
local fireEffect = audio.loadSound("audio/effect/mage01/fire.wav")
local explosionEffect = audio.loadSound("audio/effect/mage01/explosion.wav")

local hp = 5
local died = false

local playerAttack = {}
local gameLoopTimer
local bossLife = 20
local bossLifeDefault = 10
local hpText
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
local timerAttack = false
local timerTest = 0
local attackPause = false
local filterCollision = {groupIndex = -1}

local hitboxAttack = 35
local hitboxBoss = { halfWidth=48, halfHeight=55}
local offsetRectParams = { halfWidth=10, halfHeight=10}

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local customParams = {
    hp = 0
}

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

local sheet_options_boss = 
{
    width = 120,
    height = 100,
    numFrames = 20,
}

local sequences_boss = {
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

local sheet_options_magic = 
{
    width = 100,
    height = 100,
    numFrames = 64,
}

local sequences_magic = 
    {
        name = "normalAnimation",
        start = 1,
        count = 61,
        time = 1000,
        loopCount = 0,
        loopDirection = "forward"
    }
  

    local sheet_ship = graphics.newImageSheet( "/Sprites/Ship/ship.png", sheet_options_ship )
    local sheet_boss = graphics.newImageSheet( "/Sprites/Boss/boss2.png", sheet_options_boss )
    local sheet_vortex = graphics.newImageSheet( "/Sprites/Effects/Boss02/bossAttack.png", sheet_options_magic )
    local sheet_explosion = graphics.newImageSheet( "/Sprites/Effects/Boss02/bossAttack2.png", sheet_options_magic )
    local sheet_fire = graphics.newImageSheet( "/Sprites/Effects/Boss02/bossAttack3.png", sheet_options_magic )

    -- Segundo Boss --
    local bossMage = display.newSprite(mainGroup, sheet_boss, sequences_boss)
    bossMage.x = display.contentCenterX
    bossMage.y = display.contentCenterY - 190
    physics.addBody( bossMage, "dynamic", { box=hitboxBoss, filter = filterCollision } )
    bossMage.myName = "boss"
    bossMage:scale(1.4,1.4)
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
    local hp_lost = hp_player.width/hp
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

    -- Ataque Teste --
    local fire = display.newSprite(mainGroup, sheet_fire, sequences_magic)
    fire:setSequence("normalAnimation")
    fire:play()
    fire.myName = "fire"
    fire.x = display.contentCenterX
    fire.y = display.contentCenterY
    fire:scale(1.5,1.5)
    fire.isVisible = false
    fire.isBodyActive = false

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
            print(ship.y)
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
                audio.play(shotEffect, {channel = 2} ) 
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
                audio.play(shotEffect, {channel = 2} )  
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

    --[[local function verificarHP()
        if ( bossLife <= 6) then
            bossMage:setSequence("normalMage")
            bossMage:play()
            transition.to(bossMage, {time=800, 
            onComplete = function() bossMage:pause() end
            })
            local fire = display.newSprite(mainGroup, sheet_fire, sequences_magic)
            physics.addBody( fire, { box=offsetRectParams } )
            fire:setSequence("normalAnimation")
            fire:play()
            fire:scale(1.5,1.5)
            fire.x = ship.x
            fire.y = ship.y
            fire:toBack()
            print("Test")
        end          
    end  --]]

    local function endGame()
        composer.gotoScene( "fimGame", { time=800, effect="crossFade" } )
    end
    
    local function victoryEnd()
        composer.gotoScene( "victory", { time=1800, effect="crossFade", params={hp2 = hp, fase = 2} } )
    end
    
    local function onCollision( event )
 
        if ( event.phase == "began" ) then
     
            local obj1 = event.object1
            local obj2 = event.object2
    
            if ( ( obj1.myName == "ship" and obj2.myName == "vortex1" ) or
            ( obj1.myName == "vortex1" and obj2.myName == "ship" ) or
            ( obj1.myName == "ship" and obj2.myName == "vortex2") or
            ( obj1.myName == "vortex2" and obj2.myName == "ship") or
            ( obj1.myName == "ship" and obj2.myName == "explosion" ) or
            ( obj1.myName == "explosion" and obj2.myName == "ship" ) or
            ( obj1.myName == "ship" and obj2.myName == "fire") or
            ( obj1.myName == "fire" and obj2.myName == "ship"))
            then
                if ( died == false ) then
                    died = true
                    hp = hp - 1
                    hp_player_lost = hp_player.width - hp_lost
                    transition.to(hp_player, { width = hp_player_lost, time=500,})   
                    if ( hp == 0 ) then
                        transition.to(ship, {time=500, alpha = 0, 
                        onComplete = function() display.remove(ship) end
                        })
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
            end     
            if ( bossLife <= 0) then
                bossMage:setSequence("deadMage")
                bossMage:play()
                print(bossLife)
                if (fire.isVisible == true) then
                    transition.cancel( fire )
                    display.remove( fire )
                end
                customParams.hp = hp
                transition.to(bossMage, {time=1400, 
                onComplete = function() display.remove(bossMage) victoryEnd() end
                })
            end    
        end 
    end   
    
    local function pauseGame()
    
        pauseTest = pauseTest + 1
        if (pauseTest == 1) then
        physics.pause()
        timer.pause(gerenation)
        timer.pause(vortexAttack)
        transition.pause()
        bossMage:pause()
        ship:removeEventListener("touch", dragShip)
        Runtime:removeEventListener( "enterFrame", specialAttack )
        audio.pause( 1 )
        if(explosionAttack ~= nil) then
            if(explosionAttack.isPlaying == true) then
                explosionAttack:pause()
            end
        end           
        else 
            pauseTest = 0
            physics.start()
            timer.resume(gerenation)
            timer.resume(vortexAttack)
            transition.resume()
            ship:addEventListener( "touch", dragShip )
            bossMage:play()
            ship:addEventListener( "touch", dragShip )
            audio.resume( 1 )    
        end     
    end

    local function generationItem()
    
        local selectItem = math.random(1,2)
        if (selectItem == 1) then
            player_attack1 = display.newImageRect(mainGroup, "/Sprites/Item/damage1.png", 36,37 )
            physics.addBody( player_attack1, "dynamic", { box=offsetRectParams, filter = filterCollision } )
            player_attack1.x = math.random(25, 295)
            player_attack1.y = math.random(180, 445)
            player_attack1:toBack()
            player_attack1.myName = "attack1"
            transition.to(player_attack1, {time=2000, 
            onComplete = function() display.remove(player_attack1) end
            })
        elseif (selectItem == 2) then
            player_attack2 = display.newImageRect(mainGroup, "/Sprites/Item/damage2.png", 46,47 )
            physics.addBody( player_attack2, "dynamic", { box=offsetRectParams, filter = filterCollision } )
            player_attack2.x = math.random(25, 295)
            player_attack2.y = math.random(180, 445)
            player_attack2:toBack()
            player_attack2.myName = "attack2"
            transition.to(player_attack2, {time=2000, 
            onComplete = function() display.remove(player_attack2) end
            })
        end
    end

    local function generationAttack() 
        local attackSelect = math.random(1,2)
        if (attackPause == true) then
            attackSelect = 2
        end    
        if (attackSelect == 1) then
            local selectDirection = math.random(1,2)
            if (selectDirection == 1) then
                vortex = display.newSprite(mainGroup, sheet_vortex, sequences_magic)
                physics.addBody( vortex, "dynamic", { radius=hitboxAttack, filter = filterCollision } )
                vortex:setSequence("normalAnimation")
                vortex:play() 
                vortex.x = 20
                vortex.y = 150
                vortex:toBack()
                vortex.myName = "vortex1"
                transition.to(vortex, {time=1000, x = ship.x, y = ship.y,
                onComplete = function() display.remove(vortex) end
                })
            elseif (selectDirection == 2) then
                vortex2 = display.newSprite(mainGroup, sheet_vortex, sequences_magic)
                physics.addBody( vortex2, "dynamic", { radius=hitboxAttack, filter = filterCollision } )
                vortex2:setSequence("normalAnimation")
                vortex2:play() 
                vortex2.x = 290
                vortex2.y = 150
                vortex2:toBack()
                vortex2.myName = "vortex2"
                transition.to(vortex2, {time=1000, x = ship.x, y = ship.y,
                onComplete = function() display.remove(vortex2) end
                })
            end 
        elseif (attackSelect == 2) then
            local explosion = display.newSprite(mainGroup, sheet_explosion, sequences_magic)
            local hitboxExplosion = display.newImageRect(mainGroup, "/Sprites/Effects/Boss01/hitbox.png", 46,47 )
            physics.addBody(explosion, "dynamic", {radius=hitboxAttack, filter = filterCollision})
            explosion:setSequence("normalAnimation")
            explosion:play()
            hitboxExplosion.x = math.random(25, 295) 
            hitboxExplosion.y = math.random(156, 454)
            explosion.x = hitboxExplosion.x
            explosion.y = hitboxExplosion.y
            explosion.isVisible = false
            explosion.isBodyActive = false
            --[[explosion.x = math.random(25, 295) 
            explosion.y = math.random(116, 494)--]]
            explosion:toBack()
            explosion.myName = "explosion"
            transition.to(hitboxExplosion, {time=1000, alpha = 0,
            onComplete = function() display.remove(hitboxExplosion)             
                if (hitboxExplosion.alpha == 0) then
                explosion.isVisible = true
                explosion.isBodyActive = true
                transition.to(explosion, {time=2000,
                onComplete = function() display.remove(explosion) end
                })
            end   end
            })  
            --[[transition.to(explosion, {time=2000,
            onComplete = function() display.remove(explosion) end
            })--]]
        end    
    end
  
    local function specialAttack( event )
        if(bossLife <= bossLifeDefault/2) then
            timerAttack = true
            attackPause = true
            fire.isVisible = true
            fire.isBodyActive = true
            physics.addBody(fire, "dynamic", {radius=hitboxAttack, filter = filterCollision})
            timerTest = timerTest + 1 
            Runtime:removeEventListener( "enterFrame", specialAttack )
            transition.to(fire, {time = 1000, x = ship.x, y = ship.y,
            onComplete = function() Runtime:addEventListener( "enterFrame", specialAttack ) end
            })   
            if (timerTest == 30) then
                Runtime:removeEventListener( "enterFrame", specialAttack )
                transition.cancel( fire )
                display.remove( fire )
                attackPause = false
            end  
            print(timerTest)
        end        
    end

    Runtime:addEventListener( "enterFrame", specialAttack )
    gerenation = timer.performWithDelay( 3000, generationItem, 0)
    vortexAttack = timer.performWithDelay( 2000, generationAttack, 0)
    ship:addEventListener( "touch", dragShip )
    ship:addEventListener( "tap", attack )
    Runtime:addEventListener( "collision", onCollision )
    menu_pause:addEventListener( "tap", pauseGame)
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    
    sceneGroup:insert( backGroup )  
 
    sceneGroup:insert( mainGroup )  

    sceneGroup:insert( uiGroup )
    
    local background = display.newImageRect( backGroup, "Background/2/backTest.jpg", 530, 570 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background.alpha = 0.6
    
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
        audio.play(backgroundSong, {channel = 1, loops = -1 })
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener( "collision", onCollision )
        Runtime:removeEventListener( "touch", dragShip )
        Runtime:removeEventListener( "tap", attack )
        Runtime:removeEventListener( "tap", pauseGame)
        timer.cancel(vortexAttack)
        timer.cancel(gerenation)  
        if (fire.isVisible == true) then
            transition.cancel( fire )
            display.remove( fire )
        end
        physics.pause()
        composer.removeScene( "fase2" )
        audio.stop( 1 )
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