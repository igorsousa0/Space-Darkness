local composer = require( "composer" )
local image = require("loadImage")
 
local scene = composer.newScene()

local backGroup = display.newGroup()
local scene1 = display.newGroup()
local scene2 = display.newGroup()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    sceneGroup:insert( scene1 ) 
 
    sceneGroup:insert( scene2 )

    local scene1background = image.loadBackground(2,scene1)
    local scene2background = image.loadBackground(1,scene2)

    scene2.isVisible = false
    scene2.alpha = 0

    --local bossMage = image.loadBoss(4,scene1)

    local scene1Ship = image.loadShip(scene1)
    scene1Ship:setSequence("normalShip")
    scene1Ship:play()   
    local planet = image.loadImgScenario(scene2)
    local scene2Ship = image.loadShip(scene2)
    scene2Ship.y = 580
    scene2Ship:setSequence("normalShip")
    scene2Ship:play() 
    transition.to(scene1Ship, {time=4000,delay = 1000, y = -800,
    onComplete = function() 
        display.remove(scene1Ship)
    end    
    }) 
    transition.to(scene1, {time=1000,delay = 4000, alpha = 0,
    onComplete = function() 
        scene2.isVisible = true
    end 
    }) 
    transition.to(scene2, {time=1000,delay = 5000, alpha = 1})
    transition.to(scene2Ship, {time=2500,delay = 6000, y = 255,
    onComplete = function() 
        --display.remove(scene2Ship)
    end    
    })
    transition.to(scene2Ship, {time=2000,delay = 7000, xScale = 0, yScale = 0,
    onComplete = function() 
        --display.remove(scene2Ship)
    end    
    })
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