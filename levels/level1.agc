type tLevel1
  player as tPlayer
  enemies as tEnemy[]
  map as tMap
  alarm as integer
  alarmSoundPlaying as integer
  background as integer
  button as integer
  music as integer
endtype

function Level1_Create()
  level as tLevel1
  level.map = Map_Create("maps/map-1.json", Tileset_Create("images/map-tiles.png", 64, "map-tiles"))
  level.player = Player_Create(9, Map_GetHeight(level.map) - 10)
  level.background = Level1_CreateBackground(level.map)
  level.music = LoadMusicOGG("music/ingame.ogg")
  level.alarm = 0
  level.alarmSoundPlaying = 0
  level.button = Level1_CreateNextLevelButton()
  Level1_CreateEnemies(level)

  SetMusicVolumeOGG(level.music, MUSIC_VOLUME)
  PlayMusicOGG(level.music, 1)
endfunction level

// PRIVATE
// =============================================================================

function Level1_CreateEnemies(level ref as tLevel1)
  level.enemies.insert(Enemy_Create(125, 106))
  level.enemies.insert(Enemy_Create(75, 66))
  level.enemies.insert(Enemy_Create(125, 30))
  level.enemies.insert(Enemy_Create(50, 30))
endfunction

function Level1_CreateNextLevelButton()
  image = LoadImage("images/button.png")
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  button = CreateSprite(image)
  SetSpriteAnimation(button, 6, 3, 2)
  SetSpritePosition(button, 145, 29)
endfunction button

function Level1_CreateBackground(map ref as tMap)
  image = LoadImage("images/bg-1.png")
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  sprite = CreateSprite(image)
  SetSpriteDepth(sprite, 2000)
  SetSpriteY(sprite, Map_GetHeight(map) - GetSpriteHeight(sprite))
  SetSpriteSnap(sprite, 1)
endfunction sprite
