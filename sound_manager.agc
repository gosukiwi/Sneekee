type tSoundManagerSound
  name as string
  id as integer
endtype

type tSoundManager
  sounds as tSoundManagerSound[]
endtype

function SoundManager_Create()
  manager as tSoundManager
endfunction manager

function SoundManager_Register(manager ref as tSoundManager, name as string, file as string)
  sound as tSoundManagerSound
  sound.name = name
  sound.id = LoadSoundOGG(file)
  manager.sounds.insert(sound)
  manager.sounds.sort()
endfunction

function SoundManager_Get(manager ref as tSoundManager, name as string)
  index = manager.sounds.find(name)
  id = manager.sounds[index].id
endfunction id
