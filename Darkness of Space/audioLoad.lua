local sound = {}

-- Música da cena final do jogo --
sound.endGame = audio.loadSound("audio/endGame/Beyond The Clouds.mp3")

-- Música da fase 1 --
sound.fase1_Song = audio.loadSound("audio/fase01/magicspace.mp3")

-- Música da fase 2 --
sound.fase2_Song = audio.loadSound("audio/fase02/boss02.mp3")

-- Música da fase 3 --
sound.fase3_Song = audio.loadSound("audio/fase03/Dimensions(Main Theme).mp3")
sound.fase3_Song2 = audio.loadSound("audio/fase03/Orbital Colossus.mp3")

-- Sons de efeitos do Jogo -- 
sound.shotEffect = audio.loadSound("audio/effect/ship/laser.wav")
sound.fireEffect = audio.loadSound("audio/effect/mage01/fire.wav")
sound.explosionEffect = audio.loadSound("audio/effect/mage02/DeathFlash.mp3")

return sound