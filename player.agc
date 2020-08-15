#constant PLAYER_MAX_JUMPS           2
#constant PLAYER_IDLE_ANIMATION      0
#constant PLAYER_WALKING_ANIMATION   1
#constant PLAYER_ATTACKING_ANIMATION 2
#constant PLAYER_DIRECTION_RIGHT     0
#constant PLAYER_DIRECTION_LEFT      1
#constant PLAYER_AUTOATTACK_CD       0.5
#constant PLAYER_ROCK_IMPULSE_FORCE  30
#constant PLAYER_MOVEMENT_VELOCITY   20
#constant PLAYER_ROCK_ALIVE_TIME     3

type tPlayer
  image as integer
  sprite as integer
  hurtbox as integer
  availableJumps as integer
  currentAnimation as integer
  direction as integer
  lastAutoattack as float
  blinkTween as tBlinkTween
  categoryBits as integer
  rocks as tProjectileManager
  rockPlacedAt as integer
  shuriken as tShuriken
  hasShuriken as integer
endtype

function Player_Create(x, y)
  image = LoadImage("images/guy.png")
	SetImageMagFilter(image, 0) // These two instuctions make it so
	SetImageMinFilter(image, 0) // resizing is pixel-perfect!
  sprite = CreateSprite(image)
  SetSpriteSnap(sprite, 1)
  SetSpriteAnimation(sprite, 13, 6, 8)
  SetSpritePosition(sprite, x, y)
  SetSpriteShapeBox(sprite, -3, -3, 2, 3, 0)
  SetSpritePhysicsOn(sprite, 2) // dynamic object
  SetSpriteCategoryBits(sprite, PHYSICS_PLAYER_CATEGORY)
  SetSpritePhysicsCanRotate(sprite, 0)
  SetSpriteGroup(sprite, SPRITE_PLAYER_GROUP)
  SetSpriteOffset(sprite, 4, 3)
  SetSpriteDepth(sprite, DEPTH_FRONT_MIDDLE)

  // Hurtbox - Not a physics sprite
  hurtbox = CreateDummySprite()
  // SetSpritePhysicsOn(hurtbox, 2) // For debugging, to be able to see the hurtbox
  SetSpriteShapeBox(hurtbox, 0, 4, 8, 1, 0)
  SetSpriteGroup(hurtbox, SPRITE_PLAYER_HURTBOX_GROUP)

  player as tPlayer
  player.currentAnimation = PLAYER_IDLE_ANIMATION
  player.image = image
  player.sprite = sprite
  player.hurtbox = hurtbox
  player.availableJumps = PLAYER_MAX_JUMPS
  player.direction = PLAYER_DIRECTION_RIGHT
  player.lastAutoattack = -1
  player.categoryBits = PHYSICS_PLAYER_CATEGORY
  player.blinkTween = BlinkTween_Create(player.sprite)
  player.shuriken = Shuriken_Create()
  player.hasShuriken = 1
  player.rocks = ProjectileManager_Create(LoadImage("images/rock.png"), SPRITE_PLAYER_ROCK, PHYSICS_PLAYER_ROCK_COLLISION_BITS, 5)
  player.rockPlacedAt = -PLAYER_ROCK_ALIVE_TIME
endfunction player

