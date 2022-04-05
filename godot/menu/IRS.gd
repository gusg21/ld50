extends Sprite

var moving = false
var elapsed = 0

func _physics_process(delta):
	elapsed += delta
	if moving:
		scale.y = 1 + sin(elapsed * 50) / 30
	else:
		scale.y = lerp(scale.y, 1, 0.3)
