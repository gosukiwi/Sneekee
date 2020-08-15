// Collisions and Physics
#constant SPRITE_ENEMY_PROJECTILE_GROUP -1 // Negative groups don't collide with themselves
#constant SPRITE_WALL_GROUP              0
#constant SPRITE_FLOOR_GROUP             1
#constant SPRITE_PLAYER_GROUP            2
#constant SPRITE_PLAYER_HURTBOX_GROUP    3
#constant SPRITE_ENEMY_GROUP             4
#constant SPRITE_ENEMY_SCAN              5
#constant SPRITE_LIVES_GROUP             6
#constant SPRITE_PLAYER_ROCK             7
#constant SPRITE_SHURIKEN_GROUP          8
#constant PHYSICS_PLAYER_CATEGORY %10
#constant PHYSICS_PROJECTILE_COLLISION_BITS  %10 // collides with player only
#constant PHYSICS_PLAYER_ROCK_COLLISION_BITS %11 // collides with player and everything else
#constant SHURIKEN_COLLISION_BITS            %01 // not with player, yes with everything else
#constant ENEMY_PROJECTILE_IMPULSE_FORCE 50
// Debugging
#constant DEBUGGING 0
#constant INITIAL_LEVEL 1
#constant LAST_LEVEL 4
// Depth
#constant DEPTH_FRONT        0
#constant DEPTH_FRONT_MIDDLE 250
#constant DEPTH_MIDDLE       500
#constant DEPTH_MIDDLE_BACK  750
#constant DEPTH_BACK         1000
// Other
#constant PLAYER_INITIAL_LIVES 3
#constant PLAYER_INITIAL_SHURIKENS 1
#constant SOUND_VOLUME 40
#constant MUSIC_VOLUME 30
#constant NL Chr(10)
