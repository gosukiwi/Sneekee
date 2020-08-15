#constant SHURIKEN_IMPULSE 200
#constant SHURIKEN_ANGULAR_VELOCITY 10

type tShuriken
  image as integer
  sprite as integer
endtype

function Shuriken_Create()
  shuriken as tShuriken
  shuriken.image = LoadImage("images/shuriken.png")
  SetImageMinFilter(shuriken.image, 0)
  SetImageMagFilter(shuriken.image, 0)
  shuriken.sprite = CreateSprite(shuriken.image)
  SetSpriteGroup(shuriken.sprite, SPRITE_SHURIKEN_GROUP)
  SetSpritePhysicsOn(shuriken.sprite, 2) // dynamic
  SetSpriteVisible(shuriken.sprite, 0)
  SetSpriteCollideBits(shuriken.sprite, SHURIKEN_COLLISION_BITS)
endfunction shuriken

function Shuriken_Update(shuriken ref as tShuriken, delta as float)
  if GetSpriteVisible(shuriken.sprite) = 0 then exitfunction
  if Shuriken_IsStill(shuriken) then Shuriken_Hide(shuriken)
endfunction

function Shuriken_Destroy(shuriken ref as tShuriken)
  DeleteSprite(shuriken.sprite)
  DeleteImage(shuriken.image)
endfunction

function Shuriken_ThrowFrom(shuriken ref as tShuriken, position as tVector, direction as tVector)
  SetSpriteVisible(shuriken.sprite, 1)
  SetSpritePosition(shuriken.sprite, position.x, position.y)
  SetSpritePhysicsImpulse(shuriken.sprite, GetSpriteXByOffset(shuriken.sprite), GetSpriteYByOffset(shuriken.sprite), direction.x * SHURIKEN_IMPULSE, direction.y * SHURIKEN_IMPULSE)
  SetSpritePhysicsAngularVelocity(shuriken.sprite, SHURIKEN_ANGULAR_VELOCITY)
endfunction

function Shuriken_IsStill(shuriken ref as tShuriken)
  result = Abs(GetSpritePhysicsVelocityX(shuriken.sprite)) < 1 and Abs(GetSpritePhysicsVelocityY(shuriken.sprite)) < 1
endfunction result

function Shuriken_Hide(shuriken ref as tShuriken)
  SetSpriteVisible(shuriken.sprite, 0)
  SetSpritePosition(shuriken.sprite, -10, -10)
endfunction
