#constant HEARTS_HUD_PADDING 1

type tHeartsHud
  image as integer
  hearts as integer[]
endtype

function HeartsHud_Push(hud ref as tHeartsHud)
  sprite = CreateSprite(hud.image)
  FixSpriteToScreen(sprite, 1)
  SetSpritePosition(sprite, 1 + (GetImageWidth(hud.image) + HEARTS_HUD_PADDING) * (hud.hearts.length + 1), 1)
  SetSpriteDepth(sprite, DEPTH_FRONT)
endfunction sprite

function HeartsHud_Pop(hud ref as tHeartsHud)
  if hud.hearts.length = -1 then exitfunction

  DeleteSprite(hud.hearts[hud.hearts.length])
  hud.hearts.remove()
endfunction

function HeartsHud_Create(lives as integer)
  hud as tHeartsHud
  hud.image = LoadImage("images/heart.png")
  SetImageMinFilter(hud.image, 0)
  SetImageMagFilter(hud.image, 0)
  for i = 1 to lives
    hud.hearts.insert(HeartsHud_Push(hud))
  next i
endfunction hud

function HeartsHud_Destroy(hud ref as tHeartsHud)
  for i = 0 to hud.hearts.length
    DeleteSprite(hud.hearts[i])
  next i
  DeleteImage(hud.image)
endfunction
