local text = {}

local image = require("src.imagens.loadImage")

local dialogueOption = {
    text = "Chefe, nossos satelites\n pararam de funcionar!\n o que devemos fazer!?",
	fontSize = 11,
	font = "Font/prstart.ttf",
    align = "center"
}

local dialogueOption1 = {
    text = "Droga, provalmente\n aquelas criaturas estão\n nos causando problemas\n novamente...",
	fontSize = 11,
	font = "Font/prstart.ttf",
    align = "center"
}

local dialogueOption2 = {
    text = "Recruta, gostaria que\n você desse uma olhada\n nos satelites e descobrir\n o estar acontecendo",
	fontSize = 11,
	font = "Font/prstart.ttf",
    align = "center"
}

local dialogueOption3 = {
    text = "Ok chefe! irem ver\n imediatamente!",
	fontSize = 11,
	font = "Font/prstart.ttf",
    align = "center"
}

local dialogueOption4 = {
    text = "Nós contamos com você,\n recruta! Tome cuidado!",
	fontSize = 11,
	font = "Font/prstart.ttf",
    align = "center"
}

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
end    

function text.loadDialogue(type)
    if(type == 1) then
        return display.newText( dialogueOption )
    end    
    if(type == 2) then
        return display.newText( dialogueOption1 )
    end    
    if(type == 3) then
        return display.newText( dialogueOption2 )
    end 
    if(type == 4) then
        return display.newText( dialogueOption3 )
    end 
    if(type == 5) then
        return display.newText( dialogueOption4 )
    end 
end    

function text.generateText(name,group)
    return display.newText(group,name ,display.contentCenterX ,display.contentCenterY, native.systemFont, 14.5) 
end    

function text.generateTextMenu(name,group,x,y,font,size)
    return display.newText(group,name ,x ,y, font, size) 
end 




return text    