function Player_Update(player ref as tPlayer, delta#)
  // Collision
  if GetSpriteFirstContact(player.sprite) = 1
    repeat
      other = GetSpriteContactSpriteID2()
      group = GetSpriteGroup(other)

      if (group = SPRITE_FLOOR_GROUP or group = SPRITE_ENEMY_GROUP) and GetSpritePhysicsVelocityY(player.sprite) < 0
        player.availableJumps = PLAYER_MAX_JUMPS
      endif
    until GetSpriteNextContact() = 0
  endif

  if GetSpriteCollision(player.sprite, player.shuriken.sprite) and Shuriken_IsStill(player.shuriken)
    Player_PickUpShuriken(player)
  endif

  // Input
  Player_HandleInput(player)

  // Other
  ProjectileManager_Update(player.rocks, delta#)

  if player.direction = PLAYER_DIRECTION_RIGHT
    SetSpritePosition(player.hurtbox, GetSpriteX(player.sprite), GetSpriteY(player.sprite) - 3)
  else
    SetSpritePosition(player.hurtbox, GetSpriteX(player.sprite) - 5, GetSpriteY(player.sprite) - 3)
  endif

  BlinkTween_Update(player.blinkTween, delta#)
  if Player_IsBlinking(player)
    if player.categoryBits <> 1
      SetSpriteCategoryBits(player.sprite, 1)
      player.categoryBits = 1
    endif
  else
    if player.categoryBits <> PHYSICS_PLAYER_CATEGORY
      SetSpriteCategoryBits(player.sprite, PHYSICS_PLAYER_CATEGORY)
      player.categoryBits = PHYSICS_PLAYER_CATEGORY
    endif
  endif
endfunction

function Player_Destroy(player ref as tPlayer)
  DeleteSprite(player.sprite)
  DeleteSprite(player.hurtbox)
  DeleteImage(player.image)
  BlinkTween_Destroy(player.blinkTween)
  ProjectileManager_Destroy(player.rocks)
endfunction

function Player_IsInHurtboxFrame(player ref as tPlayer)
  frame = GetSpriteCurrentFrame(player.sprite)
  result = frame = 7 or frame = 8
endfunction result

function Player_Blink(player ref as tPlayer)
  BlinkTween_Play(player.blinkTween)
endfunction

function Player_IsBlinking(player ref as tPlayer)
  isBlinking = BlinkTween_IsPlaying(player.blinkTween)
endfunction isBlinking

// PRIVATE
// =============================================================================
function Player_HandleInput(player ref as tPlayer)
  if ScreenToWorldX(GetRawMouseX()) > GetSpriteX(player.sprite) + GetSpriteOffsetX(player.sprite)
    if player.currentAnimation <> PLAYER_ATTACKING_ANIMATION and player.direction <> PLAYER_DIRECTION_RIGHT
      player.direction = PLAYER_DIRECTION_RIGHT
      SetSpriteFlip(player.sprite, 0, 0)
    endif
  else
    if player.currentAnimation <> PLAYER_ATTACKING_ANIMATION and player.direction <> PLAYER_DIRECTION_LEFT
      player.direction = PLAYER_DIRECTION_LEFT
      SetSpriteFlip(player.sprite, 1, 0)
    endif
  endif

  if GetRawKeyPressed(KEY_SPACE) and player.availableJumps > 1
    dec player.availableJumps
    SetSpritePhysicsVelocity(player.sprite, GetSpritePhysicsVelocityX(player.sprite), -80)
    PlaySound(SoundManager_Get(g.soundManager, "jump"), SOUND_VOLUME)
  endif

  if GetRawMouseLeftPressed()
    if Timer() - player.lastAutoattack > PLAYER_AUTOATTACK_CD
      player.lastAutoattack = Timer()
      Player_PlayAttackingAnimation(player)
      PlaySound(SoundManager_Get(g.soundManager, "woosh"), SOUND_VOLUME)
    endif
  elseif GetRawMouseRightPressed() and player.hasShuriken
    player.hasShuriken = 0
    Player_ThrowShuriken(player)
  endif

  if GetRawKeyPressed(KEY_CONTROL) and Timer() - player.rockPlacedAt > PLAYER_ROCK_ALIVE_TIME
    player.rockPlacedAt = Timer()
    position as tVector
    direction as tVector
    position = Vector_Create(GetSpriteX(player.sprite) + 6, GetSpriteY(player.sprite))
    direction = Vector_Normalize(Vector_SetInitialPoint(Vector_Create(ScreenToWorldX(GetRawMouseX()), ScreenToWorldY(GetRawMouseY())), position))
    ProjectileManager_Add(player.rocks, position, direction, PLAYER_ROCK_IMPULSE_FORCE)
  endif

  if GetRawKeyState(KEY_D)
    Player_PlayWakingAnimation(player)
    SetSpritePhysicsVelocity(player.sprite, PLAYER_MOVEMENT_VELOCITY, GetSpritePhysicsVelocityY(player.sprite))
  elseif GetRawKeyState(KEY_A)
    Player_PlayWakingAnimation(player)
    SetSpritePhysicsVelocity(player.sprite, -PLAYER_MOVEMENT_VELOCITY, GetSpritePhysicsVelocityY(player.sprite))
  else
    Player_PlayIdleAnimation(player)
    SetSpritePhysicsVelocity(player.sprite, 0, GetSpritePhysicsVelocityY(player.sprite))
  endif
endfunction

function Player_PlayIdleAnimation(player ref as tPlayer)
  if player.currentAnimation = PLAYER_IDLE_ANIMATION then exitfunction
  if GetSpritePlaying(player.sprite) and player.currentAnimation = PLAYER_ATTACKING_ANIMATION then exitfunction
  player.currentAnimation = PLAYER_IDLE_ANIMATION
  PlaySprite(player.sprite, 1, 1, 1, 1)
endfunction

function Player_PlayWakingAnimation(player ref as tPlayer)
  if player.currentAnimation = PLAYER_WALKING_ANIMATION then exitfunction
  if GetSpritePlaying(player.sprite) and player.currentAnimation = PLAYER_ATTACKING_ANIMATION then exitfunction
  player.currentAnimation = PLAYER_WALKING_ANIMATION
  PlaySprite(player.sprite, 8, 1, 2, 4)
endfunction

function Player_PlayAttackingAnimation(player ref as tPlayer)
  if GetSpritePlaying(player.sprite) and player.currentAnimation = PLAYER_ATTACKING_ANIMATION then exitfunction
  player.currentAnimation = PLAYER_ATTACKING_ANIMATION
  PlaySprite(player.sprite, 20, 0, 5, 8)
endfunction

function Player_ThrowShuriken(player ref as tPlayer)
  position as tVector
  direction as tVector
  position = Vector_Create(GetSpriteX(player.sprite) + 6, GetSpriteY(player.sprite))
  direction = Vector_Normalize(Vector_SetInitialPoint(Vector_Create(ScreenToWorldX(GetRawMouseX()), ScreenToWorldY(GetRawMouseY())), position))
  Shuriken_ThrowFrom(player.shuriken, position, direction)
endfunction

function Player_PickUpShuriken(player ref as tPlayer)
  SetSpriteVisible(player.shuriken.sprite, 0)
  player.hasShuriken = 1
endfunction
