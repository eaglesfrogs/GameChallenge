extends Area2D

@export_enum('mouse', 'ai') var movement_mechanism
var screen_size
var height

func _ready():
	screen_size = get_viewport_rect().size
	height = $CollisionShape2D.shape.size.y

func _input(event):
	if movement_mechanism == 0:
		if event is InputEventMouseMotion:
			position.y = event.position.y
		
		position = position.clamp(Vector2.ZERO, screen_size)
		
func _process(_delta):
	if movement_mechanism == 1:	
		position.y = get_parent().find_child("Ball").position.y
		
		position = position.clamp(Vector2.ZERO, screen_size)
		
