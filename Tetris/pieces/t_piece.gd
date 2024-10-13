extends BasePiece

#
# x T x   x T x   x x x   x T x
# T T T   x T T   T T T   T T x
# x x x   x T x   x T x   x T x
#

const rotations = [
	[[0, 0], [-1, 1], [0, 1], [1, 1]],
	[[0, 0], [0, 1], [1, 1], [0, 2]],
	[[-1, 1], [0, 1], [1, 1], [0, 2]],
	[[0, 0], [-1, 1], [0, 1], [0, 2]],
]

const color = Color.PURPLE
const label = "T"
		
func get_current_rotation():
	return rotations[current_rotation]
