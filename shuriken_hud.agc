#constant SHURIKEN_HUD_PADDING 1

type tShurikensHud
  image as integer
  shurikens as integer[]
endtype

function ShurikensHud_Push(hud ref as tShurikensHud)
  sprite = CreateSprite(hud.image)
  FixSpriteToScreen(sprite, 1)
  SetSpritePosition(sprite, 64 - GetSpriteWidth(sprite) - 1 + (GetImageWidth(hud.image) + SHURIKEN_HUD_PADDING) * (hud.shurikens.length + 1), 1)
  SetSpriteDepth(sprite, DEPTH_FRONT)
  hud.shurikens.insert(sprite)
endfunction

function ShurikensHud_Pop(hud ref as tShurikensHud)
  if hud.shurikens.length = -1 then exitfunction

  DeleteSprite(hud.shurikens[hud.shurikens.length])
  hud.shurikens.remove()
endfunction

function ShurikensHud_Create(lives as integer)
  hud as tShurikensHud
  hud.image = LoadImage("images/shuriken.png")
  SetImageMinFilter(hud.image, 0)
  SetImageMagFilter(hud.image, 0)
  for i = 1 to lives
    ShurikensHud_Push(hud)
  next i
endfunction hud

function ShurikensHud_Destroy(hud ref as tShurikensHud)
  for i = 0 to hud.shurikens.length
    DeleteSprite(hud.shurikens[i])
  next i
  DeleteImage(hud.image)
endfunction
