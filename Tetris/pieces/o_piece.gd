extends BasePiece

#
# x O O x   x O O x   x O O x   x O O x
# x O O x   x O O x   x O O x   x O O x
# x x x x   x x x x   x x x x   x x x x
#

const rotations = [
	[[-1, 0], [-1, 1], [0, 0], [0, 1]],
	[[-1, 0], [-1, 1], [0, 0], [0, 1]],
	[[-1, 0], [-1, 1], [0, 0], [0, 1]],
	[[-1, 0], [-1, 1], [0, 0], [0, 1]],
]

const color = Color.YELLOW
const label = "O"
		
func get_current_rotation():
	return rotations[current_rotation]
