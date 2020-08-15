#constant LIFE_IMPULSE 30

type tLifeCollectableManager
  image as integer
  lives as integer[]
endtype

function LifeCollectableManager_Create()
  life as tLifeCollectableManager
  life.image = LoadImage("images/heart-small.png")
	SetImageMagFilter(life.image, 0) // These two instuctions make it so
	SetImageMinFilter(life.image, 0) // resizing is pixel-perfect!
endfunction life

function LifeCollectableManager_Add(manager ref as tLifeCollectableManager, x as integer, y as integer)
  sprite = CreateSprite(manager.image)
  SetSpritePosition(sprite, x, y)
  SetSpriteGroup(sprite, SPRITE_LIVES_GROUP)
  SetSpritePhysicsOn(sprite, 2)
  SetSpritePhysicsImpulse(sprite, GetSpriteXByOffset(sprite), GetSpriteYByOffset(sprite), 0, -LIFE_IMPULSE)
  manager.lives.insert(sprite)
endfunction
