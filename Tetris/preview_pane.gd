extends Node2D

var pieces = {}
var tetris_block
var screen_size
var blocks = []

func _ready():
	tetris_block = preload("res://pieces/tetris_block.tscn")
	pieces = {
		"I": {
			"class": preload("res://pieces/i_piece.gd"),
			"x_offset": 80,
			"y_offset": 0
		},
		"J": {
			"class": preload("res://pieces/j_piece.gd"),
			"x_offset": 64,
			"y_offset": 16
		},
		"L": {
			"class": preload("res://pieces/l_piece.gd"),
			"x_offset": 64,
			"y_offset": 16
		},
		"O": {
			"class": preload("res://pieces/o_piece.gd"),
			"x_offset": 80,
			"y_offset": 16
		},
		"S": {
			"class": preload("res://pieces/s_piece.gd"),
			"x_offset": 64,
			"y_offset": 16
		},
		"T": {
			"class": preload("res://pieces/t_piece.gd"),
			"x_offset": 64,
			"y_offset": 16
		},
		"Z": {
			"class": preload("res://pieces/z_piece.gd"),
			"x_offset": 64,
			"y_offset": 16
		}
	}
	screen_size = $ColorRect.size
	
func render_piece(piece):
	for b in blocks:
		remove_child(b)
		
	blocks = []
		
	if piece == null || piece not in pieces:
		return
	
	var preview_piece = pieces[piece]["class"].new()
	var preview_piece_position = preview_piece.get_current_rotation()
		
	for n in 4:
		var block = tetris_block.instantiate()
		var pos = preview_piece_position[n]
		
		block.modulate = preview_piece.color
		blocks.append(block)
		
		block.position = Vector2(
			pos[0] * 32 + 16 + pieces[piece]["x_offset"], 
			pos[1] * 32 + 16 + pieces[piece]["y_offset"])
			
		add_child(block)
