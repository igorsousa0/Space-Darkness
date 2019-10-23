local composer = require( "composer" )
local image = require("loadImage")
local score = require("score")

local scene = composer.newScene()

local function gotoFase3()
	composer.gotoScene( "fase3", { time=200, effect="crossFade" } )
end

local function gotoSelect()
	composer.gotoScene( "menu", { time=200, effect="crossFade" } )
end

function scene:create( event )

	local sceneGroup = self.view
    
    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect(backGroup ,"Background/1/back.png", 360, 570)
    background.x = display.contentCenterX
	background.y = display.contentCenterY

    local lostText = display.newText( sceneGroup, "Você foi derrotado!", display.contentCenterX + 8, display.contentCenterY - 200, "Font/ARCADECLASSIC.TTF", 32 )
	lostText:setFillColor( 0.82, 0.86, 1 )
	
	local tentativasText = display.newText( sceneGroup, "Você possui  " .. score.tentativas .."  tentativas", display.contentCenterX, display.contentCenterY, "Font/ARCADECLASSIC.TTF", 25 )
    tentativasText:setFillColor( 0.82, 0.86, 1 )

	local continueButton = image.loadUi("menu panel",2,uiGroup)
	local exitButton = image.loadUi("menu panel",2,uiGroup)
	continueButton.x = display.contentCenterX
	continueButton.y = display.contentCenterY + 100
	exitButton.x = display.contentCenterX
	exitButton.y = continueButton.y + 80
	continueButton:scale(2,1.8)
	exitButton:scale(2,1.8)
	local continueText = display.newText( sceneGroup, "Continuar", continueButton.x, continueButton.y, "Font/prstart.ttf", 18 )
    continueText:setFillColor( 0.75, 0.78, 1 )
    local exitText = display.newText( sceneGroup, "Sair", exitButton.x, exitButton.y, "Font/prstart.ttf", 20 )
	exitText:setFillColor( 0.75, 0.78, 1 )
	tentativasText.isVisible = false
	continueButton.isVisible = false
	continueText.isVisible = false
	if(score.level == 3) then
		tentativasText.isVisible = true
		continueButton.isVisible = true
		continueText.isVisible = true
	end	
	if(score.tentativas == 0) then
		--continueButton:removeEventListener( "tap", gotoFase3 )
		continueButton.alpha = 0.4
		continueText.alpha = 0.5
	end	
 
	--continueButton:addEventListener( "tap", gotoFase3 )
    exitButton:addEventListener( "tap", gotoSelect )
	
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
		composer.removeScene( "fimGame" )
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