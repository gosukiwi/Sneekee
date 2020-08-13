// Helper Tileset type. This type assumes all tiles share the same name and are
// numbered. Eg: `my-tileset-tile1.png`, `my-tileset-tile2.png`, etc.
type tTileset
	image as integer
	length as integer
	tilename as string
	extension as string // eg `.png`
endtype

function Tileset_Create(image as string, tileamount as integer, tilename as string)
	tileset as tTileset
	tileset.image = LoadImage(image)
	SetImageMagFilter(tileset.image, 0) // These two instuctions make it so
	SetImageMinFilter(tileset.image, 0) // resizing is pixel-perfect!
	tileset.length = tileamount - 1
	tileset.tilename = tilename
	tileset.extension = GetStringToken(image, ".", CountStringTokens(image, "."))
endfunction tileset

function Tileset_Destroy(tileset ref as tTileset)
	DeleteImage(tileset.image)
endfunction

function Tileset_GetTile(tileset ref as tTileset, index as integer)
  image = LoadSubImage(tileset.image, tileset.tilename + str(index) + "." + tileset.extension)
endfunction image
