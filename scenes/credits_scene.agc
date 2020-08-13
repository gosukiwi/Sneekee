#constant CREDITS_SPEED 2

type tCreditsScene
  music as integer
  credits as tSimpleSprite
  logo as tSimpleSprite
endtype

function CreditsScene_Create()
  global creditsScene as tCreditsScene
  creditsScene.music = LoadMusicOGG("music/gameover.ogg")
  creditsScene.credits = SimpleSprite_Create("images/credits.png")
  creditsScene.logo = SimpleSprite_Create("images/agk.png")
  SetSpriteSize(creditsScene.credits.sprite, 64, 64)
  SetSpriteSize(creditsScene.logo.sprite, 32, 32)
  SetSpritePosition(creditsScene.logo.sprite, 32 - 16, 60)
  SetMusicSystemVolumeOGG(MUSIC_VOLUME)
  PlayMusicOGG(creditsScene.music, 1)
endfunction

function CreditsScene_Update(delta as float)
  SetSpritePosition(creditsScene.credits.sprite, GetSpriteX(creditsScene.credits.sprite), GetSpriteY(creditsScene.credits.sprite) - CREDITS_SPEED * delta)
  SetSpritePosition(creditsScene.logo.sprite, GetSpriteX(creditsScene.logo.sprite), GetSpriteY(creditsScene.logo.sprite) - CREDITS_SPEED * delta)

  if GetRawKeyPressed(KEY_ESCAPE) or GetRawKeyPressed(KEY_ENTER)
    CreditsScene_Destroy() // TODO: can we do this in current scene? destroy currrent?
    SetCurrentScene(SCENES_MAIN_MENU_SCENE)
  endif
endfunction

function CreditsScene_Destroy()
  DeleteMusicOGG(creditsScene.music)
  SimpleSprite_Destroy(creditsScene.credits)
  SimpleSprite_Destroy(creditsScene.logo)
endfunction
