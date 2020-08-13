type tSimpleSprite
  image as integer
  sprite as integer
endtype

function SimpleSprite_Create(imagefile as string)
  sprite as tSimpleSprite
  sprite.image = LoadImage(imagefile)
  SetImageMinFilter(sprite.image, 0)
  SetImageMagFilter(sprite.image, 0)
  sprite.sprite = CreateSprite(sprite.image)
endfunction sprite

function SimpleSprite_Destroy(sprite as tSimpleSprite)
  DeleteSprite(sprite.sprite)
  DeleteImage(sprite.image)
endfunction
