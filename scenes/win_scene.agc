#constant WIN_SCENE_DURATION 5

type tWinScene
  music as integer
  sprite as tSimpleSprite
  started as float
endtype

function WinScene_Create()
  global winScene as tWinScene
  winScene.music = LoadMusicOGG("music/menu.ogg")
  winScene.sprite = SimpleSprite_Create("images/win.png")
  winScene.started = Timer()
  SetSpriteSize(winScene.sprite.sprite, 64, 64)
  SetMusicSystemVolumeOGG(MUSIC_VOLUME)
  PlayMusicOGG(winScene.music, 1)
endfunction

function WinScene_Update(delta as float)
  if Timer() - winScene.started > WIN_SCENE_DURATION or GetRawKeyPressed(KEY_ESCAPE) or GetRawKeyPressed(KEY_ENTER)
    WinScene_Destroy() // TODO: can we do this in current scene? destroy currrent?
    SetCurrentScene(SCENES_CREDITS_SCENE)
  endif
endfunction

function WinScene_Destroy()
  DeleteMusicOGG(winScene.music)
  SimpleSprite_Destroy(winScene.sprite)
endfunction
