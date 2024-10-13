extends Timer

func _init():
	set_timer_by_level(1)

# https://harddrop.com/wiki/Tetris_Worlds timer explanation
func set_timer_by_level(level):
	var x = min(level, 15) # level 15 is pretty damn fast, lets not go faster than that
	
	wait_time = (0.8 - ((x-1)*0.007)) ** (x-1)
