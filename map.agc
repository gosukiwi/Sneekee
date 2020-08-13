REMSTART

	The following implements a `tMap` type which loads maps generated with the Tiled
	application and exported to JSON.

	It doesn't read all the data, just the tile size, map size and tile numbers. Tiles
	must be fed manually.

	NOTE: It's possible to use `GetImage` and manually handle the viewport, but it uses
	`SetViewOffset` for now.

	Usage:

		map as tMap
		map = Map_Create("Maps/city.json", tileset as tTileset)

	TODO:
	* Collision

REMEND
type tTileMapLayerObjectPoint
	x as float
	y as float
endtype

type tTileMapLayerObject
	name as string
	height as float
	width as float
	x as float
	y as float
	polygon as tTileMapLayerObjectPoint[]
endtype

type tTileMapLayer
	id as integer
	data as integer[] // a layer can either have data or objects, not both
	objects as tTileMapLayerObject[]
	width as integer
	height as integer
	x as integer
	y as integer
endtype

type tTileMap
	height as integer
	width as integer
	tilewidth as integer
	tileheight as integer
	layers as tTileMapLayer[]
endtype

type tMap
	data as tTileMap
	tiles as integer[]
	sprites as integer[]
	objects as integer[]
	tileset as tTileset
endtype

function Map_Create(file as string, tileset as tTileset)
	map as tMap
	mapData as tTileMap

	// Load map from JSON file
	fileId = OpenToRead(file)
	json$ = ReadString(fileId)
	CloseFile(fileId)
	mapData.fromJSON(json$)

	// Load tileset
	for i = 0 to tileset.length
		map.tiles.insert(Tileset_GetTile(tileset, i + 1))
	next i

	map.tileset = tileset
	map.data = mapData
	Map_Draw(map)
endfunction map

function Map_Destroy(map ref as tMap)
	for i = 0 to map.sprites.length
	  DeleteSprite(map.sprites[i])
	next i

	for i = 0 to map.tiles.length
		DeleteImage(map.tiles[i])
	next i

	for i = 0 to map.objects.length
		DeleteSprite(map.objects[i])
	next i

	Tileset_Destroy(map.tileset)
endfunction

function Map_GetHeight(map ref as tMap)
	height = map.data.height * map.data.tileheight
endfunction height

function Map_GetWidth(map ref as tMap)
	width = map.data.width * map.data.tilewidth
endfunction width

// PRIVATE
// =============================================================================

// Draws the map on the screen. This is heavy so it should only run once.
function Map_Draw(map ref as tMap)
	layer as tTileMapLayer
	for i = 0 to map.data.layers.length
		layer = map.data.layers[i]
		Map_DrawTileLayer(map, layer)
		Map_DrawObjectLayer(map, layer)
	next i
endfunction

function Map_DrawTileLayer(map ref as tMap, layer ref as tTileMapLayer)
	for i = 0 to layer.data.length
		tile = layer.data[i] - 1   // in the data, the tiles start from 1 and not from 0
		if tile = -1 then continue // tiled uses 0 to mean "no tile", so if it gets to -1, just skip this tile

		sprite = CreateSprite(map.tiles[tile])
		// From the docs: Note that when loading a sub image AGK will modify the UV
		// coordinates slightly so that the image does not steal pixels from
		// neighboring images during filtering, by default it shifts the UV inwards
		// by 0.5 pixels. You can override this by setting SetSpriteUVBorder to 0
		// for sprites where you need pixel perfect results, but you will have to
		// watch out for pixel bleeding around the edges, and may need to give your
		// sub images a 1 pixel border of an appropriate color that it can safely
		// steal from when filtering.
		SetSpriteUVBorder(sprite, 0)
		xIndex = Mod(i, map.data.width)
		yIndex = i / map.data.width
		SetSpriteDepth(sprite, 1000)
		SetSpritePosition(sprite, xIndex * map.data.tilewidth, yIndex * map.data.tileheight)
		map.sprites.insert(sprite)
	next i
endfunction

function Map_DrawObjectLayer(map ref as tMap, layer ref as tTileMapLayer)
	for i = 0 to layer.objects.length
		object as tTileMapLayerObject
		object = layer.objects[i]
		sprite = CreateDummySprite()
		map.objects.insert(sprite)

		if object.name = "wall"
			SetSpriteGroup(sprite, SPRITE_WALL_GROUP)
		elseif object.name = "floor"
			SetSpriteGroup(sprite, SPRITE_FLOOR_GROUP)
		endif

		// TODO: Not sure why we need an offset of 5 here to line up with the map
		SetSpritePosition(sprite, object.x - 5, object.y - 4.9)
		SetSpritePhysicsOn(sprite, 1) // static
		// SetSpritePhysicsFriction(sprite, 5)
		if object.polygon.length >= 0 // if polygon
			for i = 0 to object.polygon.length
				point as tTileMapLayerObjectPoint
				point = object.polygon[i]
				SetSpriteShapePolygon(sprite, object.polygon.length + 1, i, point.x, point.y)
			next i
		else // it's a box (no circles for now)
			SetSpriteShapeBox(sprite, 0, 0, object.width, object.height, 0)
		endif
	next i
endfunction
