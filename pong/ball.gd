extends Area2D

@export var speed = 800 # How fast the player will move (pixels/sec).
var screen_size
var y_direction = 0
var x_direction = 1

signal scored(side: int)

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):	
	var velocity = Vector2.ZERO
	
	if position.y <= 10 or position.y >= screen_size.y - 10:
		y_direction *= -1
		
	if position.x <= 10:
		scored.emit(0)
		reset_ball(1)
	if position.x >= screen_size.x - 10:
		scored.emit(1)
		reset_ball(-1)
	
	velocity.x += x_direction
	velocity.y += y_direction
	
	velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func reset_ball(new_x_direction):
	y_direction = 0
	x_direction = new_x_direction
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2

func _on_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.name.contains("Paddle"):
		var ball_y = position.y
		var paddle_y = area.position.y
		var paddle_height_half = area.height / 2
		var ball_paddle_diff = ball_y - paddle_y
		var pall_paddle_ratio = ball_paddle_diff / paddle_height_half
		
		y_direction = tan(deg_to_rad(80 * pall_paddle_ratio))
		
		x_direction *= -1
