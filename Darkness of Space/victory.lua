local composer = require( "composer" )
local image = require("loadImage")
local score = require("score")
local song = require("audioLoad")

local scene = composer.newScene()

--[[local score = 200
local level = 0--]]
local highScoresButton
--scoreCalc = 0

local function nextLevel()
	if (score.level == 1) then
		composer.gotoScene( "fase2", { time=200, effect="crossFade" } )
	elseif (score.level == 2) then
		composer.gotoScene( "fase3", { time=200, effect="crossFade" } )
	elseif (score.level == 3 or score.level == 4) then
		composer.gotoScene( "menu", { time=200, effect="crossFade" } )
	end		
end

local function exitGame()
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

    local background = display.newImageRect(backGroup ,"Background/1/back.png", 360, 570)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local victoryText = display.newText( sceneGroup, "Você Venceu!", display.contentCenterX, display.contentCenterY - 200, "Font/ARCADECLASSIC.TTF", 34 )
	victoryText:setFillColor( 0.82, 0.86, 1 )
	
	highScoresButton = display.newText( sceneGroup, "High Scores: " .. score.getScore() , display.contentCenterX, display.contentCenterY - 100, "Font/prstart.ttf", 15 )
	highScoresButton:setFillColor( 0.75, 0.78, 1 )

	local continueButton = image.loadUi("menu panel",2,mainGroup)
	continueButton.x = display.contentCenterX
	continueButton.y = display.contentCenterY + 120
	continueButton:scale(2,1.8)

	local exitButton = image.loadUi("menu panel",2,mainGroup)
	exitButton.x = continueButton.x
	exitButton.y = continueButton.y + 80
	exitButton:scale(2,1.8)

    local continueText = display.newText( sceneGroup, "Avançar", continueButton.x, continueButton.y, "Font/prstart.ttf", 20 )
	continueText:setFillColor( 0.75, 0.78, 1 )

    local exitText = display.newText( sceneGroup, "Sair", exitButton.x, exitButton.y, "Font/prstart.ttf", 20 )
	exitText:setFillColor( 0.75, 0.78, 1 )

    continueButton:addEventListener( "tap", nextLevel )
	exitButton:addEventListener( "tap", exitGame )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		--[[if(event.params.fase == 1) then
			scoreCalc = score * event.params.hp1
		elseif (event.params.fase == 2) then
			scoreCalc = score * event.params.hp2 + scoreCalc
		elseif (event.params.fase == 3) then
			scoreCalc = score * event.params.hp3 + scoreCalc
		end--]]
		highScoresButton.text = "High Scores: " .. score.getScore()
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