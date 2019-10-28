local composer = require( "composer" )
local image = require("loadImage")
local text = require("text")
local menu = require("menuPause")
local vol = require("volumeSetting")
local score = require("score")

local scene = composer.newScene()

local backgroundSong = audio.loadSound("audio/menu/spacewalk.mp3")

local function gotoSelect()
	composer.gotoScene("fase1", { time=400, effect="crossFade" } )
end

local function gotoGuide()
	composer.gotoScene( "guide", { time=600, effect="crossFade" } )
end	


function scene:create( event )

	local sceneGroup = self.view
	local musicState = true
	local pauseMute = true
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "Background/3/Background.jpg", 530, 570 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
	background.alpha = 0.5

    backGroup = display.newGroup()
	sceneGroup:insert( backGroup )
	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )
	uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )


    local titleGame = display.newText( mainGroup, "Escuridao\n Espacial", display.contentCenterX - 8, display.contentCenterY - 170, "Font/zerovelo.ttf", 34 )
	titleGame:setFillColor( 0.75, 0.78, 1 )

	local playButton = image.loadUi("menu panel",2,uiGroup)
	local guideButton = image.loadUi("menu panel",2,uiGroup)
	playButton:scale(2,1.8)
	playButton.x = display.contentCenterX
	playButton.y = display.contentCenterY + 120
	guideButton:scale(2,1.8)
	guideButton.x = display.contentCenterX
	guideButton.y = playButton.y + 80

	local optionButton = image.loadUi("menu",3,uiGroup)
	
	local playText = display.newText( uiGroup, "Jogar", playButton.x, playButton.y, "Font/prstart.ttf", 25 )
	local guideText = display.newText( uiGroup, "Como Jogar", guideButton.x, guideButton.y, "Font/prstart.ttf", 16 )
	playText:setFillColor( 0.82, 0.86, 1 )
	guideText:setFillColor( 0.82, 0.86, 1 )

	local function statePause()
		if(menu.uiOption.isVisible == true) then
			uiGroup.isVisible = false
		else
			uiGroup.isVisible = true
		end	
	end	

	local function muteState()
		if(menu.muteOn.isVisible == true) then
			pauseMute = false
		end	
		if(menu.muteOn.isVisible == false) then
			if(pauseMute == false) then
				pauseMute = true
				audio.play(backgroundSong, {channel = 1, loops = -1 })
			end	
		end	
	end	

	muteTimer = timer.performWithDelay( 1000, muteState, 0 )
	Runtime:addEventListener( "enterFrame", statePause )
	playButton:addEventListener( "tap", gotoSelect )
	guideButton:addEventListener( "tap", gotoGuide )
	optionButton:addEventListener( "tap", menu.optionMenuShow )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		score.scoreTotal = 0
		if(menu.muteOff.isVisible == true) then
			audio.play(backgroundSong, {channel = 1, loops = -1 })
		end	
		audio.setVolume( vol.music, { channel=1 } )
		score.tentativas = 3
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
		timer.cancel(muteTimer)
		audio.stop( 1 )
		composer.removeScene( "menu" )
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