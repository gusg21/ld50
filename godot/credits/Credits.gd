extends Sprite

var vibrate = false
var og_pos

func _ready():
	og_pos = position

func _physics_process(delta):
	if vibrate:
		position = og_pos + Vector2(rand_range(-1, 1), rand_range(-1, 1))

func _on_Timer_timeout():
	vibrate = true
