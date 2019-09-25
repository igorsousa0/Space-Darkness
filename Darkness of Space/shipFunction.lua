local image = require("loadImage")
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
        if(( event.x > 40 and event.x < display.contentWidth-40) and (event.y > 150 and event.y < display.contentHeight-30)) then
            ship.x = event.x - ship.touchOffsetX
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

--[[function func.updateAttackCurrent()
    for k,v in pairs(playerAttack) do
        if (k == 1 and v == "attack1") then
            attackCurrent = 1
        elseif (k == 1 and v == "attack2") then
            attackCurrent = 3
        end    
        if(attackText ~= nil) then
            attackText.text = "Dano Atual: " .. attackCurrent  
        end    
    end
end  

function func.attack(ship,bossMage,group,contadorAttack,contadorText,attackText,attackCurrent)
    if (playerAttack[1] ~= nil) then
        if (playerAttack[1] == "attack1") then
            local attack1 = display.newImageRect(group, "Sprites/Item/damage1.png", 36,37 )
            physics.addBody( attack1, "dynamic", { box=offsetRectParams, filter = filterCollision} )
            attack1.isBullet = true
            attack1.myName = "attack3"
            attack1.x = ship.x
            attack1.y = ship.y
            contadorAttack = contadorAttack - 1
            contadorText.text = "Dano Acumulado: " .. contadorAttack
            audio.play(shotEffect, {channel = 2} ) 
            transition.to(attack1, {time=1000, y = bossMage.y, 
            onComplete = function() display.remove(attack1) end
            })
        elseif (playerAttack[1] == "attack2") then
            local attack2 = display.newImageRect(group, "Sprites/Item/damage2.png", 46,47 )
            physics.addBody( attack2, "dynamic", { box=offsetRectParams, filter = filterCollision} )
            attack2.isBullet = true
            attack2.myName = "attack4"
            attack2.x = ship.x
            attack2.y = ship.y
            contadorAttack = contadorAttack - 3
            contadorText.text = "Dano Acumulado: " .. contadorAttack
            audio.play(shotEffect, {channel = 2} )  
            transition.to(attack2, {time=1000, y = bossMage.y, 
            onComplete = function() display.remove(attack2) end
            })
        end  
        if (contadorAttack == 0) then
            attackCurrent = 0
            attackText.text = "Dano Atual: " .. attackCurrent
        end
        table.remove(playerAttack,1)
        func.updateAttackCurrent()
    end        
end


function func.addTable(attack)
    table.insert(playerAttack, attack)
end    

function func.removeTable()
    table.remove(playerAttack)
end--]]

return func