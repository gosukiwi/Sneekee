// Project: neekee
// Created: 2020-08-06
#include "util/keys.agc"
#include "util/math.agc"
#include "util/physics.agc"
#include "util/vector.agc"
#include "util/simple_sprite.agc"
#include "constants.agc"
#include "map.agc"
#include "tileset.agc"
#include "sound_manager.agc"
#include "projectile_manager.agc"
#include "explosion_manager.agc"
#include "player.agc"
#include "enemy.agc"
#include "hearts_hud.agc"
#include "blink_tween.agc"
#include "scenes/scene_manager.agc"
#include "scenes/main_menu_scene.agc"
#include "scenes/credits_scene.agc"
#include "scenes/game_scene.agc"
#include "scenes/win_scene.agc"
#include "scenes/game_over_scene.agc"

SetErrorMode(2) // show all errors
SetWindowTitle("sneekee")
SetWindowSize(720, 720, 0)
SetWindowAllowResize(1) // allow the user to resize the window
SetVirtualResolution(64, 64) // doesn't have to match the window
SetSyncRate(60, 0)
SetScissor(0,0,0,0) // use the maximum available screen space, no black borders

type tState
  soundManager as tSoundManager
  explosionManager as tExplosionManager
  sceneManager as tSceneManager
endtype
global g as tState

g.explosionManager = ExplosionManager_Create()
g.soundManager = SoundManager_Create()
g.sceneManager = SceneManager_Create()
SetCurrentScene(g.sceneManager, SCENES_MAIN_MENU_SCENE)
LoadAllSounds()

elapsed# = 0
do
  newTime# = Timer()
  delta# = newTime# - elapsed#
  elapsed# = newTime#

  UpdateCurrentScene(g.sceneManager, delta#)
  ExplosionManager_Update(g.explosionManager)

  if DEBUGGING then Print(ScreenFPS())
  Sync()
loop

function LoadAllSounds()
  SoundManager_Register(g.soundManager, "explosion", "sound/explosion.ogg")
  SoundManager_Register(g.soundManager, "woosh", "sound/woosh.ogg")
  SoundManager_Register(g.soundManager, "jump", "sound/jump.ogg")
  SoundManager_Register(g.soundManager, "hit", "sound/hit.ogg")
  SoundManager_Register(g.soundManager, "alarm", "sound/alarm.ogg")
endfunction
