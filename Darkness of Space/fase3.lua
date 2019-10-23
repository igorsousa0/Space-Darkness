local composer = require( "composer" )

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

local image = require("loadImage")
local text = require("text")
local func = require("shipFunction")
local vol = require("volumeSetting")
local menu = require("menuPause")
local score = require("score")
local sound = require("audioLoad")

math.randomseed( os.time() )

local backgroundSong = audio.loadSound("audio/fase03/Dimensions(Main Theme).mp3")
local backgroundSong2 = audio.loadSound("audio/fase03/Orbital Colossus.mp3")
local shotEffect = audio.loadSound("audio/effect/ship/laser.wav")

local hp = 5
local died = false
local bossDied = false

local playerAttack = {}
local attackTest = {}
local gameLoopTimer
local bossLife = 40
local bossLifeDefault = 40
local hpText
local scoreText
local pauseState = false
local contadorAttack = 0
local contadorText
local attackCurrent = 0
local attackText
local hp_lost
local hp_boss_lost
local hp_player_lost
local timerAttack = false
local backgroundMusicChannel
local audioState = false
local timerTest = 0
local attackPause = false
local filterCollision = {groupIndex = -1}

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()
local uiPause = display.newGroup()
local uiOption = display.newGroup()

local hitboxAttack = 35
local offsetRectParams = { halfWidth=10, halfHeight=10}

--[[local customParams = {
    hp = 0
}--]]

local sheet_options_ship =
{
    width = 16,
    height = 24,
    numFrames = 10
}

local sheet_options_bossMage2 = 
{
    width = 87,
    height = 110,
    numFrames = 8
}

local sequences_bossMage = {
    {
        name = "normalMage",
        start = 1,
        count = 8,
        time = 650,
        loopCount = 0,
        loopDirection = "forward"
    }
}

local sheet_options_flameball =
{
    width = 32,
    height = 32,
    numFrames = 4
}

local sheet_options_explosionAttack =
{
    width = 14,
    height = 67,
    numFrames = 24
}

