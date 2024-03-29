local composer = require("composer")
local player = require("src.sprites.spriteShip")
local boss = require("src.sprites.spriteBoss")
local uiGame = require("src.imagens.ui")
local back = require("src.imagens.backgrounds")

local hitboxBoss1 = { halfWidth=38, halfHeight=51}
local hitboxBoss2 = { halfWidth=48, halfHeight=45}
local hitboxBoss3 = { halfWidth=38, halfHeight=51}

local img = {}

function img.loadImgScenario(type,group)
    if(type == 1) then
        local planet = uiGame.loadImgScenario(type,group)
        planet.x = display.contentCenterX
        planet.y = display.contentCenterY
        planet:scale(0.8,0.8)
        return planet
    end
    if(type == 2) then
       local downArrow = uiGame.loadImgScenario(type,group)
       downArrow.x = display.contentCenterX
       downArrow.y = display.contentCenterY
       return downArrow
    end    
end    

function img.loadBackground(level,group)
    if(level == 1) then
        local background = back.loadBackground(level,group)
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        return background
    end
    if(level == 2) then
        local background = back.loadBackground(level,group)
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        background.alpha = 0.6
        return background
    end
end

function img.loadShip(group)
    local ship = player.loadPlayer(group,nil)
    ship.x = display.contentCenterX
    ship.y = display.contentCenterY + 210
    physics.addBody( ship, { radius=30, isSensor=true } )
    ship.myName = "ship"
    ship:scale(2.5,2.5)
    return ship
end

function img.loadImgShip(x,y,group)
    local ship = player.loadPlayer(group,nil)
    ship.x = x 
    ship.y = y - 50
    ship:scale(2.5,2.5)
    return ship
end

function img.cutSceneShip(group)
    local ship = player.loadPlayer(group,nil)
    ship.x = display.contentCenterX
    ship.y = display.contentCenterY + 210
    ship.myName = "ship"
    ship:scale(2.5,2.5)
    return ship
end    

function img.loadBoss(level,group)
    if(level == 1) then
        local bossMage = boss.loadBoss(level,group)
        bossMage.x = display.contentCenterX
        bossMage.y = display.contentCenterY - 180
        physics.addBody( bossMage, "dynamic", { box=hitboxBoss1} )
        bossMage.myName = "boss"
        bossMage:scale(2,2)
        bossMage:setSequence("normalMage")
        bossMage:play()
        return bossMage
    end   
    if(level == 2) then
        local bossMage = boss.loadBoss(level,group)
        bossMage.x = display.contentCenterX
        bossMage.y = display.contentCenterY - 180
        physics.addBody( bossMage, "dynamic", { box=hitboxBoss2, filter = 1} )
        bossMage.myName = "boss"
        bossMage:scale(1.4,1.4)
        bossMage:setSequence("normalMage")
        bossMage:play() 
        return bossMage
    end  
    if(level == 3) then
        local bossMage = boss.loadBoss(level,group)
        bossMage.x = display.contentCenterX
        bossMage.y = display.contentCenterY - 165
        physics.addBody( bossMage, "dynamic", { box=hitboxBoss3} )
        bossMage:scale(1.2,1.2)
        bossMage.myName = "boss"
        bossMage:setSequence("normalMage")
        bossMage:play()
        return bossMage    
    end   
    if(level == 4) then
        local bossMage = boss.loadBoss(level,group)
        bossMage.x = display.contentCenterX
        bossMage.y = display.contentCenterY - 165
        physics.addBody( bossMage, "dynamic", { box=hitboxBoss3, filter = 1} )
        bossMage:scale(1.15,1.15)
        bossMage.myName = "boss"
        bossMage:setSequence("normalMage")
        bossMage:play()
        return bossMage
    end    
end    

