local text = {}

local image = require("loadImage")

function text.loadText(number,type,group)
    if(type == "top") then
        if(number == 1) then
            return display.newText(group,"Jogo Pausado" ,display.contentCenterX ,display.contentCenterY - 93, native.systemFont, 14)
        end
        if(number == 2) then
            return display.newText(group,"Opções" ,display.contentCenterX ,display.contentCenterY - 110, native.systemFont, 14)
        end   
    end
    if(type == "menu") then
        if(number == 1) then
            return display.newText(group,"Retormar" ,display.contentCenterX ,display.contentCenterY, native.systemFont, 14) 
        end
        if(number == 2) then
            return display.newText(group,"Opções" ,display.contentCenterX ,display.contentCenterY, native.systemFont, 14) 
        end    
        if(number == 3) then
            return display.newText(group,"Sair" ,display.contentCenterX ,display.contentCenterY, native.systemFont, 14)
        end    
    end 
    if(type == "option") then
        if(number == 1) then
            return display.newText(group,"Musica" ,display.contentCenterX ,display.contentCenterY, native.systemFont, 14)
        end
        if(number == 2) then
            return display.newText(group,10,display.contentCenterX,display.contentCenterY, native.systemFont, 14)
        end
        if(number == 3) then
           return display.newText(group,"Efeitos" ,display.contentCenterX ,display.contentCenterY, native.systemFont, 14)
        end  
        if(number == 4) then
            return display.newText(group,"Salvar e Voltar" ,display.contentCenterX ,display.contentCenterY, native.systemFont, 14)
        end   
    end   
end    

function text.generateText(name,group)
    return display.newText(group,name ,display.contentCenterX ,display.contentCenterY, native.systemFont, 14) 
end    


return text    