local sequences_explosionAttack = {
    {
        name = "standAnimation",
        frames= { 24, 23, 22, 21, 20, 19, 18, 17 },
        time = 550,
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

    local sheet_ship = graphics.newImageSheet( "Sprites/Ship/ship.png", sheet_options_ship )
    local sheet_bossMage2 = graphics.newImageSheet( "Sprites/Boss/mage-3-87x110.png", sheet_options_bossMage2)
    local sheet_flameball = graphics.newImageSheet( "Sprites/Boss/flameball.png", sheet_options_flameball )
    local sheet_explosion = graphics.newImageSheet( "Sprites/Effects/Boss02/bossAttack2.png", sheet_options_magic )
    local sheet_fire = graphics.newImageSheet( "Sprites/Effects/Boss02/bossAttack3.png", sheet_options_magic )

    -- Terceiro Boss --
    local bossMage = image.loadBoss(3,mainGroup)

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
    menu_option_volumeIndicator = text.generateText(vol.musicCurrent,uiOption)
    menu_option_volumeIndicator1 = text.generateText(vol.effectCurrent,uiOption)
    
    menu_option_music.x = volumePanel.x 
    menu_option_music.y = volumePanel.y - 30
    menu_option_volumeIndicator.x = volumePanel.x - 54
    menu_option_volumeIndicator.y = volumePanel.y
    menu_option_volumeIndicator1.x = volumePanel1.x - 54
    menu_option_volumeIndicator1.y = volumePanel1.y

    local volumeBar = image.loadUi("option",5,uiOption)
    volumeBar.y = volumePanel.y
    volumeBar.x = volumePanel.x + 20
    local volumeBar1 = image.loadUi("option",5,uiOption)
    volumeBar1.y = volumePanel1.y 
    volumeBar1.x = volumePanel1.x + 20
    local volumeDown = image.loadUi("option",6,uiOption)
    local volumeBarLeft = image.loadUi("option",3,uiOption)
    volumeBarLeft.x = volumePanel.x - 85
    volumeBarLeft.y = volumePanel.y
    volumeBarLeft.myName = "down"
    volumeDown:toFront()
    local volumeDown1 = image.loadUi("option",6,uiOption)
    local volumeBarLeft1 = image.loadUi("option",3,uiOption)
    volumeDown1:toFront()
    volumeBarLeft1.x = volumePanel1.x - 85
    volumeBarLeft1.y = volumePanel1.y
    volumeBarLeft1.myName = "down1"
    volumeDown.y = volumePanel.y
    volumeDown.x = volumeBarLeft.x
    volumeDown1.y = volumeBarLeft1.y
    volumeDown1.x = volumeBarLeft1.x
    volumeDown1.myName = "down1"
    local volumeUp = image.loadUi("option",7,uiOption)
    local volumeBarRight = image.loadUi("option",4,uiOption)
    volumeUp:toFront()
    volumeBarRight.x = volumePanel.x + 84
    volumeBarRight.y = volumePanel.y
    volumeBarRight.myName = "up"
    local volumeUp1 = image.loadUi("option",7,uiOption)
    local volumeBarRight1 = image.loadUi("option",4,uiOption)
    volumeUp1:toFront()
    volumeBarRight1.x = volumePanel1.x + 84
    volumeBarRight1.y = volumePanel1.y
    volumeBarRight1.myName = "up1"
    volumeUp.y = volumeBarRight.y
    volumeUp.x = volumeBarRight.x
    volumeUp1.y = volumeBarRight1.y
    volumeUp1.x = volumeBarRight1.x
    menu_option_effect = text.generateText("Efeitos",uiOption)
    menu_option_effect.x = volumePanel1.x
    menu_option_effect.y = volumePanel1.y - 30
    local muteOff = image.loadUi("option",9,uiOption)
    muteOff.myName = "muteOff"
    muteOff.x = menu_option_music.x + 40
    muteOff.y = menu_option_music.y 
    local muteOn = image.loadUi("option",10,uiOption)
    muteOn.myName = "muteOn"
    muteOn.x = muteOff.x
    muteOn.y = muteOff.y
    local muteOff1 = image.loadUi("option",9,uiOption)
    muteOff1.myName = "muteOff1"
    muteOff1.x = menu_option_effect.x + 40
    muteOff1.y = menu_option_effect.y 
    local muteOn1 = image.loadUi("option",10,uiOption)
    muteOn1.myName = "muteOn1"
    muteOn1.x = muteOff1.x
    muteOn1.y = muteOff1.y
    local button_back_option = image.loadUi("option",8,uiOption)
    button_back_option.y = menu_option_panel.y + 95
    button_back_option.x = menu_option_panel.x 

    return_text_button = text.generateText("Voltar",uiOption)
    return_text_button.x = button_back_option.x
    return_text_button.y = button_back_option.y

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

local function bossMove()
    transition.to(bossMage, {time = 4000, x = ship.x})
end

local function fireLaser()
    local attackSelect = math.random(1.0,10.0)
    if (attackPause == true) then
        attackSelect = 0
    end 
    local flameball = display.newSprite(mainGroup ,sheet_flameball, sequences_flameball)
    physics.addBody( flameball, "dynamic", { isSensor=true } )
    flameball.isBullet = true
    flameball.myName = "flameball"
    flameball.x = bossMage.x
    flameball.y = bossMage.y
    if(menu.muteOff1.isVisible == true) then
        audio.play(sound.fireEffect)
    end    
    transition.to(flameball, {x = ship.x, y=800, time=2500, 
        onComplete = function() 
            display.remove(flameball) 
        end
    }) 
    flameball:scale(1.5,1.5)
    flameball:play()
    if (attackSelect >= 5.0) then
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
        explosion:toBack()
        explosion.myName = "explosion"
        transition.to(hitboxExplosion, {time=1000, alpha = 0,
        onComplete = function() display.remove(hitboxExplosion)             
            if (hitboxExplosion.alpha == 0) then
            explosion.isVisible = true
            explosion.isBodyActive = true
            if(menu.muteOff1.isVisible == true) then
                audio.play(sound.explosionEffect)
            end    
            transition.to(explosion, {time=2000,
            onComplete = function() 
                display.remove(explosion) 
            end
            })
        end   end
        })  
    end    
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
            physics.addBody( attack1, "dynamic", { box=offsetRectParams, filter = filterCollision} )
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
            physics.addBody( attack2, "dynamic", { box=offsetRectParams, filter = filterCollision} )
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
        if(menu.muteOff1.isVisible == true) then
            audio.play(sound.shotEffect) 
        end 
        table.remove(playerAttack,1)    
        updateAttackCurrent()
    end          
end
 
local function endGame()
    composer.gotoScene( "fimGame", { time=800, effect="crossFade" } )
end

local function menuGame()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end 

local function victoryEnd()
    if(score.Finalized == false) then
        composer.gotoScene( "cutScene", { time=500, effect="crossFade"})
    else
        composer.gotoScene( "victory", { time=500, effect="crossFade"})
    end    
end    

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "ship" and obj2.myName == "flameball" ) or
        ( obj1.myName == "flameball" and obj2.myName == "ship" ) or
        ( obj1.myName == "ship" and obj2.myName == "explosion" ) or
        ( obj1.myName == "explosion" and obj2.myName == "ship" ) or
        ( obj1.myName == "ship" and obj2.myName == "fire") or
        ( obj1.myName == "fire" and obj2.myName == "ship"))
        then
            if ( died == false ) then
                died = true
                hp = hp - 1
                hp_player_lost = hp_player.width - hp_lost
                transition.to(hp_player, { width = hp_player_lost, time=500})   
                if ( hp == 0 ) then
                    transition.to(ship, {time=500, alpha = 0, 
                    onComplete = function() display.remove(ship) end
                    })
                    score.level = 3
                    score.tentativas = score.tentativas - 1
                    --timer.cancel(hitbox)
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
            display.remove(obj1)
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
            display.remove(obj1)           
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
            if(bossDied == false) then
                bossDied = true
                display.remove(menu_pause)
                --timer.cancel(hitbox)
                timer.cancel(bossFire)
                timer.cancel(gerenation)
                score.level = 3
                score.setScore(hp)
                --customParams.hp = hp
                transition.to(bossMage, {time=1000, 
                onComplete = function() display.remove(bossMage) victoryEnd() end
                })
            end    
        end      
    end    
