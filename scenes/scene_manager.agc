#constant SCENES_MAIN_MENU_SCENE 0
#constant SCENES_GAME_SCENE      1
#constant SCENES_LEVEL2          2
#constant SCENES_WIN_SCENE       3
#constant SCENES_GAME_OVER_SCENE 4
#constant SCENES_CREDITS_SCENE   5

type tSceneManager
  mainMenuScene as tMainMenuScene
  gameScene as tGameScene
  winScene as tWinScene
  gameOverScene as tGameOverScene
  creditsScene as tCreditsScene
  current as integer
endtype

function SceneManager_Create(initial as integer)
  manager as tSceneManager
  SetCurrentScene(manager, initial)
endfunction manager

function UpdateCurrentScene(manager ref as tSceneManager, delta#)
  select manager.current
    case SCENES_GAME_SCENE
      GameScene_Update(manager.gameScene, delta#)
    endcase
    case SCENES_MAIN_MENU_SCENE
      MainMenuScene_Update(delta#)
    endcase
    case SCENES_WIN_SCENE
      WinScene_Update(delta#)
    endcase
    case SCENES_GAME_OVER_SCENE
      GameOverScene_Update(delta#)
    endcase
    case SCENES_CREDITS_SCENE
      CreditsScene_Update(manager.creditsScene, delta#)
    endcase
  endselect
endfunction

function CreateCurrentScene(manager ref as tSceneManager)
  select manager.current
    case SCENES_GAME_SCENE
      manager.gameScene = GameScene_Create(1)
    endcase
    case SCENES_MAIN_MENU_SCENE
      // manager.mainMenuScene = MainMenuScene_Create()
      MainMenuScene_Create()
    endcase
    case SCENES_WIN_SCENE
      // manager.winScene = WinScene_Create()
      WinScene_Create()
    endcase
    case SCENES_GAME_OVER_SCENE
      // manager.gameOverScene = GameOverScene_Create()
      GameOverScene_Create()
    endcase
    case SCENES_CREDITS_SCENE
      manager.creditsScene = CreditsScene_Create()
    endcase
  endselect
endfunction

function SetCurrentScene(manager ref as tSceneManager, scene as integer)
  manager.current = scene
  CreateCurrentScene(g.sceneManager) // TODO: Rename to `CreateScene(scene)`
endfunction
