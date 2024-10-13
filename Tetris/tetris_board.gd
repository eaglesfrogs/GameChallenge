extends Node2D

const COLS = 10
const ROWS = 20
const WAIT_TIME = 0.15
const PIECE_LABELS = ["I", "J", "L", "O", "S", "T", "Z"]
const DEBUG = false

var screen_size
var pieces = {}
var board = []
var active_piece = null
var active_piece_blocks = []
var active_piece_column_offset = 5
var active_piece_row_offset = 0
var boardReady = false
var next_piece_idx = -1

var tetris_block

signal rows_cleared(rows)
signal next_piece(piece)

func _init():
	for i in COLS:
		var row = []
		for j in ROWS:
			row.append(null)
		
		board.append(row)

func _ready():
	tetris_block = preload("res://pieces/tetris_block.tscn")
	pieces = {
		"I": preload("res://pieces/i_piece.gd"),
		"J": preload("res://pieces/j_piece.gd"),
		"L": preload("res://pieces/l_piece.gd"),
		"O": preload("res://pieces/o_piece.gd"),
		"S": preload("res://pieces/s_piece.gd"),
		"T": preload("res://pieces/t_piece.gd"),
		"Z": preload("res://pieces/z_piece.gd")
	}
	screen_size = $ColorRect.size
	
	if DEBUG:
		prepopulate_board()
	
func prepopulate_board():
	var format = [
		[1,1,1,1,1,1,1,1,1,0],
		[1,1,1,1,1,0,0,1,1,0],
		[1,1,1,1,1,1,1,1,1,0],
		[1,1,1,1,1,0,0,1,1,0],
	]
	
	var board_row = ROWS - 1
	for f in range(format.size() - 1, -1, -1):
		for c in format[f].size():
			if format[f][c] == 1:
				var block = tetris_block.instantiate()
				
				block.position = Vector2(
					c * 32 + 16, 
					board_row * 32 + 16)
				
				board[c][board_row] = block
								
				add_child(block)
				
		board_row -= 1
	
func _input(event):
	if boardReady:
		if event.is_action_pressed("left"):
			move_left()
			$LeftTimer.start(WAIT_TIME)
		if event.is_action_released("left"):
			$LeftTimer.stop()
		if event.is_action_pressed("right"):
			move_right()
			$RightTimer.start(WAIT_TIME)
		if event.is_action_released("right"):
			$RightTimer.stop()
		if event.is_action_pressed("rotate"):
			rotate_piece()
		if event.is_action_pressed("down"):
			drop_piece(false)
			$DownTimer.start(WAIT_TIME)
		if event.is_action_released("down"):
			$DownTimer.stop()
	
	if event is InputEventKey:
		get_viewport().set_input_as_handled()

func move_left():
	active_piece_column_offset -= 1
	
	if is_valid_move():
		set_piece_position()
	else:
		active_piece_column_offset += 1

func move_right():
	active_piece_column_offset += 1
	
	if is_valid_move():
		set_piece_position()
	else:
		active_piece_column_offset -= 1
		
func rotate_piece():
	active_piece.rotate_piece()
	
	if is_valid_move():
		set_piece_position()
		return
	
	# try to bounce off left wall
	active_piece_column_offset += 1		
	if is_valid_move():
		set_piece_position()
		return
		
	if active_piece.label == "I":
		active_piece_column_offset += 1		
		if is_valid_move():
			set_piece_position()
			return
		active_piece_column_offset -= 1	
		
	# try to bounce off right wall
	active_piece_column_offset -= 2		
	if is_valid_move():
		set_piece_position()
		return
		
	if active_piece.label == "I":
		active_piece_column_offset -= 1		
		if is_valid_move():
			set_piece_position()
			return
		active_piece_column_offset += 1	
	
	# nevermind..reset
	active_piece_column_offset += 1
	active_piece.counter_rotate_piece()
		
func drop_piece(isTimer):
	active_piece_row_offset += 1
	
	if is_valid_move():
		set_piece_position()
	elif isTimer:
		active_piece_row_offset -= 1
		finish_piece()
	else:
		active_piece_row_offset -= 1
	
func is_valid_move():
	var active_piece_position = active_piece.get_current_rotation()
	
	for n in 4:
		var pos = active_piece_position[n]
		
		var x = pos[0] + active_piece_column_offset
		if x < 0 or x >= COLS:
			return false
		
		var y = pos[1] + active_piece_row_offset
		if y >= ROWS:
			return false
			
		if board[x][y] != null:
			return false
	
	return true
	
