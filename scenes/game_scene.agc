type tGameScene
  player as tPlayer
  lives as integer
  enemies as tEnemy[]
  map as tMap
  alarm as integer
  alarmPlaying as integer
  background as integer
  button as integer
  hud as tHeartsHud
  music as integer
endtype

function GameScene_Create()
  if DEBUGGING then SetPhysicsDebugOn()
  SetPhysicsGravity(0, 130)

  global gameScene as tGameScene
  gameScene.map = Map_Create("maps/map-1.json", Tileset_Create("images/map-tiles.png", 64, "map-tiles"))
  gameScene.player = Player_Create(9, Map_GetHeight(gameScene.map) - 10)
  gameScene.background = GameScene_CreateBackground()
  gameScene.hud = HeartsHud_Create()
  gameScene.lives = PLAYER_INITIAL_LIVES
  gameScene.music = LoadMusicOGG("music/ingame.ogg")
  gameScene.alarm = 0
  gameScene.alarmPlaying = 0
  SetMusicVolumeOGG(gameScene.music, MUSIC_VOLUME)
  PlayMusicOGG(gameScene.music, 1)

  GameScene_CreateEnemies()
  GameScene_CreateNextLevelButton()
endfunction

function GameScene_Update(delta#)
  Player_Update(gameScene.player, delta#)
  GameScene_UpdateEnemies(delta#)
  GameScene_CheckBullets()
  GameScene_UpdateNextLevelButton()
  GameScene_PlayAlarmIfNeeded()
  CenterCameraOnSprite(gameScene.player.sprite)
  GameScene_UpdateBackground()

  if g.currentScene <> SCENES_GAME_SCENE then GameScene_TransitionToNextScene()
endfunction

// Clean everything up for next scene, as if nothing happened!
function GameScene_Destroy()
  for i = 0 to gameScene.enemies.length
    Enemy_Destroy(gameScene.enemies[i], 1)
  next i
  gameScene.enemies.length = -1
  gameScene.alarm = 0
  Player_Destroy(gameScene.player)
  Map_Destroy(gameScene.map)
  HeartsHud_Destroy(gameScene.hud)
  DeleteSprite(gameScene.button)
  DeleteSprite(gameScene.background)
  SetViewOffset(0, 0)
  DeleteMusicOGG(gameScene.music)
  StopSound(SoundManager_Get(g.soundManager, "alarm"))
endfunction

// PRIVATE
// =============================================================================
function GameScene_CreateEnemies()
  gameScene.enemies.insert(Enemy_Create(125, 106))
  gameScene.enemies.insert(Enemy_Create(75, 66))
  gameScene.enemies.insert(Enemy_Create(125, 30))
  gameScene.enemies.insert(Enemy_Create(50, 30))
endfunction

function GameScene_CreateNextLevelButton()
  image = LoadImage("images/button.png")
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  button = CreateSprite(image)
  SetSpriteAnimation(button, 6, 3, 2)
  gameScene.button = button
  SetSpritePosition(button, 145, 29)
endfunction

function CenterCameraOnSprite(sprite as integer)
	spriteCenterX = GetSpriteX(sprite) + GetSpriteOffsetX(sprite)
	spriteCenterY = GetSpriteY(sprite) + GetSpriteOffsetY(sprite)
	screenWidth = GetVirtualWidth()
	screenHeight = GetVirtualHeight()
  x = Round(Clamp(spriteCenterX - (screenWidth / 2), 0, Map_GetWidth(gameScene.map) - screenWidth))
  y = Round(Clamp(spriteCenterY - (screenHeight / 2), 0, Map_GetHeight(gameScene.map) - screenHeight))
	SetViewOffset(x, y)
endfunction

function GameScene_UpdateEnemies(delta#)
  for i = 0 to gameScene.enemies.length
    if gameScene.enemies[i].alive = 0
      gameScene.enemies.remove(i)
      continue
    endif

    if gameScene.alarm = 0
      if gameScene.enemies[i].state = ENEMY_STATE_ATTACKING then gameScene.alarm = 1
    else
      if gameScene.enemies[i].state <> ENEMY_STATE_ATTACKING then Enemy_AttackingState_Initialize(gameScene.enemies[i])
    endif

    Enemy_Update(gameScene.enemies[i], gameScene.player, delta#)
  next i
endfunction

function GameScene_UpdateNextLevelButton()
  if GetSpriteCollision(gameScene.player.sprite, gameScene.button)
    if GetSpriteCurrentFrame(gameScene.button) <> 2 then SetSpriteFrame(gameScene.button, 2)
    if gameScene.enemies.length = -1 then g.currentScene = SCENES_WIN_SCENE
  else
    if GetSpriteCurrentFrame(gameScene.button) <> 1 then SetSpriteFrame(gameScene.button, 1)
  endif
endfunction

function GameScene_CreateBackground()
  image = LoadImage("images/bg-1.png")
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  sprite = CreateSprite(image)
  SetSpriteDepth(sprite, 2000)
  SetSpriteY(sprite, Map_GetHeight(gameScene.map) - GetSpriteHeight(sprite))
  SetSpriteSnap(sprite, 1)
endfunction sprite

function GameScene_UpdateBackground()
  SetSpritePosition(gameScene.background, GetViewOffsetX() / 2, GetViewOffsetY() / 2)
endfunction

function GameScene_TransitionToNextScene()
  GameScene_Destroy()
  CreateCurrentScene()
endfunction

function GameScene_CheckBullets()
  if GetSpriteFirstContact(gameScene.player.sprite) = 1
    repeat
      other = GetSpriteContactSpriteID2()
      group = GetSpriteGroup(other)

      if group = SPRITE_ENEMY_PROJECTILE_GROUP
        SetSpritePhysicsOff(other)
        SetSpriteVisible(other, 0)

        if Player_IsBlinking(gameScene.player) = 0
          PlaySound(SoundManager_Get(g.soundManager, "hit"), SOUND_VOLUME)
          // TODO Make particle explosion

          HeartsHud_Pop(gameScene.hud)
          Player_Blink(gameScene.player)
          gameScene.lives = gameScene.lives - 1
          if gameScene.lives = 0 then g.currentScene = SCENES_GAME_OVER_SCENE
        endif
      endif
    until GetSpriteNextContact() = 0
  endif
endfunction

function GameScene_PlayAlarmIfNeeded()
  if gameScene.alarm and gameScene.alarmPlaying = 0
    gameScene.alarmPlaying = 1
    PlaySound(SoundManager_Get(g.soundManager, "alarm"), SOUND_VOLUME - 10, 1)
  endif
endfunction
