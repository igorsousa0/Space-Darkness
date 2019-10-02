local composer = require( "composer" )
local image = require("loadImage")
local text = require("text")
local func = require("shipFunction")

local scene = composer.newScene()

local backgroundSong = audio.loadSound("audio/menu/spacewalk.mp3")

local function gotoSelect()
	composer.gotoScene( "fase1", { time=400, effect="crossFade" } )
end

local move = {
    text = "Toque e arraste a nave\n para movimentar",
	fontSize = 12.5,
	font = "Font/prstart.ttf",
    align = "center"
}

local shot = {
    text = "Toque na nave para\n atirar",
	fontSize = 12,
	font = "Font/prstart.ttf",
    align = "center"
}

local shotNote = {
	text = "Observação: Só\n poderá atirar se tiver\n coletado o item de dano",
	fontSize = 11.5,
	font = "Font/prstart.ttf",
    align = "center"
}

local item = {
	text = "Item causará 1 de dano\n ao inimigo",
	fontSize = 11.5,
	font = "Font/prstart.ttf",
    align = "center"
}

local item1 = {
	text = "Item causará 3 de dano\n ao inimigo",
	fontSize = 11.5,
	font = "Font/prstart.ttf",
    align = "center"
}


function scene:create( event )

	local sceneGroup = self.view
	local musicState = true
	local musicButton
	local pageGuide = 1
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
	guideGroup1 = display.newGroup()
	sceneGroup:insert( guideGroup1 )
	guideUiGroup = display.newGroup()
	sceneGroup:insert( guideUiGroup )
	guideUiGroup1 = display.newGroup()
	sceneGroup:insert( guideUiGroup1 )
	guideUiGroup2 = display.newGroup()
	sceneGroup:insert( guideUiGroup2 )

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

	local buttonExit = image.loadUi("menu panel",2,guideGroup)
	buttonExit.x = guidePanel.x
	buttonExit.y = guidePanel.y + 190
	buttonExit:scale(1.5,1.5)

	local buttonNext = image.loadUi("menu panel",2,guideGroup)
	local buttonNext1 = image.loadUi("menu panel",2,guideGroup1)
	buttonNext.x = buttonExit.x
	buttonNext.y = buttonExit.y - 60
	buttonNext.myName = "next"
	buttonNext1.x = buttonExit.x + 70
	buttonNext1.y = buttonNext.y
	buttonNext1.myName = "next1"
	buttonNext:scale(1.5,1.5)
	buttonNext1:scale(1.3,1.5)

	local buttonBack = image.loadUi("menu panel",2,guideGroup1)
	buttonBack.x = buttonExit.x - 65
	buttonBack.y = buttonNext.y
	buttonBack.myName = "back"
	buttonBack:scale(1.3,1.5)

	local buttonExitText = text.generateTextMenu("Sair",guideGroup,buttonExit.x,buttonExit.y,"Font/prstart.ttf",20)
	local buttonNextText = text.generateTextMenu("Próximo",guideGroup,buttonNext.x,buttonNext.y,"Font/prstart.ttf",18)
	local buttonNextText1 = text.generateTextMenu("Próximo",guideGroup1,buttonNext1.x + 3,buttonNext1.y,"Font/prstart.ttf",17)
	local buttonBackText1 = text.generateTextMenu("Voltar",guideGroup1,buttonBack.x,buttonBack.y,"Font/prstart.ttf",18)
	local guideTopText = text.generateTextMenu("Como  Jogar",guideGroup,display.contentCenterX,display.contentCenterY - 220,"Font/ARCADECLASSIC.TTF",32)
	local moveShipText = text.generateTextMenu("Movimentação",guideUiGroup,guidePanel.x,guidePanel.y - 130,"Font/prstart.ttf",15)
	local shotShipText = text.generateTextMenu("Atirar",guideUiGroup1,guidePanel.x,guidePanel.y - 130,"Font/prstart.ttf",15)
	local itemShipText = text.generateTextMenu("Itens",guideUiGroup2,guidePanel.x,guidePanel.y - 130,"Font/prstart.ttf",15)
	local ship = image.loadImgShip(guidePanel.x,guidePanel.y,guideUiGroup)
	local ship1 = image.loadImgShip(guidePanel.x,guidePanel.y + 30,guideUiGroup1)
	local attack = image.loadItem(1,guideUiGroup2)
	local attack1 = image.loadItem(2,guideUiGroup2)
	local moveGuideText = display.newText( move )
	local shotGuideText = display.newText( shot )
	local shotNoteText = display.newText( shotNote )
	local itemGuideText = display.newText( item )
	local itemGuideText1 = display.newText( item1 )
	attack.x = display.contentCenterX
	attack.y = guidePanel.y - 80
	attack1.x = attack.x 
	attack1.y = attack.y + 100
	moveGuideText.x = ship.x + 4
	moveGuideText.y = ship.y + 80
	shotGuideText.x = ship.x + 4
	shotGuideText.y = ship.y + 80
	shotNoteText.x = shotGuideText.x - 4
	shotNoteText.y = shotGuideText.y + 40
	itemGuideText.x = attack.x
	itemGuideText.y = attack.y + 45
	itemGuideText1.x = attack1.x
	itemGuideText1.y = attack1.y + 45
	guideUiGroup:insert( moveGuideText )
	guideUiGroup1:insert( shotGuideText )
	guideUiGroup1:insert( shotNoteText )
	guideUiGroup2:insert( itemGuideText )
	guideUiGroup2:insert( itemGuideText1 )
	--local touchIcon = image.loadUi("menu",2,guideUiGroup)
	guideGroup1.isVisible = false
	guideGroup1.alpha = 0
	guideUiGroup.isVisible = false
	guideUiGroup.alpha = 0
	guideUiGroup1.isVisible = false
	guideUiGroup1.alpha = 0
	guideUiGroup2.isVisible = false
	guideUiGroup2.alpha = 0

	local function changeState(event)
		if(event.numTaps == 1) then
			if(pageGuide == 1 or pageGuide == 2 or pageGuide == 3) then
				if(guideGroup.isVisible == false) then
					transition.to(mainGroup, {time=500, alpha = 0,
					onComplete = function() 
						mainGroup.isVisible = false
						guideGroup.isVisible = true
						ship:addEventListener( "touch", func.dragShipGuide )
					end
					})
					transition.to( guideGroup, { time=500, delay=500, alpha = 1,
					onComplete = function() 
						guideUiGroup.isVisible = true
					end	
					})
					transition.to( guideUiGroup, { time=500, delay=1000, alpha = 1
					})
					--[[transition.to( touchIcon, { time=800, delay=1200, y = ship.y,tag="teste",
					onCancel = function()
						touchIcon.x = display.contentCenterX
						touchIcon.y = display.contentCenterY - 30
					end	
					})
					transition.to( touchIcon, { time=800, delay=2100, x = ship.x + 90,tag="teste1",
					onCancel = function()
						touchIcon.x = display.contentCenterX
						touchIcon.y = display.contentCenterY - 30
					end	
					})
					transition.to( touchIcon, { time=800, delay=3000, x = ship.x,tag="teste2",
					onCancel = function()
						touchIcon.x = display.contentCenterX
						touchIcon.y = display.contentCenterY - 30
					end	
					})
					transition.to( touchIcon, { time=800, delay=3900, x = ship.x - 90,tag="teste3",
					onCancel = function()
						touchIcon.x = display.contentCenterX
						touchIcon.y = display.contentCenterY - 30
					end	
					})
					transition.to( touchIcon, { time=800, delay=4800, x = ship.x,tag="teste4",
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
					})--]]

				else
				transition.to(guideGroup, {time=500, alpha = 0,
				onComplete = function() 
					guideGroup.isVisible = false
					mainGroup.isVisible = true
					ship:removeEventListener("touch", func.dragShipGuide)
					ship.x = guidePanel.x
					ship.y = guidePanel.y - 50
					ship:pause()
					--[[transition.cancel("teste")
					transition.cancel("teste1")
					transition.cancel("teste2")
					transition.cancel("teste3")
					transition.cancel("teste4")
					transition.cancel("teste5")
					touchIcon.x = display.contentCenterX
					touchIcon.y = display.contentCenterY - 30
					touchIcon.alpha = 1--]]
				end
				})
				transition.to( guideUiGroup, { time=500, alpha = 0,
				onComplete = function() 
					--touchIcon.y = display.contentCenterY - 30
				end	
				})
				transition.to( mainGroup, { time=500, delay=1000, alpha = 1,
				onComplete = function()
					pageGuide = 1
					guideUiGroup.isVisible = false
				end	
				})
				end	
			end	
			if(pageGuide == 2) then
				if(guideUiGroup1.isVisible == true) then
					transition.to(guideUiGroup1, {time=500, alpha = 0,
					onComplete = function() 
						pageGuide = 1
						guideUiGroup1.isVisible = false
						mainGroup.isVisible = true
						ship:removeEventListener("touch", func.dragShipGuide)
					end
					})
					transition.to(guideGroup1, {time=500, alpha = 0,
					onComplete = function() 
						guideGroup1.isVisible = false
					end
					})
					transition.to( buttonNext, { time=500,delay = 500, alpha = 0.6})
					transition.to( buttonNextText, { time=500,delay = 500, alpha = 1})
					transition.to( mainGroup, { time=500, delay=1000, alpha = 1})
				end	
			end	
			if(guideUiGroup2.isVisible == true) then
				if(pageGuide == 3) then
					transition.to(guideUiGroup2, {time=500, alpha = 0,
					onComplete = function() 
						pageGuide = 1
						guideUiGroup2.isVisible = false
						mainGroup.isVisible = true
					end
					})
					transition.to(guideGroup1, {time=500, alpha = 0,
					onComplete = function() 
						guideGroup1.isVisible = false
					end
					})
					transition.to( buttonNext1, { time=500,delay = 500, alpha = 0.6})
					transition.to( buttonNextText1, { time=500,delay = 500, alpha = 1})
					transition.to( buttonNext, { time=500,delay = 500, alpha = 0.6})
					transition.to( buttonNextText, { time=500,delay = 500, alpha = 1})
					transition.to( mainGroup, { time=500, delay=1000, alpha = 1})
				end	
			end	
		end	
	end	

	local function changeGuide(event)
		if(event.numTaps == 1) then
			if(event.target.myName == "next") then
				transition.to( guideUiGroup, { time=500, alpha = 0,
				onComplete = function()
					pageGuide = pageGuide + 1
					guideUiGroup1.isVisible = true
					guideGroup1.isVisible = true
					ship1:addEventListener( "tap", func.shotGuide )
				end	
				})
				transition.to( buttonNext, { time=500, alpha = 0})
				transition.to( buttonNextText, { time=500, alpha = 0})
				transition.to( guideGroup1, { time=500, delay = 500, alpha = 1})
				transition.to( guideUiGroup1, { time=500, delay = 500, alpha = 1})
			end	
			if(event.target.myName == "next1") then
				if(pageGuide == 2) then
					
					transition.to( guideUiGroup1, { time=500, alpha = 0,
					onComplete = function()
						pageGuide = pageGuide + 1
						
						guideUiGroup2.isVisible = true
						ship1:removeEventListener("tap", func.shotGuide)
					end	
				})
					transition.to( guideUiGroup2, { time=500, delay = 500, alpha = 1})
				end	
			end	
			if(event.target.myName == "back") then
				if(pageGuide == 2) then
					transition.to( guideUiGroup1, { time=500, alpha = 0,
					onComplete = function()
						pageGuide = pageGuide - 1
						guideUiGroup.isVisible = true
						ship.x = guidePanel.x
						ship.y = guidePanel.y - 50
						ship:addEventListener("touch", func.dragShipGuide)
					end	
					})
					transition.to( guideGroup1, { time=500, alpha = 0,
					onComplete = function()
						guideGroup1.isVisible = false
					end	
					})
					transition.to( buttonNext, { time=500, delay = 500, alpha = 0.6})
					transition.to( buttonNextText, { time=500, delay = 500, alpha = 1})
					transition.to( guideUiGroup, { time=500, delay = 500, alpha = 1})
				end	
				if(pageGuide == 3) then
					transition.to( guideUiGroup2, { time=500, alpha = 0,
					onComplete = function()
						pageGuide = pageGuide - 1
						guideUiGroup1.isVisible = true
						ship1:addEventListener("tap", func.shotGuide)
					end	
					})
					transition.to( guideUiGroup1, { time=500, delay = 500, alpha = 1})
				end	
			end	
		end	
	end	

	playButton:addEventListener( "tap", gotoSelect )
	buttonNext:addEventListener( "tap", changeGuide)
	buttonNext1:addEventListener( "tap", changeGuide)
	buttonBack:addEventListener( "tap", changeGuide)
	guideButton:addEventListener( "tap", changeState )
	buttonExitText:addEventListener( "tap", changeState )

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