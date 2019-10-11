local menu = {}

local composer = require( "composer" )
local image = require("loadImage")
local text = require("text")
local vol = require("volumeSetting")

menu.uiOption = display.newGroup()
menu.buttonOption = display.newGroup()
menu.buttonMenuOption = display.newGroup()
menu.uiPause = display.newGroup()

menu.uiPause.isVisible = false
menu.uiOption.isVisible = false
menu.buttonOption.isVisible = false
menu.buttonMenuOption.isVisible = false


-- Interface Opções --
local menu_option_panel = image.loadUi("option",1,menu.uiOption)

menu_option_top = text.loadText(2,"top",menu.uiOption)
menu_option_top.y = menu_option_panel.y - 120
local volumePanel = image.loadUi("option",2,menu.uiOption)
volumePanel.y = menu_option_panel.y - 25
local volumePanel1 = image.loadUi("option",2,menu.uiOption)
volumePanel1.y = volumePanel.y + 70

menu_option_music = text.generateText("Musica",menu.uiOption)
menu_option_volumeMusic = text.generateText(vol.musicCurrent,menu.uiOption)
menu_option_volumeEffect = text.generateText(vol.effectCurrent,menu.uiOption)
    
menu_option_music.x = volumePanel.x 
menu_option_music.y = volumePanel.y - 30
menu_option_volumeMusic.x = volumePanel.x - 54
menu_option_volumeMusic.y = volumePanel.y
menu_option_volumeEffect.x = volumePanel1.x - 54
menu_option_volumeEffect.y = volumePanel1.y

menu.volumeBar = image.loadUi("option",5,menu.uiOption)
menu.volumeBar.y = volumePanel.y
menu.volumeBar.x = volumePanel.x + 20
menu.volumeBar1 = image.loadUi("option",5,menu.uiOption)
menu.volumeBar1.y = volumePanel1.y 
menu.volumeBar1.x = volumePanel1.x + 20
local volumeDown = image.loadUi("option",6,menu.uiOption)
local volumeBarLeft = image.loadUi("option",3,menu.uiOption)
volumeBarLeft.x = volumePanel.x - 85
volumeBarLeft.y = volumePanel.y
volumeBarLeft.myName = "down"
volumeDown:toFront()
local volumeDown1 = image.loadUi("option",6,menu.uiOption)
local volumeBarLeft1 = image.loadUi("option",3,menu.uiOption)
volumeDown1:toFront()
volumeBarLeft1.x = volumePanel1.x - 85
volumeBarLeft1.y = volumePanel1.y
volumeBarLeft1.myName = "down1"
volumeDown.y = volumePanel.y
volumeDown.x = volumeBarLeft.x
volumeDown1.y = volumeBarLeft1.y
volumeDown1.x = volumeBarLeft1.x
volumeDown1.myName = "down1"
local volumeUp = image.loadUi("option",7,menu.uiOption)
local volumeBarRight = image.loadUi("option",4,menu.uiOption)
volumeUp:toFront()
volumeBarRight.x = volumePanel.x + 84
volumeBarRight.y = volumePanel.y
volumeBarRight.myName = "up"
local volumeUp1 = image.loadUi("option",7,menu.uiOption)
local volumeBarRight1 = image.loadUi("option",4,menu.uiOption)
volumeUp1:toFront()
volumeBarRight1.x = volumePanel1.x + 84
volumeBarRight1.y = volumePanel1.y
volumeBarRight1.myName = "up1"
volumeUp.y = volumeBarRight.y
volumeUp.x = volumeBarRight.x
volumeUp1.y = volumeBarRight1.y
volumeUp1.x = volumeBarRight1.x
menu_option_effect = text.generateText("Efeitos",menu.uiOption)
menu_option_effect.x = volumePanel1.x
menu_option_effect.y = volumePanel1.y - 30
menu.muteOff = image.loadUi("option",9,menu.uiOption)
menu.muteOff.myName = "menu.muteOff"
menu.muteOff.x = menu_option_music.x + 40
menu.muteOff.y = menu_option_music.y 
menu.muteOn = image.loadUi("option",10,menu.uiOption)
menu.muteOn.myName = "menu.muteOn"
menu.muteOn.x = menu.muteOff.x
menu.muteOn.y = menu.muteOff.y
menu.muteOff1 = image.loadUi("option",9,menu.uiOption)
menu.muteOff1.myName = "menu.muteOff1"
menu.muteOff1.x = menu_option_effect.x + 40
menu.muteOff1.y = menu_option_effect.y 
menu.muteOn1 = image.loadUi("option",10,menu.uiOption)
menu.muteOn1.myName = "menu.muteOn1"
menu.muteOn1.x = menu.muteOff1.x
menu.muteOn1.y = menu.muteOff1.y
local button_back_option = image.loadUi("option",8,menu.buttonOption)
button_back_option.y = menu_option_panel.y + 95
button_back_option.x = menu_option_panel.x 
local button_back_option_menu = image.loadUi("option",8,menu.buttonMenuOption)
button_back_option_menu.y = menu_option_panel.y + 95
button_back_option_menu.x = menu_option_panel.x 

