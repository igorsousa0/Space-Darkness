local composer = require( "composer" )
local image = require("src.imagens.loadImage")
local txt = require("src.textos.text")
local sound = require("src.audio.audioLoad")
 
local scene = composer.newScene()

local mainGroup = display.newGroup()
local uiGroup = display.newGroup()
local dialogueGroup = display.newGroup()

 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
for i = 1, 5, 1 do
    local dialogue = txt.loadDialogue(i)
    dialogueGroup:insert(i,dialogue)
    dialogueGroup[i].alpha = 0
end
 
local function gotoMenu()
    timer.cancel(Menu)
    transition.cancel()
    composer.gotoScene( "src.telas.menu", { time=600, effect="crossFade" } )
end    
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    sceneGroup:insert( mainGroup )
    sceneGroup:insert( uiGroup )
    sceneGroup:insert( dialogueGroup )

    local sceneBackground = image.loadBackground(1,mainGroup)
    local planet = image.loadImgScenario(mainGroup)
    planet.y = display.contentCenterY + 60
    local skipButton = image.loadUi("menu panel",2,mainGroup)
    skipButton.x = display.contentCenterX + 90
    skipButton.y = display.contentCenterY + 230
    skipButton:scale(1.1,1.1)
    local skipText = display.newText( mainGroup, "Pular Cena",  skipButton.x, skipButton.y, "Font/prstart.ttf", 9.5 )
    local sceneShip = image.cutSceneShip(mainGroup)
    local dialogPanel = image.loadUi("menu", 1, uiGroup)
    skipText.alpha = 0.8
    skipButton.alpha = 0.5
    dialogPanel.y = display.contentCenterY - 200
    dialogPanel:scale(0.3,0.2)
    dialogPanel.alpha = 0
    sceneShip.x = planet.x
    sceneShip.y = planet.y
    sceneShip:scale(0,0)
    sceneShip:setSequence("normalShip")
    sceneShip:play()

    local playerText = display.newText( uiGroup, "Maxwell", dialogPanel.x , dialogPanel.y - 20, "Font/prstart.ttf", 9.5 )
    local chefeText = display.newText( uiGroup, "Chefe", dialogPanel.x , dialogPanel.y - 20, "Font/prstart.ttf", 9.5 )
    playerText.alpha = 0
    chefeText.alpha = 0
    for i = 1, 5, 1 do
        dialogueGroup[i].x = dialogPanel.x
        dialogueGroup[i].y = dialogPanel.y + 15
    end

    transition.to(dialogPanel, {time=1000,delay = 500, alpha = 0.8})
    transition.to(dialogPanel, {time=1000,delay = 1500, yScale = 1.5,xScale = 2.5})
    transition.to(playerText, {time=1000,delay = 3500, alpha = 1})
    transition.to(dialogueGroup[1], {time=1000,delay = 3500, alpha = 1})
    transition.to(dialogueGroup[1], {time=1000,delay = 7500, alpha = 0,
    onComplete = function() 
        playerText.alpha = 0
        chefeText.alpha = 1
    end
    })
    transition.to(dialogueGroup[2], {time=1000,delay = 8500, alpha = 1})
    transition.to(dialogueGroup[2], {time=1000,delay = 12500, alpha = 0})
    transition.to(dialogueGroup[3], {time=1000,delay = 13500, alpha = 1})
    transition.to(dialogueGroup[3], {time=1000,delay = 18500, alpha = 0,
    onComplete = function() 
        playerText.alpha = 1
        chefeText.alpha = 0
    end
    })
    transition.to(dialogueGroup[4], {time=1000,delay = 19500, alpha = 1})
    transition.to(dialogueGroup[4], {time=1000,delay = 22500, alpha = 0,
    onComplete = function() 
        playerText.alpha = 0
        chefeText.alpha = 1
    end
    })
    transition.to(dialogueGroup[5], {time=1000,delay = 23500, alpha = 1})
    transition.to(dialogueGroup[5], {time=1000,delay = 26500, alpha = 0})
    transition.to(chefeText, {time=1000,delay = 26500, alpha = 0})
    transition.to(dialogPanel, {time=1000,delay = 26500, alpha = 0,
    onComplete = function()
        local ignition = audio.play(sound.ignition)
        audio.stopWithDelay( 1150, { channel=ignition }  )
    end
    })
    transition.to(sceneShip, {time=1000,delay = 27500, xScale = 2.5, yScale = 2.5,
    onComplete = function()
        local launch = audio.play(sound.launch)
    end    
    })
    transition.to(sceneShip, {time=2500,delay = 28500,  y = -255 })

    Menu = timer.performWithDelay( 31000, gotoMenu, 1)
    skipButton:addEventListener( "tap", gotoMenu )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
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
        audio.stop()
        composer.removeScene( "history" )
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