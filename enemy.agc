#constant ENEMY_STATE_MOVING_LEFT    0
#constant ENEMY_STATE_MOVING_RIGHT   1
#constant ENEMY_STATE_ATTACKING      2
#constant ENEMY_STATE_SCANNING_DOWN  3
#constant ENEMY_SCAN_TIME            3 // seconds
#constant ENEMY_MOVEMENT_TIME        2 // seconds
#constant ENEMY_MOVEMENT_VELOCITY    15
#constant ENEMY_FIRE_DISTANCE        25
#constant ENEMY_FIRE_DELAY           0.5
#constant ENEMY_PROJECTILE_SPEED     1
#constant ENEMY_PROJECTILE_LIFESPAN  5 // seconds
#constant ENEMY_DROPS_NOTHING        0
#constant ENEMY_DROPS_LIFE           1
#constant ENEMY_DROPS_SHURIKEN       2
#constant ENEMY_DIRECTION_LEFT       0
#constant ENEMY_DIRECTION_RIGHT      1

type tEnemy
  sprite as integer
  scan as integer
  scanDown as integer
  state as integer
  timer as float
  fireTimer as float
  projectileManager as tProjectileManager
  livesManager as tCollectableManager
  shurikenManager as tCollectableManager
  alive as integer
  drop as integer
  lastDirection as integer
endtype

function Enemy_Create(x, y, drop)
  enemy as tEnemy
  image = LoadImage("images/enemy.png")
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  sprite = CreateSprite(image)
  SetSpriteSnap(sprite, 1)
  SetSpritePosition(sprite, x, y)
  SetSpritePhysicsOn(sprite, 2) // dynamic object
  SetSpritePhysicsCanRotate(sprite, 0)
  SetSpriteGroup(sprite, SPRITE_ENEMY_GROUP)
  SetSpriteAnimation(sprite, 7, 6, 5)
  PlaySprite(sprite, 5, 1, 4, 5)

  // Scan
  image = LoadImage("images/scan.png")
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  scan = CreateSprite(image)
	SetSpriteAnimation(scan, 12, 12, 6)
  SetSpriteVisible(scan, 0)
  SetSpriteShape(scan, 3) // polygon
  SetSpriteGroup(scan, SPRITE_ENEMY_SCAN)

  // Scan down
  image = LoadImage("images/scan-down.png")
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  scanDown = CreateSprite(image)
	SetSpriteAnimation(scanDown, 12, 12, 3)
  SetSpriteVisible(scanDown, 0)
  SetSpriteShape(scanDown, 3) // polygon
  SetSpriteGroup(scanDown, SPRITE_ENEMY_SCAN)

  enemy.sprite = sprite
  enemy.scan = scan
  enemy.scanDown = scanDown
  enemy.projectileManager = ProjectileManager_Create(LoadImage("images/projectile.png"), SPRITE_ENEMY_PROJECTILE_GROUP, PHYSICS_PROJECTILE_COLLISION_BITS, ENEMY_PROJECTILE_LIFESPAN)
  enemy.timer = Timer()
  enemy.alive = 1
  enemy.drop = drop
  Enemy_MovingLeftState_Initialize(enemy)
endfunction enemy

