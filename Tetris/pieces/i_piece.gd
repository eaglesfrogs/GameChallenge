extends BasePiece

#
# x x x x   x x I x   x x x x   x I x x
# I I I I   x x I x   x x x x   x I x x
# x x x x   x x I x   I I I I   x I x x
# x x x x   x x I x   x x x x   x I x x
#

const rotations = [
	[[-2, 1], [-1, 1], [0, 1], [1, 1]],
	[[0, 0], [0, 1], [0, 2], [0, 3]],
	[[-2, 2], [-1, 2], [0, 2], [1, 2]],
	[[-1, 0], [-1, 1], [-1, 2], [-1, 3]],
]

const color = Color.CYAN
const label = "I"
		
func get_current_rotation():
	return rotations[current_rotation]
