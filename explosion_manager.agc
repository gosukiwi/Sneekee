REMSTART
  The explosion manager creates explosions at some place and then removes them
  once they are done.

  Usage:

  manager as tExplosionManager
  ExplosionManager_Add(manager, 100, 100) // create an explosion at 100, 100
  //... in update loop
  ExplosionManager_Update(manager)
REMEND

type tExplosionManager
  image as integer
  explosions as integer[]
endtype

function ExplosionManager_Create()
  manager as tExplosionManager
  manager.image = LoadImage("images/explosion.png")
	SetImageMagFilter(manager.image, 0) // These two instuctions make it so
	SetImageMinFilter(manager.image, 0) // resizing is pixel-perfect!
endfunction manager

function ExplosionManager_Add(manager ref as tExplosionManager, x as float, y as float)
  explosion = CreateSprite(manager.image)
	SetSpriteUVBorder(explosion, 0)
  SetSpriteAnimation(explosion, 12, 12, 47)
  SetSpritePosition(explosion, x, y)
  manager.explosions.insert(explosion)
  PlaySprite(explosion, 60, 0)
endfunction

function ExplosionManager_AddAtSprite(manager ref as tExplosionManager, sprite as integer)
  x# = GetSpriteX(sprite) + GetSpriteOffsetX(sprite) - 6 // each frame of the explosion is 12x12
  y# = GetSpriteY(sprite) + GetSpriteOffsetY(sprite) - 6 // so were we just get half of it
  ExplosionManager_Add(manager, x#, y#)
endfunction

function ExplosionManager_Update(manager ref as tExplosionManager)
  for i = 0 to manager.explosions.length
    if GetSpritePlaying(manager.explosions[i]) = 0
      DeleteSprite(manager.explosions[i])
      manager.explosions.remove(i)
    endif
  next i
endfunction
