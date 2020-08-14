#constant CREDITS_SPEED 2

type tCreditsScene
  music as integer
  credits as tSimpleSprite
  logo as tSimpleSprite
endtype

function CreditsScene_Create()
  scene as tCreditsScene
  scene.music = LoadMusicOGG("music/gameover.ogg")
  scene.credits = SimpleSprite_Create("images/credits.png")
  scene.logo = SimpleSprite_Create("images/agk.png")
  SetSpriteSize(scene.credits.sprite, 64, 64)
  SetSpriteSize(scene.logo.sprite, 32, 32)
  SetSpritePosition(scene.logo.sprite, 32 - 16, 60)
  SetMusicSystemVolumeOGG(MUSIC_VOLUME)
  PlayMusicOGG(scene.music, 1)
endfunction scene

function CreditsScene_Update(scene ref as tCreditsScene, delta as float)
  SetSpritePosition(scene.credits.sprite, GetSpriteX(scene.credits.sprite), GetSpriteY(scene.credits.sprite) - CREDITS_SPEED * delta)
  SetSpritePosition(scene.logo.sprite, GetSpriteX(scene.logo.sprite), GetSpriteY(scene.logo.sprite) - CREDITS_SPEED * delta)

  if GetRawKeyPressed(KEY_ESCAPE) or GetRawKeyPressed(KEY_ENTER)
    CreditsScene_Destroy(scene) // TODO: can we do this in current scene? destroy currrent?
    SetCurrentScene(g.sceneManager, SCENES_MAIN_MENU_SCENE)
  endif
endfunction

function CreditsScene_Destroy(scene ref as tCreditsScene)
  DeleteMusicOGG(scene.music)
  SimpleSprite_Destroy(scene.credits)
  SimpleSprite_Destroy(scene.logo)
endfunction
