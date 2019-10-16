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

math.randomseed( os.time() )

local backgroundSong = audio.loadSound("audio/fase01/magicspace.mp3")
local shotEffect = audio.loadSound("audio/effect/ship/laser.wav")
local fireEffect = audio.loadSound("audio/effect/mage01/fire.wav")
audio.setVolume( 0.5, { channel=2 } )
audio.setVolume( 1, { channel= 3} )

local hp = 5
local died = false

local playerAttack = {}
local gameLoopTimer
local bossLife = 20
local hpText
local scoreText
local difficulty = 50
local TimerAttack = 2000
local TimerMove = 300
local pauseState = false
local contadorAttack = 0
local contadorText
local attackCurrent = 0
local attackText
local hp_lost
local hp_boss_lost
local hp_player_lost
local filterCollision = {groupIndex = -1}

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()
local uiPause = display.newGroup()
local uiOption = display.newGroup()



local offsetRectParams = { halfWidth=10, halfHeight=10}

local customParams = {
    hp = 0
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

local sheet_flameball = graphics.newImageSheet( "Sprites/Boss/flameball.png", sheet_options_flameball )
local sheet_explosionAttack = graphics.newImageSheet( "Sprites/Effects/Boss01/explosion.png", sheet_options_explosionAttack )

-- Primeiro Boss --
local bossMage = image.loadBoss(1,mainGroup)

-- Nave --
local ship = image.loadShip(mainGroup)

-- UI --
local hp_glass = image.loadUi("hp",1, uiGroup)

local hp_player = image.loadUi("hp",2,uiGroup)
local hp_lost = hp_player.width/hp

local hp_glass1 = image.loadUi("hp",3,uiGroup)

local hp_boss = image.loadUi("hp",4,uiGroup)
local hp_bossLost = hp_boss.width/bossLife

local menu_pause = image.loadUi("pause",1,uiGroup)

contadorText = display.newText(uiGroup,"Dano Acumulado: " .. contadorAttack, ship.x - 90,ship.y + 40, native.systemFont, 15)
attackText = display.newText(uiGroup,"Dano Atual: " .. attackCurrent, ship.x + 110,ship.y + 40, native.systemFont, 15)
    
-- Interface Menu --
local menu_pause_panel = image.loadUi("menu panel",1,uiPause)

menu_text_top = text.loadText(1,"top",uiPause)

local button_resume = image.loadUi("menu panel",2,uiPause)

local button_option = image.loadUi("menu panel",3,uiPause)

button_back = image.loadUi("menu panel",4,uiPause)

resume_text_button = text.generateText("Retornar",uiPause)
option_text_button = text.generateText("Opções",uiPause)
exit_text_button = text.generateText("Sair",uiPause)
    
resume_text_button.x = button_resume.x
resume_text_button.y = button_resume.y
option_text_button.x = button_option.x
option_text_button.y = button_option.y
exit_text_button.x = button_back.x
exit_text_button.y = button_back.y

local function bossMove()
    transition.to(bossMage, {time = 3500, x = ship.x})
end

local function fireLaser()
    local flameball = display.newSprite(mainGroup ,sheet_flameball, sequences_flameball)
    physics.addBody( flameball, "dynamic", { isSensor=true } )
    flameball.isBullet = true
    flameball.myName = "flameball"
    flameball.x = bossMage.x
    flameball.y = bossMage.y   
    transition.to(flameball, {x = ship.x, y=800, time=2000, 
    onComplete = function() 
        display.remove(flameball) 
    end
    }) 
    if(menu.muteOff1.isVisible == true) then
        audio.play(fireEffect)
    end 
    flameball:scale(1.5,1.5)
    flameball:play()
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
            local attack1 = image.loadItem(1,mainGroup)
            physics.addBody( attack1, "dynamic", { box=offsetRectParams, filter = filterCollision} )
            attack1.isBullet = true
            attack1.myName = "attack3"
            attack1.x = ship.x
            attack1.y = ship.y
            contadorAttack = contadorAttack - 1
            contadorText.text = "Dano Acumulado: " .. contadorAttack  
            transition.to(attack1, {time=1000, y = bossMage.y, 
            onComplete = function() display.remove(attack1) end
            })
        elseif (playerAttack[1] == "attack2") then
            local attack2 = image.loadItem(2,mainGroup)
            physics.addBody( attack2, "dynamic", { box=offsetRectParams, filter = filterCollision} )
            attack2.isBullet = true
            attack2.myName = "attack4"
            attack2.x = ship.x
            attack2.y = ship.y
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
            audio.play(shotEffect) 
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
    composer.gotoScene( "victory", { time=1100, effect="crossFade", params= {hp1 = hp, fase = 1} } )
end    

local function difficultyModify(type)
    if(TimerAttack > 1000) then
        if(type == "attack3") then
            bossFire._delay = bossFire._delay - difficulty 
        else 
            bossFire._delay = bossFire._delay - (difficulty * 3) 
        end   
        bossMove._delay = bossMove._delay - 10 
    end    
end    

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "ship" and obj2.myName == "flameball" ) or
        ( obj1.myName == "flameball" and obj2.myName == "ship" ) )
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
            --func.addTable("attack1")
            table.insert(playerAttack, "attack1")
            updateAttackCurrent(contadorAttack)
            contadorText.text = "Dano Acumulado: " .. contadorAttack
            display.remove(obj1)
            --hp_boss.width = hp_boss.width - hp_bossLost      
        end
        if ( ( obj1.myName == "ship" and obj2.myName == "attack2" ) or
        ( obj1.myName == "attack2" and obj2.myName == "ship" ))
        then
            --bossLife = bossLife - 3
            contadorAttack = contadorAttack + 3
            --func.addTable("attack2")
            table.insert(playerAttack, "attack2")
            updateAttackCurrent(contadorAttack)
            contadorText.text = "Dano Acumulado: " .. contadorAttack
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
                difficultyModify(obj1.myName)
                display.remove(obj1)
            else
                difficultyModify(obj2.myName)
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
                difficultyModify(obj1.myName)
                display.remove(obj1)
            else
                difficultyModify(obj2.myName)
                display.remove(obj2)
            end
        end
        if ( bossLife <= 0) then
            display.remove(menu_pause)
            bossMage:setSequence("deadMage")
            bossMage:play()
            print(bossLife)
            timer.cancel(bossFire)
            timer.cancel(gerenation)
            customParams.hp = hp
            transition.to(bossMage, {time=1000, 
            onComplete = function() display.remove(bossMage) victoryEnd() end
            })
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


