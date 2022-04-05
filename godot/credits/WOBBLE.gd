extends Sprite

func _process(delta):
	global_position.x -= 3
	rotation -= 0.1
	
	if global_position.x < -20:
		global_position.x = 360
