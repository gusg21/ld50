extends Sprite

var velocity = Vector2()

func _ready():
	velocity = Vector2(-1, rand_range(-1.5, -0.5))

func _process(delta):
	velocity.y += 0.1
	
	position += velocity
