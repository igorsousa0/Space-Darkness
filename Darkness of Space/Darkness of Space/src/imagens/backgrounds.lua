local background = {}

function background.loadBackground(level,group)
    if(level == 1) then
        return display.newImageRect(group ,"background/1/back.png", 360, 570)
    end
    if(level == 2) then
       return display.newImageRect(group, "background/2/backTest.jpg", 530, 570 )
    end    
end    

return background