type tGameOverScene
  music as integer
  sprite as tSimpleSprite
endtype

function GameOverScene_Create()
  global gameOverScene as tGameOverScene
  gameOverScene.music = LoadMusicOGG("music/gameover.ogg")
  gameOverScene.sprite = SimpleSprite_Create("images/gameover.png")
  SetSpriteSize(gameOverScene.sprite.sprite, 64, 64)
  SetMusicSystemVolumeOGG(MUSIC_VOLUME)
  PlayMusicOGG(gameOverScene.music, 1)
endfunction

function GameOverScene_Update(delta as float)
  if GetRawKeyPressed(KEY_ESCAPE) or GetRawKeyPressed(KEY_ENTER)
    GameOverScene_Destroy()
    SetCurrentScene(SCENES_MAIN_MENU_SCENE)
  endif
endfunction

function GameOverScene_Destroy()
  DeleteMusicOGG(gameOverScene.music)
  SimpleSprite_Destroy(gameOverScene.sprite)
endfunction
