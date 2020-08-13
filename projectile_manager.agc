type tProjectile
  sprite as integer
  direction as tVector
endtype

type tProjectileManager
  image as integer
  group as integer
  projectiles as tProjectile[]
endtype

function ProjectileManager_Create(image as integer, group as integer)
  manager as tProjectileManager
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  manager.image = image
  manager.group = group
endfunction manager

function ProjectileManager_Add(manager ref as tProjectileManager, position as tVector, direction as tVector)
  projectile as tProjectile
  projectile.direction = direction
  projectile.sprite = CreateSprite(manager.image)
	SetSpriteAnimation(projectile.sprite, 3, 3, 2) // TODO: Pass a tileset instead
  SetSpritePosition(projectile.sprite, position.x, position.y)
  SetSpriteGroup(projectile.sprite, manager.group)
  SetSpritePhysicsOn(projectile.sprite, 3)
  SetSpriteCollideBits(projectile.sprite, PHYSICS_PROJECTILE_COLLISION_BITS)
  PlaySprite(projectile.sprite, 10)
  manager.projectiles.insert(projectile)
endfunction

function ProjectileManager_Update(manager ref as tProjectileManager, delta#)
  for i = 0 to manager.projectiles.length
    x# = GetSpriteX(manager.projectiles[i].sprite)
    y# = GetSpriteY(manager.projectiles[i].sprite)
    // TODO: Get real width and height?
    if x# < 0 or y# < 0 or x# > 200 or y# > 200 or GetSpriteVisible(manager.projectiles[i].sprite) = 0
      DeleteSprite(manager.projectiles[i].sprite)
      manager.projectiles.remove(i)
    else
      direction as tVector
      direction = manager.projectiles[i].direction
      // SetSpritePosition(manager.projectiles[i].sprite, x# + ENEMY_PROJECTILE_SPEED * direction.x, y# + ENEMY_PROJECTILE_SPEED * direction.y)
      SetSpritePhysicsVelocity(manager.projectiles[i].sprite, direction.x * 100, direction.y * 100)
    endif
  next i
endfunction

function ProjectileManager_Destroy(manager ref as tProjectileManager)
  for i = 0 to manager.projectiles.length
    DeleteSprite(manager.projectiles[i].sprite)
  next i
  manager.projectiles.length = -1
endfunction
