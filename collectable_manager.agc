#constant LIFE_IMPULSE 30

type tCollectableManager
  image as integer
  group as integer
  lives as integer[]
endtype

function CollectableManager_Create(group as integer)
  life as tCollectableManager
  life.image = LoadImage("images/heart-small.png")
  life.group = group
	SetImageMagFilter(life.image, 0) // These two instuctions make it so
	SetImageMinFilter(life.image, 0) // resizing is pixel-perfect!
endfunction life

function CollectableManager_Add(manager ref as tCollectableManager, x as integer, y as integer)
  sprite = CreateSprite(manager.image)
  SetSpritePosition(sprite, x, y)
  SetSpriteGroup(sprite, manager.group)
  SetSpritePhysicsOn(sprite, 2)
  SetSpritePhysicsImpulse(sprite, GetSpriteXByOffset(sprite), GetSpriteYByOffset(sprite), 0, -LIFE_IMPULSE)
  manager.lives.insert(sprite)
endfunction
