extends BasePiece

#
# J x x   x J J   x x x   x J x
# J J J   x J x   J J J   x J x
# x x x   x J x   x x J   J J x
#

const rotations = [
	[[-1, 0], [-1, 1], [0, 1], [1, 1]],
	[[0, 0], [1, 0], [0, 1], [0, 2]],
	[[-1, 1], [0, 1], [1, 1], [1, 2]],
	[[0, 0], [0, 1], [-1, 2], [0, 2]],
]

const color = Color.BLUE
const label = "J"
		
func get_current_rotation():
	return rotations[current_rotation]