function img.loadUi(target, type, group)
    if(target == "menu") then
        if(type == 1) then
            local guidePanel = uiGame.loadUi(target, type, group)
            guidePanel.x = display.contentCenterX
            guidePanel.y = display.contentCenterY - 40
            guidePanel:scale(2.55,5.5)
            guidePanel.alpha = 0.9
            return guidePanel
        end
        if(type == 2) then
            local touchIcon = uiGame.loadUi(target, type, group)
            touchIcon.x = display.contentCenterX
            touchIcon.y = display.contentCenterY - 30
            touchIcon:scale(0.1,0.1)
            touchIcon.alpha = 0.8
            return touchIcon
        end    
        if(type == 3) then
            local optionButton = uiGame.loadUi(target, type, group)
            optionButton.x = display.contentCenterX + 130
            optionButton.y = display.contentCenterY - 230
            optionButton.alpha = 0.8
            optionButton:scale(0.8,0.8)
            return optionButton
        end   
    end    
    if(target == "hp") then
        if(type == 1) then
            local hp_glass = uiGame.loadUi(target, type, group)
            hp_glass.x = display.contentCenterX - 90
            hp_glass.y = display.contentCenterY - 240
            hp_glass.alpha = 0.9
            return hp_glass
        end    
        if(type == 2) then
            local hp_player = uiGame.loadUi(target, type, group)
            hp_player.x = display.contentCenterX - 90
            hp_player.y = display.contentCenterY - 240
            hp_player.alpha = 0.6
            return hp_player
        end    
        if(type == 3) then
            local hp_glass = uiGame.loadUi(target, type, group)  
            hp_glass.x = display.contentCenterX + 40
            hp_glass.y = display.contentCenterY - 240
            hp_glass.alpha = 0.9
            return hp_glass 
        end    
        if(type == 4) then
            local hp_boss = uiGame.loadUi(target, type, group)
            hp_boss.x = display.contentCenterX + 40
            hp_boss.y = display.contentCenterY - 240
            hp_boss.alpha = 0.6
            return hp_boss
        end
    end    
    if(target == "pause") then
        local menu_pause = uiGame.loadUi(target,type,group)
        menu_pause.x = display.contentCenterX + 130
        menu_pause.y = display.contentCenterY - 238
        menu_pause.myName = "uiPause"
        menu_pause:scale(0.8,0.8)
        return menu_pause
    end
    if(target == "menu panel") then
        if(type == 1) then
            local menu_pause_panel = uiGame.loadUi(target,type,group)
            menu_pause_panel.x = display.contentCenterX 
            menu_pause_panel.y = display.contentCenterY 
            menu_pause_panel:scale(1.2,1.2)
            menu_pause_panel.alpha = 0.6
            return menu_pause_panel
        end   
        if(type == 2) then
            local button_resume = uiGame.loadUi(target,type,group)
            button_resume.x = display.contentCenterX 
            button_resume.y = display.contentCenterY - 20
            button_resume.myName = "uiResume"
            button_resume:scale(3.3,1.7)
            button_resume.alpha = 0.6
            return button_resume
        end   
        if(type == 3) then
            local button_option = uiGame.loadUi(target,type,group)
            button_option.x = display.contentCenterX 
            button_option.y = display.contentCenterY + 25
            button_option:scale(3.3,1.7)
            button_option.alpha = 0.6
            return button_option
        end 
        if(type == 4) then
            local button_back = uiGame.loadUi(target,type,group)
            button_back.x = display.contentCenterX 
            button_back.y = display.contentCenterY + 71
            button_back:scale(3.3,1.7)
            button_back.alpha = 0.6
            return button_back
        end    
    end
    if(target == "option") then
        if(type == 1) then
            local menu_option_panel = uiGame.loadUi(target,type,group)
            menu_option_panel.x = display.contentCenterX
            menu_option_panel.y = display.contentCenterY + 20
            menu_option_panel:scale(1.55,1.55)
            menu_option_panel.alpha = 0.6
            return menu_option_panel
        end   
        if(type == 2) then
            local volumePanel = uiGame.loadUi(target,type,group)
            volumePanel.x = display.contentCenterX - 3
            volumePanel.y = display.contentCenterY - 25
            volumePanel:scale(1.8,1.8)
            return volumePanel
        end    
        if(type == 3) then
            local volumePanelLeft = uiGame.loadUi(target,type,group)
            volumePanelLeft.x = display.contentCenterX - 3
            volumePanelLeft.y = display.contentCenterY - 25
            volumePanelLeft:scale(1.8,1.8)
            return volumePanelLeft
        end    
        if(type == 4) then
            local volumePanelRight = uiGame.loadUi(target,type,group)
            volumePanelRight.x = display.contentCenterX - 3
            volumePanelRight.y = display.contentCenterY - 25
            volumePanelRight:scale(1.8,1.8)
            return volumePanelRight
        end  
        if(type == 5) then
            local volumeBar = uiGame.loadUi(target,type,group)
            volumeBar:scale(1.61,1.61)
            volumeBar.width = 64
            return volumeBar
        end  
        if(type == 6) then
            local volumeDown = uiGame.loadUi(target,type,group)
            volumeDown:scale(2.3,2.1)
            return volumeDown
        end    
        if(type == 7) then
            local volumeUp = uiGame.loadUi(target,type,group)
            volumeUp:scale(2.3,2.3)
            return volumeUp
        end
        if(type == 8) then
            local button_back_option = uiGame.loadUi(target,type,group)
            button_back_option.x = display.contentCenterX 
            button_back_option.y = display.contentCenterY + 95
            button_back_option:scale(3.3,1.7)
            button_back_option.alpha = 0.6
            return button_back_option
        end
        if(type == 9) then
            local muteOff = uiGame.loadUi(target,type,group)
            muteOff.x = display.contentCenterX 
            muteOff.y = display.contentCenterY 
            muteOff:scale(1.5,1.5)
            return muteOff
        end
        if(type == 10) then
           local muteOn = uiGame.loadUi(target,type,group)
           muteOn.x = display.contentCenterX 
           muteOn.y = display.contentCenterY 
           muteOn:scale(1.5,1.5)
           muteOn.isVisible = false
           return muteOn
        end    
    end    
end  

function img.loadItem(type,group)
    if(type == 1) then
        local attack1 = uiGame.loadItem(type,group)
        attack1.isBullet = true
        attack1.myName = "attack3"
        return attack1
    end 
    if(type == 2) then
        local attack2 = uiGame.loadItem(type,group)
        attack2.isBullet = true
        attack2.myName = "attack4"
        return attack2
    end    
end

return img