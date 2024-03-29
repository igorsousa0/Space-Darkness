local ui = {}

function ui.loadUi(target, type, group)
    if(target == "menu") then
        if(type == 1) then
            return display.newImageRect(group, "ui/Menu/panel.png", 221,197 )
        end
        if(type == 2) then
            return display.newImageRect(group, "ui/Menu/tapIcon.png", 512,512 )
        end    
        if(type == 3) then
            return display.newImageRect(group, "ui/Menu/flatDark21.png", 48,48 )
        end   
    end    
    if(target == "hp") then
        if(type == 1) then
            return display.newImageRect(group, "ui/Hp/2/Glass3.png", 120,18 )
        end    
        if(type == 2) then
            return display.newImageRect(group, "ui/Hp/2/Health3.png", 110,15 )
        end    
        if(type == 3) then
            return display.newImageRect(group, "ui/Hp/2/Glass2.png", 120,18 ) 
        end    
        if(type == 4) then
            return display.newImageRect(group, "ui/Hp/2/Health2.png", 110,15 )       
        end
    end    
    if(target == "pause") then   
        return display.newImageRect(group, "ui/transparentDark12.png", 40,40)
    end
    if(target == "menu panel") then
        if(type == 1) then
            return display.newImageRect(group, "ui/Menu/panelUi.png", 182 ,174)
        end   
        if(type == 2) then
            return display.newImageRect(group, "ui/Menu/ButtonWhite.png", 30 ,18)
        end   
        if(type == 3) then
            return display.newImageRect(group, "ui/Menu/ButtonWhite.png", 30 ,18)
        end 
        if(type == 4) then
            return display.newImageRect(group, "ui/Menu/ButtonWhite.png", 30 ,18)
        end    
    end
    if(target == "option") then
        if(type == 1) then
            return display.newImageRect(group, "ui/Menu/panelUi.png", 182 ,174)
        end
        if(type == 2) then
           return display.newImageRect(group, "ui/Menu/volumePanel1.png", 76 ,16)
        end  
        if(type == 3) then
            return display.newImageRect(group, "ui/Menu/volumePanelLeft.png", 18 ,16)
        end    
        if(type == 4) then
            return display.newImageRect(group, "ui/Menu/volumePanelRight.png", 18 ,16)
        end    
        if(type == 5) then
           return display.newImageRect(group, "ui/Menu/volumeBar.png", 34 ,14)
        end
        if(type == 6) then
            return display.newImageRect(group, "ui/Menu/volumeDown.png", 6 ,2)
        end    
        if(type == 7) then
            return display.newImageRect(group, "ui/Menu/volumeUp.png", 6 ,6)
        end
        if(type == 8) then
            return display.newImageRect(group, "ui/Menu/ButtonWhite.png", 30 ,18)
        end
        if(type == 9) then
            return display.newImageRect(group, "ui/Menu/muteOff.png", 18 ,18)
        end
        if(type == 10) then
            return display.newImageRect(group, "ui/Menu/muteOn.png", 19 ,18)
        end
    end      
end   

function ui.loadItem(type,group)
    if(type == 1) then
        return display.newImageRect(group, "sprites/Item/damage1.png", 36,37 )
    end
    if(type == 2) then
        return display.newImageRect(group, "sprites/Item/damage2.png", 46,47 )
    end    
end

function ui.loadImgScenario(type,group)
    if(type == 1) then
        return display.newImageRect(group,"sprites/Scenario/planet.png", 480,480 )
    end
    if(type == 2) then
        return display.newImageRect(group,"sprites/Scenario/downarrow.png", 32,32 )
    end    
end    


return ui