function UpdateCurrentScene(delta#)
  select g.currentScene
    case SCENES_GAME_SCENE
      GameScene_Update(delta#)
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
      CreditsScene_Update(delta#)
    endcase
  endselect
endfunction

function CreateCurrentScene()
  select g.currentScene
    case SCENES_GAME_SCENE
      GameScene_Create()
    endcase
    case SCENES_MAIN_MENU_SCENE
      MainMenuScene_Create()
    endcase
    case SCENES_WIN_SCENE
      WinScene_Create()
    endcase
    case SCENES_GAME_OVER_SCENE
      GameOverScene_Create()
    endcase
    case SCENES_CREDITS_SCENE
      CreditsScene_Create()
    endcase
  endselect
endfunction

function SetCurrentScene(scene as integer)
  g.currentScene = scene
  CreateCurrentScene()
endfunction
