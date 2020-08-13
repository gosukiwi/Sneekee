Type tVector
	x as float
	y as float
EndType

Function Vector_Create(x as float, y as float)
	vector as tVector
	vector.x = x
	vector.y = y
EndFunction vector

Function Vector_ToString(vector as tVector)
	str$ = "<Vector x: " + Str(vector.x, 2) + ", y: " + Str(vector.y, 2) + ">"
EndFunction str$

Function Vector_ScalarProduct(scalar as float, v as tVector)
	vector as tVector
	vector = Vector_Create(v.x * scalar, v.y * scalar)
EndFunction vector

Function Vector_Product(v1 as tVector, v2 as tVector)
	vector as tVector
	vector = Vector_Create(v1.x * v2.x, v1.y * v2.y)
EndFunction vector

Function Vector_Addition(v1 as tVector, v2 as tVector)
	vector as tVector
	vector = Vector_Create(v1.x + v2.x, v1.y + v2.y)
EndFunction vector

Function Vector_Floor(v as tVector)
	vector as tVector
	vector = Vector_Create(Floor(v.x), Floor(v.y))
EndFunction vector

Function Vector_Magnitude(v as tVector)
	magnitude# = Sqrt(v.x * v.x + v.y * v.y)
EndFunction magnitude#

Function Vector_DotProduct(v1 as tVector, v2 as tVector)
	result# = v1.x * v2.x + v1.y * v2.y
EndFunction result#

Function Vector_Determinant(v1 as tVector, v2 as tVector)
	result# = v1.x * v2.y - v1.y * v2.x
EndFunction result#

// Returns the angle between 0 and 180
Function Vector_Angle180(v1 as tVector, v2 as tVector)
	result# = ACos(Vector_DotProduct(v1, v2)/(Vector_Magnitude(v1) * Vector_Magnitude(v2)))
EndFunction result#

// Returns the angle between -180 and 180
Function Vector_Angle(v1 as tVector, v2 as tVector)
	result# = ATan2(Vector_Determinant(v1, v2), Vector_DotProduct(v1, v2))
EndFunction result#

Function Vector_SetInitialPoint(v as tVector, initial as tVector)
	vector as tVector
	vector = Vector_Create(v.x - initial.x, v.y - initial.y)
EndFunction vector

function Vector_Normalize(v as tVector)
	vector as tVector
	magnitude# = Vector_Magnitude(v)
	vector = Vector_Create(v.x / magnitude#, v.y / magnitude#)
endfunction vector
