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

local image = require("loadImage")
local text = require("text")

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
local hpText
local scoreText
local pauseTest = 0
local player_attack1
local player_attack2
local contadorAttack = 0
local volumeCurrent = 10
local volumeCurrent1 = 10
local volumeMusic = 1
local volemeEffect = 1
local contadorText
local attackCurrent = 0
local attackText
local hp_lost
local hp_boss_lost
local hp_player_lost
local filterCollision = {groupIndex = -1}

local hitboxAttack = 35
local offsetRectParams = { halfWidth=10, halfHeight=10}

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()
local uiPause = display.newGroup()
local uiOption = display.newGroup()

local customParams = {
    hp = 0
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

    local sheet_vortex = graphics.newImageSheet( "Sprites/Effects/Boss02/bossAttack.png", sheet_options_magic )
    local sheet_explosion = graphics.newImageSheet( "Sprites/Effects/Boss02/bossAttack2.png", sheet_options_magic )
    
    -- Segundo Boss --
    local bossMage = image.loadBoss(2,mainGroup)   

    -- Nave --
    local ship = image.loadShip(mainGroup)

    -- UI --
    local hp_glass = image.loadUi("hp",1, uiGroup)

    local hp_player = image.loadUi("hp",2,uiGroup)
    local hp_lost = hp_player.width/hp

    local hp_glass1 = image.loadUi("hp",3,uiGroup)

    local hp_boss = image.loadUi("hp",4,uiGroup)
    local hp_bossLost = hp_boss.width/bossLife

    local menu_pause = image.loadUi("pause",0,uiGroup)

    -- Interface Menu --
    local menu_pause_panel = image.loadUi("menu panel",1,uiPause)

    menu_text_top = text.loadText(1,"top",uiPause)

    local button_resume = image.loadUi("menu panel",2,uiPause)

    local button_option = image.loadUi("menu panel",3,uiPause)

    local button_back = image.loadUi("menu panel",4,uiPause)

    resume_text_button = text.generateText("Retornar",uiPause)
    option_text_button = text.generateText("Opções",uiPause)
    exit_text_button = text.generateText("Sair",uiPause)
    
    resume_text_button.x = button_resume.x
    resume_text_button.y = button_resume.y
    option_text_button.x = button_option.x
    option_text_button.y = button_option.y
    exit_text_button.x = button_back.x
    exit_text_button.y = button_back.y

    contadorText = display.newText(uiGroup,"Dano Acumulado: " .. contadorAttack, ship.x - 90,ship.y + 40, native.systemFont, 15)
    attackText = display.newText(uiGroup,"Dano Atual: " .. attackCurrent, ship.x + 110,ship.y + 40, native.systemFont, 15)
    
    -- Interface Opções --
    local menu_option_panel = image.loadUi("option",1,uiOption)

    menu_option_top = text.loadText(2,"top",uiOption)
    menu_option_top.y = menu_option_panel.y - 120
    local volumePanel = image.loadUi("option",2,uiOption)
    volumePanel.y = menu_option_panel.y - 25
    local volumePanel1 = image.loadUi("option",2,uiOption)
    volumePanel1.y = volumePanel.y + 70

    menu_option_music = text.generateText("Musica",uiOption)
    menu_option_volumeIndicator = text.generateText(10,uiOption)
    menu_option_volumeIndicator1 = text.generateText(10,uiOption)
    
    menu_option_music.x = volumePanel.x 
    menu_option_music.y = volumePanel.y - 30
    menu_option_volumeIndicator.x = volumePanel.x - 54
    menu_option_volumeIndicator.y = volumePanel.y
    menu_option_volumeIndicator1.x = volumePanel1.x - 54
    menu_option_volumeIndicator1.y = volumePanel1.y

    local volumeBar = image.loadUi("option",3,uiOption)
    volumeBar.y = volumePanel.y
    volumeBar.x = volumePanel.x + 20
    local volemeBarCurrent = volumeBar.width/volumeCurrent
    local volumeBar1 = image.loadUi("option",3,uiOption)
    volumeBar1.y = volumePanel1.y 
    volumeBar1.x = volumePanel1.x + 20
    local volumeDown = image.loadUi("option",4,uiOption)
    local volumeDown1 = image.loadUi("option",4,uiOption)
    volumeDown.y = volumePanel.y
    volumeDown.x = volumePanel.x - 85
    volumeDown1.y = volumePanel1.y
    volumeDown1.x = volumePanel1.x - 85
    volumeDown1.myName = "down1"
    local volumeUp = image.loadUi("option",5,uiOption)
    local volumeUp1 = image.loadUi("option",5,uiOption)
    volumeUp.y = volumePanel.y
    volumeUp.x = volumePanel.x + 84
    volumeUp1.y = volumePanel1.y
    volumeUp1.x = volumePanel1.x + 84
    volumeUp1.myName = "up1"
    local volume = volumeBar.width/volumeCurrent
    menu_option_effect = text.generateText("Efeitos",uiOption)
    menu_option_effect.x = volumePanel1.x
    menu_option_effect.y = volumePanel1.y - 30
    local muteOff = image.loadUi("option",7,uiOption)
    muteOff.myName = "muteOff"
    muteOff.x = menu_option_music.x + 40
    muteOff.y = menu_option_music.y 
    local muteOn = image.loadUi("option",8,uiOption)
    muteOn.myName = "muteOn"
    muteOn.x = muteOff.x
    muteOn.y = muteOff.y
    local muteOff1 = image.loadUi("option",7,uiOption)
    muteOff1.myName = "muteOff1"
    muteOff1.x = menu_option_effect.x + 40
    muteOff1.y = menu_option_effect.y 
    local muteOn1 = image.loadUi("option",8,uiOption)
    muteOn1.myName = "muteOn1"
    muteOn1.x = muteOff1.x
    muteOn1.y = muteOff1.y
    local button_back_option = image.loadUi("option",6,uiOption)
    button_back_option.y = menu_option_panel.y + 95
    button_back_option.x = menu_option_panel.x 

    return_text_button = text.generateText("Voltar",uiOption)
    return_text_button.x = button_back_option.x
    return_text_button.y = button_back_option.y
 
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
            if(( event.x > 40 and event.x < display.contentWidth-40) and (event.y > 150 and event.y < display.contentHeight-30)) then
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
                local attack1 = display.newImageRect(mainGroup, "Sprites/Item/damage1.png", 36,37 )
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
                local attack2 = display.newImageRect(mainGroup, "Sprites/Item/damage2.png", 46,47 )
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
            if(muteOff1.isVisible == true) then
                audio.play(shotEffect, {channel = 2} ) 
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

    local function menuGame()
        composer.gotoScene( "menu", { time=800, effect="crossFade" } )
    end   
    
    local function victoryEnd()
        composer.gotoScene( "victory", { time=1400, effect="crossFade", params={hp2 = hp, fase = 2} } )
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
            ( obj1.myName == "explosion" and obj2.myName == "ship" ))
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
                customParams.hp = hp
                transition.to(bossMage, {time=1400, 
                onComplete = function() display.remove(bossMage) victoryEnd() end
                })
            end    
        end 
    end   

    local function menuShow( event ) 
        if (event.target.myName == "uiPause" and uiOption.isVisible == true) then
            uiOption.isVisible = false
        elseif (uiOption.isVisible == true and uiPause.isVisible == false) then
            uiOption.isVisible = false
            uiPause.isVisible = true   
        elseif (uiPause.isVisible == false) then
            uiPause.isVisible = true   
        elseif(uiPause.isVisible == true) then
            uiPause.isVisible = false
        end
    end  

    local function optionShow()
        uiPause.isVisible = false
        uiOption.isVisible = true
    end 

    local function muteChange( event )
        if(event.target.myName == "muteOn" or event.target.myName == "muteOff") then
            if(muteOff.isVisible == true) then
                muteOff.isVisible = false
                muteOn.isVisible = true
                audio.stop(1)
                muteOff:removeEventListener("tap", muteChange)
                muteOn:addEventListener( "tap", muteChange)
            else
                muteOff.isVisible = true
                muteOn.isVisible = false
                muteOn:removeEventListener("tap", muteChange)
                muteOff:addEventListener( "tap", muteChange)   
            end    
        end    
        if(event.target.myName == "muteOn1" or event.target.myName == "muteOff1") then
            if(muteOff1.isVisible == true) then
                muteOff1.isVisible = false
                muteOn1.isVisible = true
                audio.stop(2)
                audio.stop(3)
                muteOff1:removeEventListener("tap", muteChange)
                muteOn1:addEventListener( "tap", muteChange)
            else
                muteOff1.isVisible = true
                muteOn1.isVisible = false
                muteOn1:removeEventListener("tap", muteChange)
                muteOff1:addEventListener( "tap", muteChange)
            end    
        end     
    end    
    
    local function volumeChange(event)
        if(event.target.myName == "down") then
            if(volumeCurrent ~= 0) then
                volumeCurrent = volumeCurrent - 1
                transition.to(volumeBar, { width = volumeBar.width - volume, time=1}) 
                volumeMusic = volumeMusic - 0.1
                audio.setVolume( volumeMusic, { channel=1 } )
                menu_option_volumeIndicator.text = volumeCurrent
            end  
        end
        if(event.target.myName == "up") then
            if(volumeCurrent ~= 10) then
                volumeCurrent = volumeCurrent + 1
                transition.to(volumeBar, { width = volumeBar.width + volume, time=1})  
                volumeMusic = volumeMusic + 0.1
                audio.setVolume( volumeMusic, { channel=1 } )
                menu_option_volumeIndicator.text = volumeCurrent
            end    
        end
        if(event.target.myName == "down1") then
            if(volumeCurrent1 ~= 0) then
                volumeCurrent1 = volumeCurrent1 - 1
                transition.to(volumeBar1, { width = volumeBar1.width - volume, time=1})  
                volemeEffect = volemeEffect - 0.1
                audio.setVolume( volemeEffect, { channel=2})
                audio.setVolume( volemeEffect, { channel=3})
                menu_option_volumeIndicator1.text = volumeCurrent1
            end
        end
        if(event.target.myName == "up1") then
            if(volumeCurrent1 ~= 10) then
                volumeCurrent1 = volumeCurrent1 + 1
                transition.to(volumeBar1, { width = volumeBar1.width + volume, time=1})  
                volemeEffect = volemeEffect + 0.1
                audio.setVolume( volemeEffect, { channel=2})
                audio.setVolume( volemeEffect, { channel=3})
                menu_option_volumeIndicator1.text = volumeCurrent1
            end    
        end
        if(volumeCurrent == 0) then
            volumeBar.width = 0
        end    
        if(volumeCurrent1 == 0) then
            volumeBar1.width = 0
        end   
    end    

    local function pauseGame(event)
    
        pauseTest = pauseTest + 1
        if (pauseTest == 1) then
        physics.pause()
        timer.pause(gerenation)
        timer.pause(vortexAttack)
        transition.pause()
        bossMage:pause()
        ship:removeEventListener("touch", dragShip)
        ship:removeEventListener("tap", attack)
        audio.pause( 1 )
        menuShow( event ) 
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
            bossMage:play()
            ship:addEventListener( "tap", attack )
            ship:addEventListener( "touch", dragShip )
            audio.resume( 1 )  
            menuShow( event )   
            if(uiOption.isVisible == false and uiPause.isVisible == false and muteOff.isVisible == true) then
                audio.play(backgroundSong, {channel = 1, loops = -1 } )
            end 
        end     
    end

    local function generationItem()
    
        local selectItem = math.random(1,2)
        if (selectItem == 1) then
            player_attack1 = display.newImageRect(mainGroup, "Sprites/Item/damage1.png", 36,37 )
            physics.addBody( player_attack1, "dynamic", { box=offsetRectParams, filter = filterCollision } )
            player_attack1.x = math.random(25, 295)
            player_attack1.y = math.random(180, 445)
            player_attack1:toBack()
            player_attack1.myName = "attack1"
            transition.to(player_attack1, {time=2000, 
            onComplete = function() display.remove(player_attack1) end
            })
        elseif (selectItem == 2) then
            player_attack2 = display.newImageRect(mainGroup, "Sprites/Item/damage2.png", 46,47 )
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
            local hitboxExplosion = display.newImageRect(mainGroup, "Sprites/Effects/Boss01/hitbox.png", 46,47 )
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
  
    gerenation = timer.performWithDelay( 3000, generationItem, 0)
    vortexAttack = timer.performWithDelay( 2000, generationAttack, 0)
    ship:addEventListener( "touch", dragShip )
    ship:addEventListener( "tap", attack )
    Runtime:addEventListener( "collision", onCollision )
    menu_pause:addEventListener( "tap", pauseGame)
    button_back:addEventListener( "tap", menuGame)
    button_resume:addEventListener( "tap", pauseGame )
    button_option:addEventListener ( "tap", optionShow)
    volumeDown:addEventListener( "tap", volumeChange)
    volumeDown1:addEventListener( "tap", volumeChange)
    volumeUp:addEventListener( "tap", volumeChange)
    volumeUp1:addEventListener( "tap", volumeChange)
    muteOff:addEventListener( "tap", muteChange)
    muteOff1:addEventListener( "tap", muteChange)
    button_back_option:addEventListener ( "tap", menuShow)

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

    sceneGroup:insert( uiPause )

    sceneGroup:insert ( uiOption )

    uiPause.isVisible = false
    uiOption.isVisible = false
    
    local background = image.loadBackground(2,backGroup)

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
        audio.setVolume( 1, { channel=1 } )
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