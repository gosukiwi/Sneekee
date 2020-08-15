type tGameOverScene
  music as integer
  sprite as tSimpleSprite
endtype

function GameOverScene_Create()
  scene as tGameOverScene
  scene.music = LoadMusicOGG("music/gameover.ogg")
  scene.sprite = SimpleSprite_Create("images/gameover.png")
  SetSpriteSize(scene.sprite.sprite, 64, 64)
  SetMusicSystemVolumeOGG(MUSIC_VOLUME)
  PlayMusicOGG(scene.music, 1)
endfunction scene

function GameOverScene_Update(scene ref as tGameOverScene, delta as float)
  if GetRawKeyPressed(KEY_ENTER)
    GameOverScene_Destroy(scene)
    SceneManager_SetCurrent(g.sceneManager, SCENES_GAME_SCENE)
  elseif GetRawKeyPressed(KEY_ESCAPE)
    GameOverScene_Destroy(scene)
    g.lastClear = INITIAL_LEVEL
    SceneManager_SetCurrent(g.sceneManager, SCENES_MAIN_MENU_SCENE)
  endif
endfunction

function GameOverScene_Destroy(scene ref as tGameOverScene)
  DeleteMusicOGG(scene.music)
  SimpleSprite_Destroy(scene.sprite)
endfunction