end

local function optionState()
    if(menu.uiOption.isVisible == true) then
        uiPause.isVisible = false
    elseif (menu.uiOption.isVisible == false and pauseState == true) then
        uiPause.isVisible = true
    end    
end    
  
local function menuShow( event ) 
    if (event.target.myName == "uiPause" and menu.uiOption.isVisible == true) then
        menu.uiOption.isVisible = false
        menu.buttonOption.isVisible = false
    elseif (menu.uiOption.isVisible == true and uiPause.isVisible == false) then
        menu.uiOption.isVisible = false
        menu.buttonOption.isVisible = false
        uiPause.isVisible = true   
    elseif (uiPause.isVisible == false) then
        uiPause.isVisible = true   
    elseif(uiPause.isVisible == true) then
        uiPause.isVisible = false
    end
end   
   

local function pauseGame(event)
    if (pauseState == false) then
        pauseState = true
        physics.pause()
        timer.pause(bossFire)
        timer.pause(gerenation)
        transition.pause()
        bossMage:pause()
        ship:removeEventListener("tap", attack)
        ship:removeEventListener("touch", func.dragShip)
        audio.pause( 1 )
        if(explosionAttack ~= nil) then
            if(explosionAttack.isPlaying == true) then
                explosionAttack:pause()
            end
        end
        menuShow( event )         
    else 
        pauseState = false
        physics.start()
        timer.resume(bossFire)
        timer.resume(gerenation)
        transition.resume()
        bossMage:play()
        ship:addEventListener( "tap", attack )
        ship:addEventListener( "touch", func.dragShip )
        audio.resume( 1 )
        if(explosionAttack ~= nil) then
            if(explosionAttack.isPlaying == false) then
                explosionAttack:play()
            end
        end
        menuShow( event )  
        if(uiOption.isVisible == false and uiPause.isVisible == false and menu.muteOff.isVisible == true) then
            audio.play(fase3_Song, {channel = 1, loops = -1 } )
        end
    end    
