local image = require("src.imagens.loadImage")
local ui = require("src.imagens.ui")
-- Função de movimentação da Nave --
local func = {}
local playerAttack = {}

function func.dragShip( event )
    local ship = event.target
    local phase = event.phase

    if ( "began" == phase ) then
        display.currentStage:setFocus(ship)
        ship.touchOffsetX = event.x - ship.x
        ship.touchOffsetY = event.y - ship.y
    elseif ( "moved" == phase ) then
        -- Move the ship to the new touch position
        if (ship.x < display.contentCenterX) then 
            ship:setSequence("leftShip")
            ship:play()    
        else 
            ship:setSequence("rightShip")
            ship:play()
        end
        if(ship.touchOffsetX or ship.touchOffsetY ~= nil) then
            if( event.x > 40 and event.x < display.contentWidth-40) then
                ship.x = event.x - ship.touchOffsetX
            end  
            if(event.y > 207 and event.y < display.contentHeight-101) then
                ship.y = event.y - ship.touchOffsetY
            end    
        end         
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
        ship:setSequence("normalShip")
        ship:play()    
    end
    
    return true
end

function func.dragShipGuide( event )
    local ship = event.target
    local phase = event.phase

    if ( "began" == phase ) then
        display.currentStage:setFocus(ship)
        ship.touchOffsetX = event.x - ship.x
        ship.touchOffsetY = event.y - ship.y
        print("Eixo X: " ..event.x)
        print("Eixo Y: " ..event.y)
        print(display.contentHeight)
    elseif ( "moved" == phase ) then
        -- Move the ship to the new touch position
        if (ship.x < display.contentCenterX) then 
            ship:setSequence("leftShip")
            ship:play()    
        else 
            ship:setSequence("rightShip")
            ship:play()
        end
        if( event.x > 56 and event.x < display.contentWidth-56) then
            ship.x = event.x - ship.touchOffsetX
        end    
        if(event.y > 158 and event.y < display.contentHeight-357) then
            ship.y = event.y - ship.touchOffsetY
        end    
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
        ship:setSequence("normalShip")
        ship:play()    
    end
    
    return true
end

function func.shotGuide(event)

    local ship = event.target
    local attackType = math.random(1,2)
    if(attackType == 1) then
        local attack = display.newImageRect(guideUiGroup1, "sprites/Item/damage1.png", 36,37 )
        attack.x = ship.x
        attack.y = ship.y
        transition.to(attack, {time=500, y = 121, 
        onComplete = function() display.remove(attack) end
        })
    end    
    if(attackType == 2) then
        local attack = display.newImageRect(guideUiGroup1, "sprites/Item/damage2.png", 46,47 )
        attack.x = ship.x
        attack.y = ship.y
        transition.to(attack, {time=500, y = 121, 
        onComplete = function() display.remove(attack) end
        })
    end  
end
--[[function func.addTable(attack)
    table.insert(playerAttack, attack)
end    

function func.removeTable()
    table.remove(playerAttack)
end--]]

return func