function Min(a as float, b as float)
  if a < b then exitfunction a
endfunction b

function Max(a as float, b as float)
  if a > b then exitfunction a
endfunction b

function Clamp(num as float, min as float, max as float)
  if num > max then exitfunction max
  if num < min then exitfunction min
endfunction num
