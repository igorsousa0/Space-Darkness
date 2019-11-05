local composer = require( "composer" )
local image = require("src.imagens.loadImage")
local text = require("src.textos.text")
local func = require("src.funções.shipFunction")
local vol = require("src.audio.volumeSetting")
 
local scene = composer.newScene()

local backgroundSong = audio.loadSound("audio/guia/ObservingTheStar.ogg")
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
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

local goal = {
	text = "Seu objetivo é eliminar\n os inimigos, portanto,\n cuidado para não ser\n derrotado!",
	fontSize = 11.5,
	font = "Font/prstart.ttf",
    align = "center"
}

local function gotoMenu()
    composer.gotoScene( "src.telas.menu", { time=600, effect="crossFade" } )
end    

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect( sceneGroup, "background/3/Background.jpg", 530, 570 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background.alpha = 0.5

    guideGroup = display.newGroup()
	guideGroup1 = display.newGroup()
	guideUiGroup = display.newGroup()
	guideUiGroup1 = display.newGroup()
    guideUiGroup2 = display.newGroup()
    guideUiGroup3 = display.newGroup()
    buttonGroup = display.newGroup()
    sceneGroup:insert( guideGroup )
    sceneGroup:insert( guideGroup1 )
    sceneGroup:insert( guideUiGroup )
    sceneGroup:insert( guideUiGroup1 )
    sceneGroup:insert( guideUiGroup2 )
    sceneGroup:insert( guideUiGroup3 )
    sceneGroup:insert( buttonGroup )
    
	local guidePanel = image.loadUi("menu",1,guideGroup)
	guideGroup.isVisible = false
	guideGroup.alpha = 0

	local buttonExit = image.loadUi("menu panel",2,guideGroup)
	buttonExit.x = guidePanel.x
	buttonExit.y = guidePanel.y + 190
	buttonExit:scale(1.5,1.5)

	--local buttonNext = image.loadUi("menu panel",2,guideGroup)
	local buttonNext1 = image.loadUi("menu panel",2,buttonGroup)
	--[[buttonNext.x = buttonExit.x
	buttonNext.y = buttonExit.y - 60
	buttonNext.myName = "next"--]]
	buttonNext1.x = buttonExit.x + 70
	buttonNext1.y = buttonExit.y - 60
	buttonNext1.myName = "next"
	--buttonNext:scale(1.5,1.5)
	buttonNext1:scale(1.3,1.5)

	local buttonBack = image.loadUi("menu panel",2,buttonGroup)
	buttonBack.x = buttonExit.x - 65
	buttonBack.y = buttonExit.y - 60
	buttonBack.myName = "back"
	buttonBack:scale(1.3,1.5)

	local buttonExitText = text.generateTextMenu("Sair",guideGroup,buttonExit.x,buttonExit.y,"Font/prstart.ttf",20)
	--local buttonNextText = text.generateTextMenu("Próximo",guideGroup,buttonNext.x,buttonNext.y,"Font/prstart.ttf",18)
	local buttonNextText1 = text.generateTextMenu("Próximo",buttonGroup,buttonNext1.x + 3,buttonNext1.y,"Font/prstart.ttf",17)
	local buttonBackText1 = text.generateTextMenu("Voltar",buttonGroup,buttonBack.x,buttonBack.y,"Font/prstart.ttf",18)
	local guideTopText = text.generateTextMenu("Como  Jogar",guideGroup,display.contentCenterX,display.contentCenterY - 220,"Font/ARCADECLASSIC.TTF",32)
	local moveShipText = text.generateTextMenu("Movimentação",guideUiGroup,guidePanel.x + 5,guidePanel.y - 130,"Font/prstart.ttf",15)
	local shotShipText = text.generateTextMenu("Atirar",guideUiGroup1,guidePanel.x + 5,guidePanel.y - 130,"Font/prstart.ttf",15)
	local itemShipText = text.generateTextMenu("Itens",guideUiGroup2,guidePanel.x + 5,guidePanel.y - 130,"Font/prstart.ttf",15)
    local goalTopText = text.generateTextMenu("Objetivo",guideUiGroup3,guidePanel.x + 5,guidePanel.y - 130,"Font/prstart.ttf",15)
    local ship = image.loadImgShip(guidePanel.x,guidePanel.y,guideUiGroup)
	local ship1 = image.loadImgShip(guidePanel.x,guidePanel.y + 30,guideUiGroup1)
	local attack = image.loadItem(1,guideUiGroup2)
	local attack1 = image.loadItem(2,guideUiGroup2)
	local moveGuideText = display.newText( move )
	local shotGuideText = display.newText( shot )
	local shotNoteText = display.newText( shotNote )
	local itemGuideText = display.newText( item )
    local itemGuideText1 = display.newText( item1 )
    local goalGuideText = display.newText( goal )
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
    goalGuideText.x = goalTopText.x
    goalGuideText.y = goalTopText.y + 50
	guideUiGroup:insert( moveGuideText )
	guideUiGroup1:insert( shotGuideText )
	guideUiGroup1:insert( shotNoteText )
	guideUiGroup2:insert( itemGuideText )
    guideUiGroup2:insert( itemGuideText1 )
    guideUiGroup3:insert( goalGuideText )
    buttonGroup.isVisible = false
	guideGroup1.isVisible = false
	guideUiGroup.isVisible = false
	guideUiGroup1.isVisible = false
    guideUiGroup2.isVisible = false
    guideUiGroup3.isVisible = false

    local pageGuide = 1

    local function changeGuide(event)
        if(event.target.myName == "next") then
            if(pageGuide == 1) then
                guideUiGroup.isVisible = false
                guideUiGroup1.isVisible = true
                ship1:addEventListener( "tap", func.shotGuide )
                guideGroup1.isVisible = true
                buttonBack.alpha = 0.6
                buttonBackText1.alpha = 1
                buttonBack:addEventListener( "tap", changeGuide)
                --[[buttonNext.isVisible = false
                buttonNextText.isVisible = false--]]
            end   
            if(pageGuide == 2) then
                guideUiGroup1.isVisible = false
                guideUiGroup2.isVisible = true
                ship1:removeEventListener("tap", func.shotGuide)
            end	
            if(pageGuide == 3) then
                guideUiGroup2.isVisible = false
                guideUiGroup3.isVisible = true
                buttonNext1.alpha = 0.4
                buttonNextText1.alpha = 0.5
                buttonNext1:removeEventListener( "tap", changeGuide)
            end   
            pageGuide = pageGuide + 1 
        end	
        if(event.target.myName == "back") then
            if(pageGuide == 2) then
                guideUiGroup1.isVisible = false
                guideUiGroup.isVisible = true
                ship.x = guidePanel.x
                ship.y = guidePanel.y - 50
                ship:addEventListener("touch", func.dragShipGuide)
                buttonBack:removeEventListener( "tap", changeGuide)
                guideGroup1.isVisible = false
                buttonBack.alpha = 0.4
                buttonBackText1.alpha = 0.5
                --[[buttonNext.isVisible = true
                buttonNextText.isVisible = true--]]
            end	
            if(pageGuide == 3) then
                guideUiGroup2.isVisible = false
                guideUiGroup1.isVisible = true
                ship1:addEventListener("tap", func.shotGuide)
            end	
            if(pageGuide == 4) then
                guideUiGroup3.isVisible = false
                guideUiGroup2.isVisible = true
                buttonNext1.alpha = 0.6
                buttonNextText1.alpha = 1
                buttonNext1:addEventListener( "tap", changeGuide)
            end   
            pageGuide = pageGuide - 1 
        end		
    end	
    
    
    local function changeState()
        if(guideGroup.isVisible == false) then
            guideGroup.isVisible = true
            ship:addEventListener( "touch", func.dragShipGuide )
            buttonBack:removeEventListener( "tap", changeGuide)
            transition.to( guideGroup, { time=500, delay=200, alpha = 1,
            onComplete = function() 
                guideUiGroup.isVisible = true
                buttonGroup.isVisible = true
                buttonBack.alpha = 0.4
                buttonBackText1.alpha = 0.5
            end	
            })
            transition.to( guideUiGroup, { time=500, delay=1000, alpha = 1
            })
        end    
    end	
    
    
	--buttonNext:addEventListener( "tap", changeGuide)
	buttonNext1:addEventListener( "tap", changeGuide)
	buttonBack:addEventListener( "tap", changeGuide)
    buttonExit:addEventListener( "tap", gotoMenu )
    timer.performWithDelay( 400, changeState, 1)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        audio.play(backgroundSong, {channel = 1, loops = -1 })
        audio.setVolume( vol.music, { channel=1 } )
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
        composer.removeScene( "src.telas.guide" )
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