# audio from https://opengameart.org/content/unstable-pulse
extends Node2D

const SCORE_FONT_STRING = "[center][font_size=22]%s[/font_size][/center]"

var level = 1
var score = 0
var total_rows = 0
var paused = false

func _ready():
	$TetrisBoard.set_level(level)	
	update_level_score()
	
func format_score():
	var text = ""
	var tmp_score = score
	
	while tmp_score >= 1000:
		text += ",%03d" % (tmp_score % 1000)
		tmp_score /= 1000
			
	return "%s%s" % [tmp_score, text]

func update_level_score():
	$LevelBox/LevelBoxLabel.text = SCORE_FONT_STRING % level
	$ScoreBox/ScoreBoxLabel.text = SCORE_FONT_STRING % format_score()

func _on_tetris_board_rows_cleared(rows):
	total_rows += rows
	var score_multiplier = 1
	
	if rows == 2:
		score_multiplier = 3
	elif rows == 3:
		score_multiplier = 5
	elif rows == 4:
		score_multiplier = 8
		
	score += score_multiplier * level * 100
	
	if total_rows > level * 10:
		level += 1
		$TetrisBoard.set_level(level)
		
	update_level_score()
	
func _on_pause_button_pressed():
	if paused:
		$TetrisBoard.unpause()
		if $SoundToggle.button_pressed:
			$BackgroundMusic.stream_paused = false
		$PauseButton.text = "Pause"
	else:
		$TetrisBoard.pause()
		if $SoundToggle.button_pressed:
			$BackgroundMusic.stream_paused = true
		$PauseButton.text = "Resume"		
		
	paused = !paused

func _on_new_game_button_pressed():
	level = 1
	score = 0
	total_rows = 0
	
	if $SoundToggle.button_pressed:
		$BackgroundMusic.stop()
		$BackgroundMusic.play()
	
	$TetrisBoard.reset()
	$TetrisBoard.set_level(level)
	update_level_score()

func _on_tetris_board_next_piece(piece):
	$PreviewPane.render_piece(piece)

func _on_sound_toggle_toggled(toggled_on):
	if toggled_on:
		$BackgroundMusic.play()
	else:
		$BackgroundMusic.stop()
