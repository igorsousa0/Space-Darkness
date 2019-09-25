local composer = require( "composer" )

local scene = composer.newScene()

local backgroundSong = audio.loadSound("audio/menu/spacewalk.mp3")

local function gotoSelect()
	composer.gotoScene( "fase2", { time=200, effect="crossFade" } )
end


function scene:create( event )

	local sceneGroup = self.view
	local musicState = true
	local musicButton
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "Background/3/Background.jpg", 530, 570 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
	background.alpha = 0.5

    backGroup = display.newGroup()
	sceneGroup:insert( backGroup )
	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )
    local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, display.contentCenterY + 200, native.systemFont, 34 )
	playButton:setFillColor( 0.82, 0.86, 1 )
	
	musicButton = display.newImageRect( sceneGroup, "UI/Menu/flatDark16.png", 40, 40 )
	musicButton.x = display.contentCenterX + 130
	musicButton.y = display.contentCenterY - 245
	musicButton.alpha = 0.8
	musicButton:scale(0.8,0.8)

    local titleGame = display.newText( sceneGroup, "Escuridão Espacial", display.contentCenterX, display.contentCenterY - 180, native.systemFont, 32 )
    titleGame:setFillColor( 0.75, 0.78, 1 )

	local function changeState()
		if (musicState == true) then
			musicState = false
			display.remove(musicButton)
			musicButton = display.newImageRect( sceneGroup, "UI/Menu/flatDark18.png", 40, 40 )
			musicButton.x = display.contentCenterX + 130
			musicButton.y = display.contentCenterY - 245
			musicButton.alpha = 0.8
			musicButton:scale(0.8,0.8)
			audio.pause( 1 )
			musicButton:addEventListener( "tap", changeState )
		else
			musicState = true
			display.remove(musicButton)
			musicButton = display.newImageRect( sceneGroup, "UI/Menu/flatDark16.png", 40, 40 )
			musicButton.x = display.contentCenterX + 130
			musicButton.y = display.contentCenterY - 245
			musicButton.alpha = 0.8
			musicButton:scale(0.8,0.8)
			audio.resume( 1 )
			musicButton:addEventListener( "tap", changeState )
		end		
	end	

	playButton:addEventListener( "tap", gotoSelect )
	musicButton:addEventListener( "tap", changeState )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play(backgroundSong, {channel = 1, loops = -1 } )
		--som.somTema();
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