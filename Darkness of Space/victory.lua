local composer = require( "composer" )

local scene = composer.newScene()

local function gotoSelect()
	composer.gotoScene( "menu", { time=200, effect="crossFade" } )
end

function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup ) 
    
    local background = display.newImageRect(backGroup ,"/Background/1/back.png", 360, 570)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local victoryText = display.newText( sceneGroup, "Você Venceu!", display.contentCenterX, display.contentCenterY - 200, native.systemFont, 34 )
    victoryText:setFillColor( 0.82, 0.86, 1 )
 
    local highScoresButton = display.newText( sceneGroup, "High Scores:", display.contentCenterX, display.contentCenterY - 100, native.systemFont, 20 )
    highScoresButton:setFillColor( 0.75, 0.78, 1 )

    local continueButton = display.newText( sceneGroup, "Avançar", display.contentCenterX, display.contentCenterY + 100, native.systemFont, 20 )
    continueButton:setFillColor( 0.75, 0.78, 1 )

    continueButton:addEventListener( "tap", gotoSelect )
	
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

return scene