extends BasePiece

#
# x x L   x L x   x x x   L L x
# L L L   x L x   L L L   x L x
# x x x   x L L   L x x   x L x
#

const rotations = [
	[[1, 0], [-1, 1], [0, 1], [1, 1]],
	[[0, 0], [0, 1], [0, 2], [1, 2]],
	[[-1, 1], [0, 1], [1, 1], [-1, 2]],
	[[-1, 0], [0, 0], [0, 1], [0, 2]],
]

const color = Color.ORANGE
const label = "L"
		
func get_current_rotation():
	return rotations[current_rotation]
