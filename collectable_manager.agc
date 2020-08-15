#constant LIFE_IMPULSE 30

type tCollectableManager
  image as integer
  group as integer
  collectables as integer[]
endtype

function CollectableManager_Create(image as integer, group as integer)
  manager as tCollectableManager
  manager.image = image
  manager.group = group
	SetImageMagFilter(manager.image, 0) // These two instuctions make it so
	SetImageMinFilter(manager.image, 0) // resizing is pixel-perfect!
endfunction manager

function CollectableManager_Add(manager ref as tCollectableManager, x as integer, y as integer)
  sprite = CreateSprite(manager.image)
  SetSpritePosition(sprite, x, y)
  SetSpriteGroup(sprite, manager.group)
  SetSpritePhysicsOn(sprite, 2)
  SetSpritePhysicsImpulse(sprite, GetSpriteXByOffset(sprite), GetSpriteYByOffset(sprite), 0, -LIFE_IMPULSE)
  manager.collectables.insert(sprite)
endfunction

function CollectableManager_Destroy(manager ref as tCollectableManager)
  for i = 0 to manager.collectables.length
    DeleteSprite(manager.collectables[i])
  next i
  manager.collectables.length = -1
  DeleteImage(manager.image)
endfunction
