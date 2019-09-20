local player = require("spriteShip")
local boss = require("spriteBoss")
local uiGame = require("ui")

local img = {}
local table = {}

function img.loadShip(group)
    local ship = player.loadPlayer(group)
    ship.x = display.contentCenterX
    ship.y = display.contentCenterY + 210
    physics.addBody( ship, { radius=30, isSensor=true } )
    ship.myName = "ship"
    ship:scale(2.5,2.5)
    return ship
end

function img.loadBoss(level,group,type)
    if(level == 1) then
        local bossMage = boss.loadBoss(level,group,type)
        bossMage.x = display.contentCenterX
        bossMage.y = display.contentCenterY - 190
        physics.addBody( bossMage, "dynamic", { box=hitboxBoss} )
        bossMage.myName = "boss"
        bossMage:scale(2,2)
        bossMage:setSequence("normalMage")
        bossMage:play()
        return bossMage
    end   
    if(level == 2) then
        local bossMage = boss.loadBoss(level,group,type)
        bossMage.x = display.contentCenterX
        bossMage.y = display.contentCenterY - 190
        physics.addBody( bossMage, "dynamic", { box=hitboxBoss, filter = filterCollision } )
        bossMage.myName = "boss"
        bossMage:scale(1.4,1.4)
        bossMage:setSequence("normalMage")
        bossMage:play() 
        return bossMage
    end  
    if(level == 3) then
        local bossMage = boss.loadBoss(level,group,type)
        bossMage.x = display.contentCenterX
        bossMage.y = display.contentCenterY - 175
        physics.addBody( bossMage, "dynamic", { box=hitboxBoss} )
        bossMage:scale(1.2,1.2)
        bossMage.myName = "boss"
        bossMage:setSequence("normalMage")
        bossMage:play()
        return bossMage    
    end   
end    

function img.loadUi(target, type, group)
    if(target == "hp") then
        if(type == 1) then
            local hp_glass = uiGame.loadUi(target, type, group)
            hp_glass.x = display.contentCenterX - 90
            hp_glass.y = display.contentCenterY - 250
            hp_glass.alpha = 0.9
            return hp_glass
        end    
        if(type == 2) then
            local hp_player = uiGame.loadUi(target, type, group)
            hp_player.x = display.contentCenterX - 90
            hp_player.y = display.contentCenterY - 250
            hp_player.alpha = 0.6
            return hp_player
        end    
        if(type == 3) then
            local hp_glass = uiGame.loadUi(target, type, group)  
            hp_glass.x = display.contentCenterX + 40
            hp_glass.y = display.contentCenterY - 250
            hp_glass.alpha = 0.9
            return hp_glass 
        end    
        if(type == 4) then
            local hp_boss = uiGame.loadUi(target, type, group)
            hp_boss.x = display.contentCenterX + 40
            hp_boss.y = display.contentCenterY - 250
            hp_boss.alpha = 0.6
            return hp_boss
        end
    end    
    if(target == "pause") then
        local menu_pause = uiGame.loadUi(target,type,group)
        menu_pause.x = display.contentCenterX + 130
        menu_pause.y = display.contentCenterY - 250
        menu_pause.myName = "uiPause"
        menu_pause:scale(0.8,0.8)
        return menu_pause
    end
    if(target == "menu panel") then
        if(type == 1) then
            local menu_pause_panel = uiGame.loadUi(target,type,group)
            menu_pause_panel.x = display.contentCenterX 
            menu_pause_panel.y = display.contentCenterY 
            menu_pause_panel:scale(1.5,2)
            menu_pause_panel.alpha = 0.6
            return menu_pause_panel
        end   
        if(type == 2) then
            local button_resume = uiGame.loadUi(target,type,group)
            button_resume.x = display.contentCenterX 
            button_resume.y = display.contentCenterY - 30
            button_resume.myName = "uiResume"
            button_resume:scale(3,1.4)
            button_resume.alpha = 0.6
            return button_resume
        end   
        if(type == 3) then
            local button_option = uiGame.loadUi(target,type,group)
            button_option.x = display.contentCenterX 
            button_option.y = display.contentCenterY + 15
            button_option:scale(3,1.4)
            button_option.alpha = 0.6
            return button_option
        end 
        if(type == 4) then
            local button_back = uiGame.loadUi(target,type,group)
            button_back.x = display.contentCenterX 
            button_back.y = display.contentCenterY + 61
            button_back:scale(3,1.4)
            button_back.alpha = 0.6
            return button_back
        end    
    end
    if(target == "option") then
        if(type == 1) then
            local menu_option_panel = uiGame.loadUi(target,type,group)
            menu_option_panel.x = display.contentCenterX 
            menu_option_panel.y = display.contentCenterY 
            menu_option_panel:scale(2,2)
            menu_option_panel.alpha = 0.6
            return menu_option_panel
        end    
        if(type == 2) then
            local button_back_option = uiGame.loadUi(target,type,group)
            button_back_option.x = display.contentCenterX 
            button_back_option.y = display.contentCenterY + 61
            button_back_option:scale(4,1.4)
            button_back_option.alpha = 0.6
            return button_back_option
        end
    end    
end    

return img