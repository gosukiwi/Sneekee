#constant WIN_SCENE_DURATION 5

type tWinScene
  music as integer
  sprite as tSimpleSprite
  started as float
endtype

function WinScene_Create()
  scene as tWinScene
  scene.music = LoadMusicOGG("music/menu.ogg")
  scene.sprite = SimpleSprite_Create("images/win.png")
  scene.started = Timer()
  SetSpriteSize(scene.sprite.sprite, 64, 64)
  SetMusicSystemVolumeOGG(MUSIC_VOLUME)
  PlayMusicOGG(scene.music, 1)
endfunction scene

function WinScene_Update(scene ref as tWinScene, delta as float)
  if Timer() - scene.started > WIN_SCENE_DURATION or GetRawKeyPressed(KEY_ESCAPE) or GetRawKeyPressed(KEY_ENTER)
    WinScene_Destroy(scene) // TODO: can we do this in current scene? destroy currrent?
    SetCurrentScene(g.sceneManager, SCENES_CREDITS_SCENE)
  endif
endfunction

function WinScene_Destroy(scene ref as tWinScene)
  DeleteMusicOGG(scene.music)
  SimpleSprite_Destroy(scene.sprite)
endfunction