end

local function generationItem()
    
    local selectItem = math.random(1,2)
    if (selectItem == 1) then
        local player_attack1 = display.newImageRect(mainGroup, "Sprites/Item/damage1.png", 36,37 )
        physics.addBody( player_attack1, "dynamic", { box=offsetRectParams, filter = filterCollision } )
        player_attack1.x = math.random(25, 295)
        player_attack1.y = math.random(180, 445)
        player_attack1:toBack()
        player_attack1.myName = "attack1"
        transition.to(player_attack1, {time=2000, 
        onComplete = function() display.remove(player_attack1) end
        })
    elseif (selectItem == 2) then
        local player_attack2 = display.newImageRect(mainGroup, "Sprites/Item/damage2.png", 46,47 )
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

local function specialAttack( event )
    if(bossLife <= bossLifeDefault/2) then
        if (audioState == false) then
            transition.to(bossMage, {time = 500, alpha = 0,
            onComplete = function()            
                display.remove ( bossMage )
                bossMage = nil
                bossMage = display.newSprite(mainGroup, sheet_bossMage2, sequences_bossMage)
                bossMage.x = display.contentCenterX
                bossMage.y = display.contentCenterY - 165
                physics.addBody( bossMage, "dynamic", { box=hitboxBoss, filter = 1} )
                bossMage:scale(1.15,1.15)
                bossMage.myName = "boss"
                bossMage:setSequence("normalMage")
                bossMage:play()
            end
            })  
            if(menu.muteOff.isVisible == true) then
                audio.stop( backgroundMusicChannel )
                audio.play(sound.fase3_Song2, {channel = 1, loops = -1 } )
            end    
            timer.cancel(bossFire)
            bossFire = timer.performWithDelay( 1000, fireLaser, 0)
            audioState = true
        end    
        timerAttack = true
        attackPause = true
        if(fire ~= nil) then
            fire.isVisible = true
            fire.isBodyActive = true 
            physics.addBody(fire, "dynamic", {radius=hitboxAttack, filter = filterCollision})
            timerTest = timerTest + 1 
            Runtime:removeEventListener( "enterFrame", specialAttack )
            transition.to(fire, {time = 1000, x = ship.x, y = ship.y,
            onComplete = function() Runtime:addEventListener( "enterFrame", specialAttack ) end
            })   
        end    
        if (timerTest == 30) then
            Runtime:removeEventListener( "enterFrame", specialAttack )
            transition.cancel( fire )
            display.remove( fire )
            attackPause = false
        end  
        print(timerTest)
    end        
end
 
Runtime:addEventListener( "enterFrame", optionState )
Runtime:addEventListener( "enterFrame", specialAttack )
bossFire = timer.performWithDelay( 1300, fireLaser, 0)
gerenation = timer.performWithDelay( 4000, generationItem, 0)
ship:addEventListener( "touch", func.dragShip )
ship:addEventListener( "tap", attack )
Runtime:addEventListener( "collision", onCollision )
menu_pause:addEventListener( "tap", pauseGame)
button_back:addEventListener( "tap", menuGame)
button_resume:addEventListener( "tap", pauseGame )
button_option:addEventListener ( "tap", menu.optionShow)


function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.pause()

    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

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
        if(menu.muteOff.isVisible == true) then
            backgroundMusicChannel = audio.play(sound.fase3_Song, {channel = 1, loops = -1 } )
        end  
        audio.setVolume( vol.music, { channel=1 } )
        for i = 2, 32 do
            audio.setVolume( vol.effect, { channel=i } )  
        end
        volumeBar.width = vol.musicWidth
        volumeBar1.width = vol.effectWidth
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
        if (fire.isVisible == true) then
            transition.cancel( fire )
            display.remove( fire )
        end
        composer.removeScene( "fase3" )
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