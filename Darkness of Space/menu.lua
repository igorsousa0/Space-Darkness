local composer = require( "composer" )
local image = require("loadImage")
local text = require("text")

local scene = composer.newScene()

local backgroundSong = audio.loadSound("audio/menu/spacewalk.mp3")

local function gotoSelect()
	composer.gotoScene( "fase1", { time=400, effect="crossFade" } )
end

local options = {
    text = "Toque e arraste a nave\n para movimentar",
	fontSize = 12.5,
	font = "Font/prstart.ttf",
    align = "center"
}

local options1 = {
    text = "Toque na nave para\n atirar",
	fontSize = 12.5,
	font = "Font/prstart.ttf",
    align = "center"
}


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
	guideUiGroup1 = display.newGroup()
	sceneGroup:insert( guideUiGroup1 )

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

	local buttonNext = image.loadUi("menu panel",2,guideGroup)
	buttonNext.x = buttonBack.x
	buttonNext.y = buttonBack.y - 60
	buttonNext:scale(1.5,1.5)

	local buttonBackText = text.generateTextMenu("Voltar",guideGroup,buttonBack.x,buttonBack.y,"Font/prstart.ttf",20)
	local buttonNextText = text.generateTextMenu("Próximo",guideGroup,buttonNext.x,buttonNext.y,"Font/prstart.ttf",18)
	local guideTopText = text.generateTextMenu("Como  Jogar",guideGroup,display.contentCenterX,display.contentCenterY - 220,"Font/ARCADECLASSIC.TTF",32)
	local moveShipText = text.generateTextMenu("Movimentação",guideUiGroup,guidePanel.x,guidePanel.y - 130,"Font/prstart.ttf",15)
	local shotShipText = text.generateTextMenu("Atirar",guideUiGroup1,guidePanel.x,guidePanel.y - 130,"Font/prstart.ttf",15)
	local shipImg = image.loadImgShip(guidePanel.x,guidePanel.y,guideUiGroup,"img")
	local shipImg1 = image.loadImgShip(guidePanel.x,guidePanel.y + 45,guideUiGroup1,"img")
	local moveGuideText = display.newText( options )
	local shotGuideText = display.newText( options1 )
	moveGuideText.x = shipImg.x + 4
	moveGuideText.y = shipImg.y + 100
	shotGuideText.x = shipImg.x + 4
	shotGuideText.y = shipImg.y + 100
	guideUiGroup:insert( moveGuideText )
	guideUiGroup1:insert( shotGuideText )
	local touchIcon = image.loadUi("menu",2,guideUiGroup)
	guideUiGroup.isVisible = false
	guideUiGroup.alpha = 0
	guideUiGroup1.isVisible = false
	guideUiGroup1.alpha = 0

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
			transition.to( touchIcon, { time=800, delay=1200, y = shipImg.y,tag="teste",
			onCancel = function()
				touchIcon.x = display.contentCenterX
				touchIcon.y = display.contentCenterY - 30
			end	
			})
			transition.to( touchIcon, { time=800, delay=2100, x = shipImg.x + 90,tag="teste1",
			onCancel = function()
				touchIcon.x = display.contentCenterX
				touchIcon.y = display.contentCenterY - 30
			end	
			})
			transition.to( touchIcon, { time=800, delay=3000, x = shipImg.x,tag="teste2",
			onCancel = function()
				touchIcon.x = display.contentCenterX
				touchIcon.y = display.contentCenterY - 30
			end	
			})
			transition.to( touchIcon, { time=800, delay=3900, x = shipImg.x - 90,tag="teste3",
			onCancel = function()
				touchIcon.x = display.contentCenterX
				touchIcon.y = display.contentCenterY - 30
			end	
			})
			transition.to( touchIcon, { time=800, delay=4800, x = shipImg.x,tag="teste4",
			onCancel = function()
				touchIcon.x = display.contentCenterX
				touchIcon.y = display.contentCenterY - 30
			end	
			})
			transition.to( touchIcon, { time=800, delay=5700, alpha = 0,tag="teste5",
			onCancel = function()
				touchIcon.x = display.contentCenterX
				touchIcon.y = display.contentCenterY - 30
			end	
			})

		else
		transition.to(guideGroup, {time=500, alpha = 0,
		onComplete = function() 
			guideGroup.isVisible = false
			mainGroup.isVisible = true
			transition.cancel("teste")
			transition.cancel("teste1")
			transition.cancel("teste2")
			transition.cancel("teste3")
			transition.cancel("teste4")
			transition.cancel("teste5")
			touchIcon.x = display.contentCenterX
			touchIcon.y = display.contentCenterY - 30
			touchIcon.alpha = 1
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
		if(guideUiGroup1.isVisible == true) then
			transition.to(guideUiGroup1, {time=500, alpha = 0,
			onComplete = function() 
				guideUiGroup1.isVisible = false
				mainGroup.isVisible = true
			end
			})
			transition.to( mainGroup, { time=500, delay=1000, alpha = 1})
		end	
	end	

	local function nextGuide()
		transition.to( guideUiGroup, { time=500, alpha = 0,
		onComplete = function()
			guideUiGroup1.isVisible = true
		end	
		})
		transition.to( guideUiGroup1, { time=500, delay = 500, alpha = 1})
	end	

	playButton:addEventListener( "tap", gotoSelect )
	buttonNext:addEventListener( "tap", nextGuide)
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