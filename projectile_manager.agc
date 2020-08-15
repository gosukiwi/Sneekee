type tProjectile
  sprite as integer
  direction as tVector
  createdAt as float
endtype

type tProjectileManager
  image as integer
  group as integer
  projectiles as tProjectile[]
  collideBits as integer
  lifetime as float
endtype

function ProjectileManager_Create(image as integer, group as integer, collideBits as integer, lifetime as float)
  manager as tProjectileManager
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  manager.image = image
  manager.group = group
  manager.collideBits = collideBits
  manager.lifetime = lifetime
endfunction manager

function ProjectileManager_Add(manager ref as tProjectileManager, position as tVector, direction as tVector, speed as integer)
  projectile as tProjectile
  projectile.direction = direction
  projectile.sprite = CreateSprite(manager.image)
  projectile.createdAt = Timer()
	// SetSpriteAnimation(projectile.sprite, 3, 3, 2) // TODO: Pass a tileset instead
  SetSpritePosition(projectile.sprite, position.x, position.y)
  SetSpriteGroup(projectile.sprite, manager.group)
  SetSpritePhysicsOn(projectile.sprite, 2)
  SetSpritePhysicsFriction(projectile.sprite, 1)
  SetSpriteCollideBits(projectile.sprite, manager.collideBits)
  PlaySprite(projectile.sprite, 10)
  SetSpritePhysicsImpulse(projectile.sprite, GetSpriteXByOffset(projectile.sprite), GetSpriteYByOffset(projectile.sprite), direction.x * speed, direction.y * speed)
  manager.projectiles.insert(projectile)
endfunction

function ProjectileManager_Update(manager ref as tProjectileManager, delta#)
  for i = 0 to manager.projectiles.length
    x# = GetSpriteX(manager.projectiles[i].sprite)
    y# = GetSpriteY(manager.projectiles[i].sprite)
    outOfBounds = x# < 0 or y# < 0 or x# > 200 or y# > 200 // TODO: Get real width and height?
    if outOfBounds or GetSpriteVisible(manager.projectiles[i].sprite) = 0 or Timer() - manager.projectiles[i].createdAt > manager.lifetime
      DeleteSprite(manager.projectiles[i].sprite)
      manager.projectiles.remove(i)
    endif
  next i
endfunction

function ProjectileManager_Destroy(manager ref as tProjectileManager)
  for i = 0 to manager.projectiles.length
    DeleteSprite(manager.projectiles[i].sprite)
  next i
  DeleteImage(manager.image)
  manager.projectiles.length = -1
endfunction
