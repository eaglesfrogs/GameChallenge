extends Node2D

var player_score = 0
var ai_score = 0

func _ready():
	set_scores()
	
func set_scores():
	$PlayerScore.text = "%s" % player_score
	$AILabel.text = "%s" % ai_score

func _on_ball_scored(side):
	if side == 0:
		ai_score += 1
	else:
		player_score += 1
		
	set_scores()
