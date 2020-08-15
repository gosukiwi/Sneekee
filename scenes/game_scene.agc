type tGameScene
  player as tPlayer
  enemies as tEnemy[]
  map as tMap
  alarm as integer
  alarmPlaying as integer
  background as integer
  button as integer
  hud as tHeartsHud
  shurihud as tShurikensHud
  music as integer
  level as integer
  mustIncreaseLevel as integer
  signs as tSign[]
endtype

function GameScene_Create(level)
  if DEBUGGING then SetPhysicsDebugOn()
  SetPhysicsGravity(0, 130)

  scene as tGameScene
  if level = 2
    scene = GameScene_CreateLevel2()
  elseif level = 3
    scene = GameScene_CreateLevel3()
  elseif level = 4
    scene = GameScene_CreateLevel4()
  elseif level = 5
    scene = GameScene_CreateLevel5()
  else
    scene = GameScene_CreateLevel1()
  endif
  scene.level = level
endfunction scene

function GameScene_Update(scene ref as tGameScene, delta#)
  Player_Update(scene.player, delta#)
  GameScene_PollInput(scene)
  GameScene_UpdateEnemies(scene, delta#)
  GameScene_CheckPhysicsCollisions(scene)
  GameScene_UpdateNextLevelButton(scene)
  GameScene_PlayAlarmIfNeeded(scene)
  CenterCameraOnPlayer(scene)
  GameScene_UpdateBackground(scene)

  if scene.mustIncreaseLevel
    GameScene_Destroy(scene)
    g.sceneManager.gameScene = GameScene_Create(scene.level + 1)
  elseif g.sceneManager.current <> SCENES_GAME_SCENE
    GameScene_Destroy(scene)
    SceneManager_CreateCurrent(g.sceneManager)
  endif
endfunction

// Clean everything up for next scene, as if nothing happened!
function GameScene_Destroy(scene ref as tGameScene)
  for i = 0 to scene.enemies.length
    Enemy_Destroy(scene.enemies[i], 1)
  next i
  scene.enemies.length = -1
  scene.alarm = 0
  Player_Destroy(scene.player)
  Map_Destroy(scene.map)
  HeartsHud_Destroy(scene.hud)
  ShurikensHud_Destroy(scene.shurihud)
  CollectableManager_Destroy(g.lifeCollectables)
  CollectableManager_Destroy(g.shurikenCollectables)
  DeleteSprite(scene.button)
  DeleteSprite(scene.background)
  SetViewOffset(0, 0)
  DeleteMusicOGG(scene.music)
  StopSound(SoundManager_Get(g.soundManager, "alarm"))
  for i = 0 to scene.signs.length
    Sign_Destroy(scene.signs[i])
  next i
  scene.signs.length = -1
endfunction

// PRIVATE
// =============================================================================
// LEVELS
// =============================================================================
function GameScene_CreateLevel1()
  g.lives = PLAYER_INITIAL_LIVES
  g.shurikens = PLAYER_INITIAL_SHURIKENS
  GameScene_CreateGlobalCollectables()

  scene as tGameScene
  scene.map = Map_Create("maps/map-1.json", Tileset_Create("images/map-tiles.png", 64, "map-tiles"))
  scene.player = Player_Create(9, Map_GetHeight(scene.map) - 10)
  scene.background = GameScene_CreateBackground("images/bg-1.png", scene.map)
  scene.hud = HeartsHud_Create(g.lives)
  scene.shurihud = ShurikensHud_Create(g.shurikens)
  scene.button = GameScene_CreateNextLevelButton(145, 29)
  scene.music = GameScene_CreateMusic("music/ingame.ogg")
  scene.alarm = 0
  scene.alarmPlaying = 0
  scene.enemies.insert(Enemy_Create(125, 106, ENEMY_DROPS_SHURIKEN))
  scene.enemies.insert(Enemy_Create(75, 66, ENEMY_DROPS_NOTHING))
  scene.enemies.insert(Enemy_Create(50, 30, ENEMY_DROPS_NOTHING))
  scene.enemies.insert(Enemy_Create(125, 30, ENEMY_DROPS_LIFE))
  scene.signs.insert(Sign_Create("images/wasd.png", 20, 98, DEPTH_FRONT))
  scene.signs.insert(Sign_Create("images/space.png", 75, 88, DEPTH_MIDDLE))
  scene.signs.insert(Sign_Create("images/ctrl.png", 100, 58, DEPTH_MIDDLE))
endfunction scene

function GameScene_CreateLevel2()
  GameScene_CreateGlobalCollectables()
  scene as tGameScene
  scene.map = Map_Create("maps/map-2.json", Tileset_Create("images/map-tiles.png", 64, "map-tiles"))
  scene.player = Player_Create(140, Map_GetHeight(scene.map) - 10)
  scene.background = GameScene_CreateBackground("images/bg-1.png", scene.map)
  scene.hud = HeartsHud_Create(g.lives)
  scene.shurihud = ShurikensHud_Create(g.shurikens)
  scene.button = GameScene_CreateNextLevelButton(145, 37)
  scene.music = GameScene_CreateMusic("music/ingame.ogg")
  scene.alarm = 0
  scene.alarmPlaying = 0
  scene.enemies.insert(Enemy_Create(25, 106, ENEMY_DROPS_NOTHING))
  scene.enemies.insert(Enemy_Create(96, 72, ENEMY_DROPS_LIFE))
  scene.enemies.insert(Enemy_Create(72, 40, ENEMY_DROPS_SHURIKEN))
endfunction scene

function GameScene_CreateLevel3()
  GameScene_CreateGlobalCollectables()
  scene as tGameScene
  scene.map = Map_Create("maps/map-3.json", Tileset_Create("images/map-tiles.png", 64, "map-tiles"))
  scene.player = Player_Create(9, Map_GetHeight(scene.map) - 10)
  scene.background = GameScene_CreateBackground("images/bg-1.png", scene.map)
  scene.hud = HeartsHud_Create(g.lives)
  scene.shurihud = ShurikensHud_Create(g.shurikens)
  scene.button = GameScene_CreateNextLevelButton(9, 37)
  scene.music = GameScene_CreateMusic("music/ingame.ogg")
  scene.alarm = 0
  scene.alarmPlaying = 0
  scene.enemies.insert(Enemy_Create(112, 104, ENEMY_DROPS_NOTHING))
  scene.enemies.insert(Enemy_Create(105, 72, ENEMY_DROPS_LIFE))
  scene.enemies.insert(Enemy_Create(25, 72, ENEMY_DROPS_NOTHING))
  scene.enemies.insert(Enemy_Create(120, 32, ENEMY_DROPS_NOTHING))
endfunction scene

function GameScene_CreateLevel4()
  GameScene_CreateGlobalCollectables()
  scene as tGameScene
  scene.map = Map_Create("maps/map-4.json", Tileset_Create("images/map-tiles.png", 64, "map-tiles"))
  scene.player = Player_Create(9, Map_GetHeight(scene.map) - 10)
  scene.background = GameScene_CreateBackground("images/bg-1.png", scene.map)
  scene.hud = HeartsHud_Create(g.lives)
  scene.shurihud = ShurikensHud_Create(g.shurikens)
  scene.button = GameScene_CreateNextLevelButton(145, 13)
  scene.music = GameScene_CreateMusic("music/ingame.ogg")
  scene.alarm = 0
  scene.alarmPlaying = 0
  scene.enemies.insert(Enemy_Create(80, 104, ENEMY_DROPS_SHURIKEN))
  scene.enemies.insert(Enemy_Create(88, 72, ENEMY_DROPS_LIFE))
  scene.enemies.insert(Enemy_Create(108, 40, ENEMY_DROPS_NOTHING))
  scene.enemies.insert(Enemy_Create(128, 8, ENEMY_DROPS_NOTHING))
endfunction scene

function GameScene_CreateLevel5()
  g.lives = PLAYER_INITIAL_LIVES
  g.shurikens = PLAYER_INITIAL_SHURIKENS
  GameScene_CreateGlobalCollectables()
  scene as tGameScene
  scene.map = Map_Create("maps/map-5.json", Tileset_Create("images/map-tiles.png", 64, "map-tiles"))
  scene.player = Player_Create(140, Map_GetHeight(scene.map) - 10)
  scene.background = GameScene_CreateBackground("images/bg-1.png", scene.map)
  scene.hud = HeartsHud_Create(g.lives)
  scene.shurihud = ShurikensHud_Create(g.shurikens)
  scene.button = GameScene_CreateNextLevelButton(145, 13)
  scene.music = GameScene_CreateMusic("music/ingame.ogg")
  scene.alarm = 0
  scene.alarmPlaying = 0
  scene.enemies.insert(Enemy_Create(40, 104, ENEMY_DROPS_SHURIKEN))
  scene.enemies.insert(Enemy_Create(80, 80, ENEMY_DROPS_NOTHING))
  scene.enemies.insert(Enemy_Create(112, 40, ENEMY_DROPS_NOTHING))
  scene.enemies.insert(Enemy_Create(80, 56, ENEMY_DROPS_NOTHING))
  scene.enemies.insert(Enemy_Create(23, 56, ENEMY_DROPS_SHURIKEN))
  scene.enemies.insert(Enemy_Create(48, 8, ENEMY_DROPS_NOTHING))
endfunction scene
// =============================================================================

function GameScene_CreateNextLevelButton(x, y)
  image = LoadImage("images/button.png")
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  button = CreateSprite(image)
  SetSpriteAnimation(button, 6, 3, 2)
  SetSpritePosition(button, x, y)
endfunction button

function CenterCameraOnPlayer(scene ref as tGameScene)
	spriteCenterX = GetSpriteX(scene.player.sprite) + GetSpriteOffsetX(scene.player.sprite)
	spriteCenterY = GetSpriteY(scene.player.sprite) + GetSpriteOffsetY(scene.player.sprite)
	screenWidth = GetVirtualWidth()
	screenHeight = GetVirtualHeight()
  x = Round(Clamp(spriteCenterX - (screenWidth / 2), 0, Map_GetWidth(scene.map) - screenWidth))
  y = Round(Clamp(spriteCenterY - (screenHeight / 2), 0, Map_GetHeight(scene.map) - screenHeight))
	SetViewOffset(x, y)
endfunction

function GameScene_UpdateEnemies(scene ref as tGameScene, delta#)
  for i = 0 to scene.enemies.length
    if scene.enemies[i].alive = 0
      scene.enemies.remove(i)
      continue
    endif

    if scene.alarm = 0
      if scene.enemies[i].state = ENEMY_STATE_ATTACKING then scene.alarm = 1
    else
      if scene.enemies[i].state <> ENEMY_STATE_ATTACKING then Enemy_AttackingState_Initialize(scene.enemies[i])
    endif

    Enemy_Update(scene.enemies[i], scene.player, delta#)
  next i
endfunction

function GameScene_UpdateNextLevelButton(scene ref as tGameScene)
  if GetSpriteCollision(scene.player.sprite, scene.button)
    if GetSpriteCurrentFrame(scene.button) <> 2 then SetSpriteFrame(scene.button, 2)
    if scene.enemies.length = -1 // No more enemies!
      if scene.level = LAST_LEVEL
        g.sceneManager.current = SCENES_WIN_SCENE
      else
        scene.mustIncreaseLevel = 1
      endif
    endif
  else
    if GetSpriteCurrentFrame(scene.button) <> 1 then SetSpriteFrame(scene.button, 1)
  endif
endfunction

function GameScene_CreateBackground(file as string, map ref as tMap)
  image = LoadImage(file)
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  sprite = CreateSprite(image)
  SetSpriteDepth(sprite, 2000)
  SetSpriteY(sprite, Map_GetHeight(map) - GetSpriteHeight(sprite))
  SetSpriteSnap(sprite, 1)
endfunction sprite

function GameScene_UpdateBackground(scene ref as tGameScene)
  SetSpritePosition(scene.background, GetViewOffsetX() / 2, GetViewOffsetY() / 2)
endfunction

function GameScene_CheckPhysicsCollisions(scene ref as tGameScene)
  if GetSpriteFirstContact(scene.player.sprite) = 1
    repeat
      other = GetSpriteContactSpriteID2()
      group = GetSpriteGroup(other)

      if group = SPRITE_ENEMY_PROJECTILE_GROUP
        SetSpritePhysicsOff(other)
        SetSpriteVisible(other, 0)

        if Player_IsBlinking(scene.player) = 0
          PlaySound(SoundManager_Get(g.soundManager, "hit"), SOUND_VOLUME)
          HeartsHud_Pop(scene.hud)
          Player_Blink(scene.player)
          // TODO Make particle explosion

          if DEBUGGING = 0
            g.lives = g.lives - 1
            if g.lives <= 0 then g.sceneManager.current = SCENES_GAME_OVER_SCENE
          endif
        endif
      elseif group = SPRITE_LIVES_GROUP
        DeleteSprite(other)
        g.lives = g.lives + 1
        HeartsHud_Push(scene.hud)
        PlaySound(SoundManager_Get(g.soundManager, "lifeup"), SOUND_VOLUME)
      elseif group = SPRITE_SHURIKEN_COLLECTABLE_GROUP
        DeleteSprite(other)
        g.shurikens = g.shurikens + 1
        ShurikensHud_Push(scene.shurihud)
        PlaySound(SoundManager_Get(g.soundManager, "lifeup"), SOUND_VOLUME)
      endif
    until GetSpriteNextContact() = 0
  endif
endfunction

function GameScene_PlayAlarmIfNeeded(scene ref as tGameScene)
  if scene.alarm and scene.alarmPlaying = 0
    scene.alarmPlaying = 1
    PlaySound(SoundManager_Get(g.soundManager, "alarm"), SOUND_VOLUME - 10, 1)
  endif
endfunction

function GameScene_CreateMusic(file as string)
  music = LoadMusicOGG(file)
  SetMusicVolumeOGG(music, MUSIC_VOLUME)
  PlayMusicOGG(music, 1)
endfunction music

function GameScene_PollInput(scene ref as tGameScene)
  if GetRawMouseRightPressed() and g.shurikens > 0
    g.shurikens = g.shurikens - 1
    ShurikensHud_Pop(scene.shurihud)
    Player_ThrowShuriken(scene.player)
  endif
endfunction

function GameScene_CreateGlobalCollectables()
  g.lifeCollectables = CollectableManager_Create(LoadImage("images/heart-small.png"), SPRITE_LIVES_GROUP)
  g.shurikenCollectables = CollectableManager_Create(LoadImage("images/shuriken.png"), SPRITE_SHURIKEN_COLLECTABLE_GROUP)
endfunction
