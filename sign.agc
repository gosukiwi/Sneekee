type tSign
  sprite as tSimpleSprite
endtype

function Sign_Create(image as string, x, y, depth)
  sign as tSign
  sign.sprite = SimpleSprite_Create(image)
  SetSpritePosition(sign.sprite.sprite, x, y)
  SetSpriteDepth(sign.sprite.sprite, depth)
endfunction sign

function Sign_Destroy(sign ref as tSign)
  SimpleSprite_Destroy(sign.sprite)
endfunction
