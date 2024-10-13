extends BasePiece

#
# Z Z x   x x Z   x x x   x Z x
# x Z Z   x Z Z   Z Z x   Z Z x
# x x x   x Z x   x Z Z   Z x x
#

const rotations = [
	[[-1, 0], [0, 0], [0, 1], [1, 1]],
	[[1, 0], [0, 1], [1, 1], [0, 2]],
	[[-1, 1], [0, 1], [0, 2], [1, 2]],
	[[0, 0], [-1, 1], [0, 1], [-1, 2]],
]

const color = Color.RED
const label = "Z"
		
func get_current_rotation():
	return rotations[current_rotation]
