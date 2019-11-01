local score = {}

local scoreBase = 200
score.scoreTotal = 0
score.level = 0
score.Finalized = false
score.tentativas = 3

function score.setScore(hp)
    score.scoreTotal = score.scoreTotal + (hp * scoreBase)
end    
 
function score.getScore()
    return score.scoreTotal
end

return score