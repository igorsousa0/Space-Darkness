local composer = require( "composer" )
local image = require("loadImage")
local text = require("text")

local scene = composer.newScene()

local backgroundSong = audio.loadSound("audio/menu/spacewalk.mp3")

local function gotoSelect()
	composer.gotoScene( "fase1", { time=200, effect="crossFade" } )
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
	guideGroup = display.newGroup()
	sceneGroup:insert( guideGroup )
	guideUiGroup = display.newGroup()
	sceneGroup:insert( guideUiGroup )

    local titleGame = display.newText( mainGroup, "Escuridão Espacial", display.contentCenterX, display.contentCenterY - 180, "Font/ARCADECLASSIC.TTF", 32 )
    titleGame:setFillColor( 0.75, 0.78, 1 )

	local playButton = image.loadUi("menu panel",2,mainGroup)
	local guideButton = image.loadUi("menu panel",2,mainGroup)
	playButton:scale(2,1.8)
	playButton.x = display.contentCenterX
	playButton.y = display.contentCenterY + 120
	guideButton:scale(2,1.8)
	guideButton.x = display.contentCenterX
	guideButton.y = playButton.y + 80
	
	local playText = display.newText( mainGroup, "Jogar", playButton.x, playButton.y, "Font/prstart.ttf", 25 )
	local guideText = display.newText( mainGroup, "Como Jogar", guideButton.x, guideButton.y, "Font/prstart.ttf", 16 )
	playText:setFillColor( 0.82, 0.86, 1 )
	guideText:setFillColor( 0.82, 0.86, 1 )
	
	musicButton = display.newImageRect( mainGroup, "UI/Menu/flatDark16.png", 40, 40 )
	musicButton.x = display.contentCenterX + 130
	musicButton.y = display.contentCenterY - 245
	musicButton.alpha = 0.8
	musicButton:scale(0.8,0.8)

	local guidePanel = image.loadUi("menu",1,guideGroup)
	guideGroup.isVisible = false
	guideGroup.alpha = 0

	local buttonBack = image.loadUi("menu panel",2,guideGroup)
	buttonBack.x = guidePanel.x
	buttonBack.y = guidePanel.y + 190
	buttonBack:scale(1.5,1.5)

	local buttonBackText = text.generateTextMenu("Voltar",guideGroup,buttonBack.x,buttonBack.y,"Font/prstart.ttf",20)
	local guideTopText = text.generateTextMenu("Como  Jogar",guideGroup,display.contentCenterX,display.contentCenterY - 220,"Font/ARCADECLASSIC.TTF",32)
	local moveShipText = text.generateTextMenu("Movimentação",guideUiGroup,guidePanel.x,guidePanel.y - 130,"Font/prstart.ttf",15)
	local shipImg = image.loadImgShip(guidePanel.x,guidePanel.y,guideUiGroup,"img")
	local touchIcon = image.loadUi("menu",2,guideUiGroup)
	guideUiGroup.isVisible = false
	guideUiGroup.alpha = 0

	local function changeState()
		if(guideGroup.isVisible == false) then
			transition.to(mainGroup, {time=500, alpha = 0,
			onComplete = function() 
				mainGroup.isVisible = false
				guideGroup.isVisible = true
			end
			})
			transition.to( guideGroup, { time=500, delay=500, alpha = 1,
			onComplete = function() 
				guideUiGroup.isVisible = true
			end	
			})
			transition.to( guideUiGroup, { time=500, delay=1000, alpha = 1
			})
			transition.to( touchIcon, { time=800, delay=1200, y = shipImg.y
		})
		else
		transition.to(guideGroup, {time=500, alpha = 0,
		onComplete = function() 
			guideGroup.isVisible = false
			mainGroup.isVisible = true
		end
		})
		transition.to( guideUiGroup, { time=500, alpha = 0,
		onComplete = function() 
			touchIcon.y = display.contentCenterY - 30
		end	
		})
		transition.to( mainGroup, { time=500, delay=1000, alpha = 1,
		onComplete = function()
			guideUiGroup.isVisible = false
		end	
		})
		end	
		--[[if (musicState == true) then
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
		end	--]]	
	end	

	playButton:addEventListener( "tap", gotoSelect )
	--musicButton:addEventListener( "tap", changeState )
	guideButton:addEventListener( "tap", changeState )
	buttonBackText:addEventListener( "tap", changeState )

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