return_text_button = text.generateText("Voltar",menu.buttonOption)
return_text_button.x = button_back_option.x
return_text_button.y = button_back_option.y

return_text_button_menu = text.generateText("Voltar",menu.buttonMenuOption)
return_text_button_menu.x = button_back_option.x
return_text_button_menu.y = button_back_option.y
 
function menu.menuShow( event ) 
    print(event.target.myName)
    if (event.target.myName == "uiPause" and menu.uiOption.isVisible == true) then
        menu.uiOption.isVisible = false
    elseif (menu.uiOption.isVisible == true and menu.uiPause.isVisible == false) then
        menu.uiOption.isVisible = false
        menu.buttonOption.isVisible = false
        menu.uiPause.isVisible = true   
    elseif (menu.uiPause.isVisible == false) then
        menu.uiPause.isVisible = true   
    elseif(menu.uiPause.isVisible == true) then
        menu.uiPause.isVisible = false
    end
end  

function menu.optionShow()
    menu.uiPause.isVisible = false
    menu.uiOption.isVisible = true
    menu.buttonOption.isVisible = true
end    

function menu.optionMenuShow()
    menu.uiOption.isVisible = true
    menu.buttonMenuOption.isVisible = true
end    

function menu.optionHide()
    menu.uiOption.isVisible = false
    menu.buttonMenuOption.isVisible = false
end    
    
local function muteChange( event )
    if(event.target.myName == "menu.muteOn" or event.target.myName == "menu.muteOff") then
        if(menu.muteOff.isVisible == true) then
            menu.muteOff.isVisible = false
            menu.muteOn.isVisible = true
            audio.stop(1)
            menu.muteOff:removeEventListener("tap", muteChange)
            menu.muteOn:addEventListener( "tap", muteChange)
        else
            menu.muteOff.isVisible = true
            menu.muteOn.isVisible = false
            menu.muteOn:removeEventListener("tap", muteChange)
            menu.muteOff:addEventListener( "tap", muteChange)   
        end    
    end    
    if(event.target.myName == "menu.muteOn1" or event.target.myName == "menu.muteOff1") then
        if(menu.muteOff1.isVisible == true) then
            menu.muteOff1.isVisible = false
            menu.muteOn1.isVisible = true
            audio.stop(2)
            audio.stop(3)
            menu.muteOff1:removeEventListener("tap", muteChange)
            menu.muteOn1:addEventListener( "tap", muteChange)
        else
            menu.muteOff1.isVisible = true
            menu.muteOn1.isVisible = false
            menu.muteOn1:removeEventListener("tap", muteChange)
            menu.muteOff1:addEventListener( "tap", muteChange)
        end    
    end     
end    

function menu.volumeChange(event)
    if(event.target.myName == "down") then
        if(vol.musicCurrent ~= 0) then
            vol.musicCurrent = vol.musicCurrent - 1
            transition.to(menu.volumeBar, { width = vol.updateBar(menu.volumeBar.width,"down"), time=1}) 
            vol.music = vol.music - 0.1
            audio.setVolume( vol.music, { channel=1 } )
        end  
    end
    if(event.target.myName == "up") then
        if(vol.musicCurrent ~= 10) then
            vol.musicCurrent = vol.musicCurrent + 1
            transition.to(menu.volumeBar, { width = vol.updateBar(menu.volumeBar.width,"up"), time=1})  
            vol.music = vol.music + 0.1
            audio.setVolume( vol.music, { channel=1 } )
        end    
    end
    if(event.target.myName == "down1") then
        if(vol.effectCurrent ~= 0) then
            vol.effectCurrent = vol.effectCurrent - 1
            transition.to(menu.volumeBar1, { width = vol.updateBar(menu.volumeBar1.width,"down"), time=1})  
            vol.effect = vol.effect - 0.1
            audio.setVolume( vol.effect, { channel=2})
            audio.setVolume( vol.effect, { channel=3})
        end
    end
    if(event.target.myName == "up1") then
        if(vol.effectCurrent ~= 10) then
            vol.effectCurrent = vol.effectCurrent + 1
            transition.to(menu.volumeBar1, { width = vol.updateBar(menu.volumeBar1.width,"up"), time=1})  
            vol.effect = vol.effect + 0.1
            audio.setVolume( vol.effect, { channel=2})
            audio.setVolume( vol.effect, { channel=3})
        end    
    end
    if(vol.musicCurrent == 0) then
        menu.volumeBar.width = 0
    end    
    if(vol.effectCurrent == 0) then
        menu.volumeBar1.width = 0
    end   
    menu_option_volumeMusic.text = vol.musicCurrent
    menu_option_volumeEffect.text = vol.effectCurrent
end   


volumeBarLeft:addEventListener( "tap", menu.volumeChange)
volumeBarLeft1:addEventListener( "tap", menu.volumeChange)
volumeBarRight:addEventListener( "tap", menu.volumeChange)
volumeBarRight1:addEventListener( "tap", menu.volumeChange)
menu.muteOff:addEventListener( "tap", muteChange)
menu.muteOff1:addEventListener( "tap", muteChange)
button_back_option:addEventListener ( "tap", menu.menuShow)
button_back_option_menu:addEventListener ( "tap", menu.optionHide)

return menu