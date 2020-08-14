#constant MAIN_MENU_PLAY_BUTTON    1
#constant MAIN_MENU_EXIT_BUTTON    2
#constant MAIN_MENU_CREDITS_BUTTON 3

type tMainMenuButton
  id as integer
  upImage as integer
  downImage as integer
endtype

type tMainMenuScene
  bgImage as integer
  bgSprite as integer
  playButton as tMainMenuButton
  creditsButton as tMainMenuButton
  exitButton as tMainMenuButton
  music as integer
endtype

function MainMenuScene_Create()
  image = LoadImage("images/main-menu.png")
  SetImageMagFilter(image, 0)
  SetImageMinFilter(image, 0)
  sprite = CreateSprite(image)

  playButton as tMainMenuButton
  playButton.id = MAIN_MENU_PLAY_BUTTON
  playButton.upImage = LoadImage("images/play-button.png")
  playButton.downImage = LoadImage("images/play-button-down.png")
  SetImageMagFilter(playButton.upImage, 0)
  SetImageMinFilter(playButton.upImage, 0)
  SetImageMagFilter(playButton.downImage, 0)
  SetImageMinFilter(playButton.downImage, 0)
  AddVirtualButton(MAIN_MENU_PLAY_BUTTON, 32, 35, 20)
  SetVirtualButtonAlpha(MAIN_MENU_PLAY_BUTTON, 255)
  SetVirtualButtonImageUp(MAIN_MENU_PLAY_BUTTON, playButton.upImage)
  SetVirtualButtonImageDown(MAIN_MENU_PLAY_BUTTON, playButton.downImage)

  creditsButton as tMainMenuButton
  creditsButton.id = MAIN_MENU_CREDITS_BUTTON
  creditsButton.upImage = LoadImage("images/credits-button.png")
  creditsButton.downImage = LoadImage("images/credits-button-down.png")
  SetImageMagFilter(creditsButton.upImage, 0)
  SetImageMinFilter(creditsButton.upImage, 0)
  SetImageMagFilter(creditsButton.downImage, 0)
  SetImageMinFilter(creditsButton.downImage, 0)
  AddVirtualButton(MAIN_MENU_CREDITS_BUTTON, 32, 45, 32)
  SetVirtualButtonAlpha(MAIN_MENU_CREDITS_BUTTON, 255)
  SetVirtualButtonImageUp(MAIN_MENU_CREDITS_BUTTON, creditsButton.upImage)
  SetVirtualButtonImageDown(MAIN_MENU_CREDITS_BUTTON, creditsButton.downImage)

  exitButton as tMainMenuButton
  exitButton.id = MAIN_MENU_EXIT_BUTTON
  exitButton.upImage = LoadImage("images/exit-button.png")
  exitButton.downImage = LoadImage("images/exit-button-down.png")
  SetImageMagFilter(exitButton.upImage, 0)
  SetImageMinFilter(exitButton.upImage, 0)
  SetImageMagFilter(exitButton.downImage, 0)
  SetImageMinFilter(exitButton.downImage, 0)
  AddVirtualButton(MAIN_MENU_EXIT_BUTTON, 32, 55, 20)
  SetVirtualButtonAlpha(MAIN_MENU_EXIT_BUTTON, 255)
  SetVirtualButtonImageUp(MAIN_MENU_EXIT_BUTTON, exitButton.upImage)
  SetVirtualButtonImageDown(MAIN_MENU_EXIT_BUTTON, exitButton.downImage)

  // chevronImage = LoadImage("images/chevron.png")
  // SetImageMagFilter(chevronImage, 0)
  // SetImageMinFilter(chevronImage, 0)
  // chevron = CreateSprite(chevronImage)
  // SetSpritePosition(chevron, 15, 32)

  scene as tMainMenuScene
  scene.bgImage = image
  scene.bgSprite = sprite
  scene.playButton = playButton
  scene.creditsButton = creditsButton
  scene.exitButton = exitButton
  scene.music = LoadMusicOGG("music/menu.ogg")
  SetMusicSystemVolumeOGG(MUSIC_VOLUME)
  PlayMusicOGG(scene.music, 1)
endfunction scene

function MainMenuScene_Update(scene ref as tMainMenuScene, delta as float)
  if GetVirtualButtonPressed(MAIN_MENU_PLAY_BUTTON) or GetRawKeyPressed(KEY_ENTER) or GetRawKeyPressed(KEY_SPACE)
    MainMenuScene_Destroy(scene)
    SceneManager_SetCurrent(g.sceneManager, SCENES_GAME_SCENE)
  elseif GetVirtualButtonPressed(MAIN_MENU_CREDITS_BUTTON)
    MainMenuScene_Destroy(scene)
    SceneManager_SetCurrent(g.sceneManager, SCENES_CREDITS_SCENE)
  elseif GetVirtualButtonPressed(MAIN_MENU_EXIT_BUTTON) or GetRawKeyPressed(KEY_ESCAPE)
    end
  endif
endfunction

function MainMenuScene_Destroy(scene ref as tMainMenuScene)
  DeleteSprite(scene.bgSprite)
  DeleteImage(scene.bgImage)
  MainMenuButton_Destroy(scene.playButton)
  MainMenuButton_Destroy(scene.creditsButton)
  MainMenuButton_Destroy(scene.exitButton)
  DeleteMusicOGG(scene.music)
endfunction

// PRIVATE
// =============================================================================
function MainMenuButton_Destroy(button ref as tMainMenuButton)
  DeleteVirtualButton(button.id)
  DeleteImage(button.upImage)
  DeleteImage(button.downImage)
endfunction
