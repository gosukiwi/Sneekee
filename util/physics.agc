function SetSpritePhysicsVelocityX(sprite as integer, x as float)
  SetSpritePhysicsVelocity(sprite, x, GetSpritePhysicsVelocityY(sprite))
endfunction

function SetSpritePhysicsVelocityY(sprite as integer, y as float)
  SetSpritePhysicsVelocity(sprite, GetSpritePhysicsVelocityX(sprite), y)
endfunction