func set_piece_position():
	var active_piece_position = active_piece.get_current_rotation()
	
	for n in 4:
		var block = active_piece_blocks[n]
		var pos = active_piece_position[n]
		
		block.position = Vector2(
			(pos[0] + active_piece_column_offset) * 32 + 16, 
			(pos[1] + active_piece_row_offset) * 32 + 16)

func spawn_piece():
	if not boardReady:
		boardReady = true
		
	active_piece_column_offset = 5
	active_piece_row_offset = 0
	
	if next_piece_idx == -1:
		next_piece_idx = randi() % PIECE_LABELS.size()
	
	var piece_idx = next_piece_idx
	
	next_piece_idx = randi() % PIECE_LABELS.size()
	if next_piece_idx == piece_idx: # less chance of duplicates
		next_piece_idx = randi() % PIECE_LABELS.size()
		
	next_piece.emit(PIECE_LABELS[next_piece_idx])
			
	var random_piece = pieces[PIECE_LABELS[piece_idx]]
	active_piece = random_piece.new()
	active_piece_blocks = []
	
	var active_piece_position = active_piece.get_current_rotation()
	
	if is_valid_move():	
		for n in 4:
			var block = tetris_block.instantiate()
			var pos = active_piece_position[n]
			
			block.modulate = active_piece.color
			active_piece_blocks.append(block)
			
			block.position = Vector2(
				(pos[0] + active_piece_column_offset) * 32 + 16, 
				(pos[1] + active_piece_row_offset) * 32 + 16)
			add_child(block)
	else:
		game_over()
		
func finish_piece():
	var active_piece_position = active_piece.get_current_rotation()
	
	for n in 4:
		var block = active_piece_blocks[n]
		var pos = active_piece_position[n]
		
		board[pos[0] + active_piece_column_offset][pos[1] + active_piece_row_offset] = block
		
	var found_rows = 0
	var lowest_row = 0
	var first_row = 0
		
	for r in range(min(active_piece_row_offset + 4, ROWS-1), active_piece_row_offset-1, -1): # the tallest offset from the active piece row is the I piece which is 4 high, so start from active row + 4 or max row (whichever is smaller)		
		var found_row = true
		for c in range(COLS-1, -1, -1):
			if board[c][r] == null && found_rows == 0:
				found_row = false
				break
			elif board[c][r] == null:
				found_row = false
			else:
				board[c][r].drop_increment = found_rows
		
		if found_row:
			found_rows += 1
			lowest_row = r
			if first_row == 0:
				first_row = r
			
			for c in range(COLS-1, -1, -1):
				remove_child(board[c][r])
				board[c][r] = null
	
	if found_rows > 0:
		rows_cleared.emit(found_rows)
		
		for r in range(first_row-1, -1, -1):
			var null_counts = 0
			
			for c in COLS:
				if board[c][r] != null:
					var drop_by = found_rows
					
					if board[c][r].drop_increment > 0:
						drop_by = board[c][r].drop_increment
						board[c][r].drop_increment = 0
					
					board[c][r].position.y = board[c][r].position.y + drop_by * 32
					board[c][r + drop_by] = board[c][r]
					board[c][r] = null
				else:
					null_counts += 1
			
			if null_counts == COLS && r < lowest_row: # if the whole row is null, then there shouldn't be anything above it to move down
				break
		
	spawn_piece()
	
func set_level(level):
	$DropTimer.set_timer_by_level(level)
	
func game_over():
	boardReady = false
	$DropTimer.stop()
	
	$GameLabel.text = "Game Over"
	$GameLabel.move_to_front()
	$GameLabel.visible = true
	
func pause():
	boardReady = false
	$DropTimer.paused = true
	
	$GameLabel.text = "Paused"
	$GameLabel.move_to_front()
	$GameLabel.visible = true
	
func unpause():
	boardReady = true
	$DropTimer.paused = false
	$GameLabel.visible = false
	
func reset():
	for c in COLS:
		for r in ROWS:
			if board[c][r] != null:
				remove_child(board[c][r])
				board[c][r] = null
				
	for block in active_piece_blocks:
		remove_child(block)
				
	active_piece = null
	active_piece_blocks = []
	active_piece_column_offset = 5
	active_piece_row_offset = 0
	boardReady = true
	
	$DropTimer.paused = false
	$DropTimer.start(1)
	$GameLabel.visible = false

func _on_drop_timer_timeout():
	if active_piece == null:
		spawn_piece()
	else:
		drop_piece(true)

func _on_left_timer_timeout():
	move_left()
	$LeftTimer.wait_time = WAIT_TIME

func _on_right_timer_timeout():
	move_right()
	$RightTimer.wait_time = WAIT_TIME

func _on_down_timer_timeout():
	drop_piece(false)
	$DownTimer.wait_time = WAIT_TIME