local function pauseGame( event )
    if (pauseState == false) then
        pauseState = true
        physics.pause()
        timer.pause(bossFire)
        timer.pause(bossMove)
        timer.pause(gerenation)
        transition.pause()
        bossMage:pause()
        ship:removeEventListener("tap", attack)
        ship:removeEventListener("touch", func.dragShip)
        audio.pause( 1 )
        menuShow( event ) 
    if(explosionAttack ~= nil) then
        if(explosionAttack.isPlaying == true) then
            explosionAttack:pause()
        end
    end        
    else 
        pauseState = false 
        physics.start()
        timer.resume(bossFire)
        timer.resume(bossMove)
        timer.resume(gerenation)
        transition.resume()
        bossMage:play()
        ship:addEventListener( "tap", attack )
        ship:addEventListener("touch", func.dragShip )
        audio.resume( 1 )
        menuShow( event )
        if(menu.uiOption.isVisible == false and uiPause.isVisible == false and menu.muteOff.isVisible == true) then
            audio.play(backgroundSong, {channel = 1, loops = -1 } )
        end 
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

    Runtime:addEventListener( "enterFrame", optionState )
    bossFire = timer.performWithDelay( TimerAttack, fireLaser, 0)
    bossMove = timer.performWithDelay( TimerMove, bossMove, 0 )
    gerenation = timer.performWithDelay( 4000, generationItem, 0)
    ship:addEventListener( "touch", func.dragShip )
    ship:addEventListener( "tap", attack )
    Runtime:addEventListener( "collision", onCollision )
    menu_pause:addEventListener( "tap", pauseGame)
    button_resume:addEventListener ("tap", pauseGame)
    button_option:addEventListener ( "tap", menu.optionShow)
    button_back:addEventListener( "tap", menuGame)

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

    local background = image.loadBackground(1,backGroup)

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
            audio.play(backgroundSong, {channel = 1, loops = -1 } )
        end    
        audio.setVolume( vol.music, { channel=1 } )
        audio.setVolume( vol.effect, { channel=2 } )
        audio.setVolume( vol.effect, { channel=3 } )
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
        audio.stop( 1 )
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