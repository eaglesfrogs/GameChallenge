extends Object
class_name BasePiece

var current_rotation = 0

func rotate_piece():
	current_rotation += 1
	
	if current_rotation >= 4:
		current_rotation = 0
		
func counter_rotate_piece():
	current_rotation -= 1
	
	if current_rotation < 0:
		current_rotation = 3
