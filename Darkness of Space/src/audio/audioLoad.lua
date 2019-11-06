local sound = {}

-- Músicas do Jogo --
sound.musicTable = {
    menu_Song = audio.loadSound("audio/menu/spacewalk.mp3"),
    guide_Song = audio.loadSound("audio/guia/ObservingTheStar.ogg"),
    fase1_Song = audio.loadSound("audio/fase01/magicspace.mp3"),
    fase2_Song = audio.loadSound("audio/fase02/boss02.mp3"),
    fase3_Song = audio.loadSound("audio/fase03/Dimensions(Main Theme).mp3"),
    fase3_Song2 = audio.loadSound("audio/fase03/Orbital Colossus.mp3"),
    endGame = audio.loadSound("audio/endGame/Beyond The Clouds.mp3"),
}

-- Sons de efeitos do Jogo -- 
sound.effectTable = {
    shotEffect = audio.loadSound("audio/effect/ship/laser.wav"),
    fireEffect = audio.loadSound("audio/effect/mage01/fire.wav"),
    explosionEffect = audio.loadSound("audio/effect/mage02/DeathFlash.mp3"),
    ignition = audio.loadSound("audio/effect/ship/ignition.mp3"),
    launch = audio.loadSound("audio/effect/ship/launch.wav"),
}
return sound