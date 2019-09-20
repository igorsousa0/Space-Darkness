local ui = {}

function ui.loadUi(target, type, group)
    if(target == "hp") then
        if(type == 1) then
            return display.newImageRect(group, "UI/Hp/2/Glass3.png", 120,18 )
        end    
        if(type == 2) then
            return display.newImageRect(group, "UI/Hp/2/Health3.png", 110,15 )
        end    
        if(type == 3) then
            return display.newImageRect(group, "UI/Hp/2/Glass2.png", 120,18 ) 
        end    
        if(type == 4) then
            return display.newImageRect(group, "UI/Hp/2/Health2.png", 110,15 )       
        end
    end    
    if(target == "pause") then   
        return display.newImageRect(group, "UI/transparentDark12.png", 40,40)
    end
    if(target == "menu panel") then
        if(type == 1) then
            return display.newImageRect(group, "UI/Menu/panelUi.png", 182 ,174)
        end   
        if(type == 2) then
            return display.newImageRect(group, "UI/Menu/ButtonWhite.png", 30 ,18)
        end   
        if(type == 3) then
            return display.newImageRect(group, "UI/Menu/ButtonWhite.png", 30 ,18)
        end 
        if(type == 4) then
            return display.newImageRect(group, "UI/Menu/ButtonWhite.png", 30 ,18)
        end    
    end
    if(target == "option") then
        if(type == 1) then
            return display.newImageRect(group, "UI/Menu/panelUi.png", 182 ,174)
        end    
        if(type == 2) then
            return display.newImageRect(group, "UI/Menu/ButtonWhite.png", 30 ,18)
        end
    end      
end   

return ui