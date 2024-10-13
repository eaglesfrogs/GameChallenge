extends BasePiece

#
# x S S   x S x   x x x   S x x
# S S x   x S S   x S S   S S x
# x x x   x x S   S S x   x S x
#

const rotations = [
	[[-1, 1], [0, 1], [0, 0], [1, 0]],
	[[0, 0], [0, 1], [1, 1], [1, 2]],
	[[-1, 2], [0, 2], [0, 1], [1, 1]],
	[[-1, 0], [-1, 1], [0, 1], [0, 2]],
]

const color = Color.GREEN
const label = "S"
		
func get_current_rotation():
	return rotations[current_rotation]
