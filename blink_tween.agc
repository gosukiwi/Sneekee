type tBlinkTween
  tweens as integer[]
  chain as integer
endtype

function BlinkTween_Create(sprite as integer)
  blink as tBlinkTween
  chain = CreateTweenChain()

  for i = 0 to 10
    tween = CreateTweenSprite(0.2)
    if Mod(i, 2) = 0
      SetTweenSpriteAlpha(tween, 128, 255, 0)
    else
      SetTweenSpriteAlpha(tween, 255, 128, 0)
    endif
    blink.tweens.insert(tween)
    AddTweenChainSprite(chain, tween, sprite, 0)
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