function Enemy_Update(enemy ref as tEnemy, player ref as tPlayer, delta#)
  if enemy.alive = 0 then exitfunction

  // Misc
  ProjectileManager_Update(enemy.projectileManager, delta#)

  // Collision
  if enemy.state <> ENEMY_STATE_ATTACKING
    if GetSpriteCollision(enemy.scan, player.sprite) and GetSpriteVisible(enemy.scan)
      Enemy_AttackingState_Initialize(enemy)
    elseif GetSpriteCollision(enemy.scanDown, player.sprite) and GetSpriteVisible(enemy.scanDown)
      Enemy_AttackingState_Initialize(enemy)
    elseif ProjectileManager_IsColliding(player.rocks, enemy.scan) and enemy.state <> ENEMY_STATE_SCANNING_DOWN
      Enemy_ScanningDownState_Initialize(enemy)
    endif
  endif

  if GetSpriteCollision(enemy.sprite, player.hurtbox) and Player_IsInHurtboxFrame(player)
    Enemy_Destroy(enemy, 0)
    exitfunction
  endif

  if GetSpriteFirstContact(enemy.sprite) = 1
    repeat
      other = GetSpriteContactSpriteID2()
      group = GetSpriteGroup(other)

      if group = SPRITE_PLAYER_GROUP and enemy.state <> ENEMY_STATE_ATTACKING
        Enemy_AttackingState_Initialize(enemy)
      elseif group = SPRITE_SHURIKEN_GROUP and GetSpriteVisible(other)
        PlaySound(SoundManager_Get(g.soundManager, "shuriken-hit"), 10)
        SetSpriteVisible(other, 0)
        SetSpritePosition(other, -10, -10)
        Enemy_Destroy(enemy, 0)
        exitfunction
      endif
    until GetSpriteNextContact() = 0
  endif

  // States
  select enemy.state
    case ENEMY_STATE_MOVING_LEFT
      Enemy_MovingLeftState_Tick(enemy)
    endcase
    case ENEMY_STATE_MOVING_RIGHT
      Enemy_MovingRightState_Tick(enemy)
    endcase
    case ENEMY_STATE_ATTACKING
      Enemy_AttackingState_Tick(enemy, player)
    endcase
    case ENEMY_STATE_SCANNING_DOWN
      Enemy_ScanningDownState_Tick(enemy)
    endcase
  endselect
endfunction

function Enemy_Destroy(enemy ref as tEnemy, silent as integer)
  enemy.alive = 0
  ProjectileManager_Destroy(enemy.projectileManager)
  ExplosionManager_AddAtSprite(g.explosionManager, enemy.sprite)

  if silent = 0 then PlaySound(SoundManager_Get(g.soundManager, "explosion"), SOUND_VOLUME)
  if enemy.drop = ENEMY_DROPS_LIFE then CollectableManager_Add(g.lifeCollectables, GetSpriteX(enemy.sprite), GetSpriteY(enemy.sprite))
  if enemy.drop = ENEMY_DROPS_SHURIKEN then CollectableManager_Add(g.shurikenCollectables, GetSpriteX(enemy.sprite), GetSpriteY(enemy.sprite))

  DeleteSprite(enemy.sprite)
  DeleteSprite(enemy.scan)
  DeleteSprite(enemy.scanDown)
endfunction

// PRIVATE
// =============================================================================
// MOVING LEFT STATE
// =============================================================================
function Enemy_MovingLeftState_Initialize(enemy ref as tEnemy)
  SetSpriteFlip(enemy.sprite, 0, 0)
  SetSpriteFlip(enemy.scan, 0, 0)
  SetSpriteVisible(enemy.scan, 1)
  PlaySprite(enemy.scan, 10, 1, -1, -1)
  SetSpritePosition(enemy.scan, GetSpriteX(enemy.sprite) - GetSpriteWidth(enemy.scan), GetSpriteY(enemy.sprite) - (GetSpriteHeight(enemy.scan) / 2))
  enemy.timer = Timer()
  enemy.lastDirection = ENEMY_DIRECTION_LEFT
  enemy.state = ENEMY_STATE_MOVING_LEFT
endfunction

function Enemy_MovingLeftState_Tick(enemy ref as tEnemy)
  SetSpritePhysicsVelocityX(enemy.sprite, -ENEMY_MOVEMENT_VELOCITY)
  SetSpritePosition(enemy.scan, GetSpriteX(enemy.sprite) - GetSpriteWidth(enemy.scan), GetSpriteY(enemy.sprite) - (GetSpriteHeight(enemy.scan) / 2))

  if Timer() - enemy.timer > ENEMY_MOVEMENT_TIME
    Enemy_MovingLeftState_Cleanup(enemy)
    Enemy_MovingRightState_Initialize(enemy)
  endif
endfunction

function Enemy_MovingLeftState_Cleanup(enemy ref as tEnemy)
  SetSpritePhysicsVelocityX(enemy.sprite, 0)
  SetSpriteVisible(enemy.scan, 0)
endfunction

// MOVING RIGHT STATE
// =============================================================================
function Enemy_MovingRightState_Initialize(enemy ref as tEnemy)
  SetSpriteFlip(enemy.sprite, 1, 0)
  SetSpriteFlip(enemy.scan, 1, 0)
  SetSpriteVisible(enemy.scan, 1)
  PlaySprite(enemy.scan, 10, 1, -1, -1)
  SetSpritePosition(enemy.scan, GetSpriteX(enemy.sprite) + GetSpriteWidth(enemy.sprite), GetSpriteY(enemy.sprite) - (GetSpriteHeight(enemy.scan) / 2))
  enemy.timer = Timer()
  enemy.lastDirection = ENEMY_DIRECTION_RIGHT
  enemy.state = ENEMY_STATE_MOVING_RIGHT
endfunction

function Enemy_MovingRightState_Tick(enemy ref as tEnemy)
  SetSpritePhysicsVelocityX(enemy.sprite, ENEMY_MOVEMENT_VELOCITY)
  SetSpritePosition(enemy.scan, GetSpriteX(enemy.sprite) + GetSpriteWidth(enemy.sprite), GetSpriteY(enemy.sprite) - (GetSpriteHeight(enemy.scan) / 2))

  if Timer() - enemy.timer > ENEMY_MOVEMENT_TIME
    Enemy_MovingRightState_Cleanup(enemy)
    Enemy_MovingLeftState_Initialize(enemy)
  endif
endfunction

function Enemy_MovingRightState_Cleanup(enemy ref as tEnemy)
  SetSpritePhysicsVelocityX(enemy.sprite, 0)
  SetSpriteVisible(enemy.scan, 0)
endfunction

// SCANNING DOWN STATE
// =============================================================================
function Enemy_ScanningDownState_Initialize(enemy ref as tEnemy)
  select enemy.state
    case ENEMY_STATE_MOVING_LEFT
      Enemy_MovingLeftState_Cleanup(enemy)
      SetSpriteFlip(enemy.scanDown, 0, 0)
    endcase
    case ENEMY_STATE_MOVING_RIGHT
      Enemy_MovingRightState_Cleanup(enemy)
      SetSpriteFlip(enemy.scanDown, 1, 0)
    endcase
  endselect
  SetSpriteVisible(enemy.scanDown, 1)
  PlaySprite(enemy.scanDown, 10, 1, -1, -1)
  enemy.timer = Timer()
  enemy.state = ENEMY_STATE_SCANNING_DOWN
endfunction

function Enemy_ScanningDownState_Tick(enemy ref as tEnemy)
  if GetSpriteFlippedH(enemy.scanDown)
    SetSpritePosition(enemy.scanDown, GetSpriteX(enemy.sprite) + GetSpriteWidth(enemy.sprite), GetSpriteY(enemy.sprite) - (GetSpriteHeight(enemy.scan) / 2))
  else
    SetSpritePosition(enemy.scanDown, GetSpriteX(enemy.sprite) - GetSpriteWidth(enemy.scanDown), GetSpriteY(enemy.sprite) - (GetSpriteHeight(enemy.scan) / 2))
  endif

  if Timer() - enemy.timer > ENEMY_SCAN_TIME
    Enemy_ScanningDownState_Cleanup(enemy)
    if enemy.lastDirection = ENEMY_DIRECTION_LEFT
      Enemy_MovingLeftState_Initialize(enemy)
    else
      Enemy_MovingRightState_Initialize(enemy)
    endif
  endif
endfunction

function Enemy_ScanningDownState_Cleanup(enemy ref as tEnemy)
  SetSpriteVisible(enemy.scanDown, 0)
endfunction

// ATTACKING STATE
// =============================================================================
function Enemy_AttackingState_Initialize(enemy ref as tEnemy)
  select enemy.state
    case ENEMY_STATE_MOVING_LEFT
      Enemy_MovingLeftState_Cleanup(enemy)
    endcase
    case ENEMY_STATE_MOVING_RIGHT
      Enemy_MovingRightState_Cleanup(enemy)
    endcase
    case ENEMY_STATE_SCANNING_DOWN
      Enemy_ScanningDownState_Cleanup(enemy)
    endcase
  endselect
  enemy.state = ENEMY_STATE_ATTACKING
endfunction

// 1. Move close to player
// 2. Shoot
// 3. Repeat
function Enemy_AttackingState_Tick(enemy ref as tEnemy, player ref as tPlayer)
  dist = GetSpriteX(player.sprite) - GetSpriteX(enemy.sprite)
  if dist > 0
    if GetSpriteFlippedH(enemy.sprite) = 0 then SetSpriteFlip(enemy.sprite, 1, 0)
    if dist < ENEMY_FIRE_DISTANCE
      SetSpritePhysicsVelocityX(enemy.sprite, 0)
      Enemy_Fire(enemy, player)
    else
      SetSpritePhysicsVelocityX(enemy.sprite, ENEMY_MOVEMENT_VELOCITY)
    endif
  elseif dist < 0
    if GetSpriteFlippedH(enemy.sprite) = 1 then SetSpriteFlip(enemy.sprite, 0, 0)
    if dist > -ENEMY_FIRE_DISTANCE
      Enemy_Fire(enemy, player)
      SetSpritePhysicsVelocityX(enemy.sprite, 0)
    else
      SetSpritePhysicsVelocityX(enemy.sprite, -ENEMY_MOVEMENT_VELOCITY)
    endif
  endif
endfunction
// END OF STATES
// =============================================================================

function Enemy_Fire(enemy ref as tEnemy, player ref as tPlayer)
  if enemy.fireTimer = 0 or Timer() - enemy.fireTimer > ENEMY_FIRE_DELAY
    position as tVector
    endpoint as tVector
    direction as tVector

    enemy.fireTimer = Timer()
    position  = Vector_Create(GetSpriteX(enemy.sprite) + GetSpriteWidth(enemy.sprite) / 2, GetSpriteY(enemy.sprite))
    // Here 1.5 is half of the projectile's width and height
    endpoint  = Vector_Create(GetSpriteX(player.sprite) - 1.5 + GetSpriteOffsetX(player.sprite), GetSpriteY(player.sprite) - 1.5 + GetSpriteOffsetY(player.sprite))
    direction = Vector_Normalize(Vector_SetInitialPoint(endpoint, position))
    ProjectileManager_Add(enemy.projectileManager, position, direction, ENEMY_PROJECTILE_IMPULSE_FORCE)
  endif
endfunction
