extends Sprite

var elapsed = 0

func _physics_process(delta):
	elapsed += delta
	Globals.game_progress = elapsed / Globals.game_length
	
	if Globals.game_progress > Globals.warning_threshold:
		offset = Vector2(rand_range(-2, 2), rand_range(-2, 2))
	else:
		offset = offset.linear_interpolate(offset, 0.3)
