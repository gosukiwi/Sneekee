type tBlinkTween
  tweens as integer[]
  chain as integer
endtype

function BlinkTween_Create(sprite as integer)
  blink as tBlinkTween

  tween1 = CreateTweenSprite(0.5)
  SetTweenSpriteAlpha(tween1, 255, 128, 0)
  tween2 = CreateTweenSprite(0.5)
  SetTweenSpriteAlpha(tween2, 128, 255, 0)
  tween3 = CreateTweenSprite(0.5)
  SetTweenSpriteAlpha(tween3, 255, 128, 0)
  tween4 = CreateTweenSprite(0.5)
  SetTweenSpriteAlpha(tween4, 128, 255, 0)
  blink.tweens.insert(tween1)
  blink.tweens.insert(tween2)
  blink.tweens.insert(tween3)
  blink.tweens.insert(tween4)

  chain = CreateTweenChain()
  for i = 0 to blink.tweens.length
    AddTweenChainSprite(chain, blink.tweens[i], sprite, 0)
  next i
  blink.chain = chain
endfunction blink

function BlinkTween_Play(blink ref as tBlinkTween)
  PlayTweenChain(blink.chain)
endfunction

function BlinkTween_Update(blink ref as tBlinkTween, delta as float)
  if GetTweenChainPlaying(blink.chain) = 0 then exitfunction

  UpdateTweenChain(blink.chain, delta)
endfunction

function BlinkTween_Destroy(blink ref as tBlinkTween)
  for i = 0 to blink.tweens.length
    DeleteTween(blink.tweens[i])
  next i
  blink.tweens.length = -1
  DeleteTweenChain(blink.chain)
endfunction

function BlinkTween_IsPlaying(blink ref as tBlinkTween)
  playing = GetTweenChainPlaying(blink.chain)
endfunction playing
