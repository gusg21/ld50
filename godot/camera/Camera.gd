extends Camera2D

class_name GusCamera

var timer = 0
var elapsed = 0
var noise = OpenSimplexNoise.new()
var my_offset = Vector2()
var flash_spr

func _ready():
	Globals.camera = self
	
	if has_node("Flash"):
		flash_spr = get_node("Flash")
		flash_spr.visible = false
	
func _physics_process(delta):
	elapsed += delta
	
	if timer >= 0:
		my_offset = Vector2(
			noise.get_noise_1d(elapsed * 10000 + 100) * timer * 50,
			noise.get_noise_1d(elapsed * 10000 + 10) * timer * 50
			)
		zoom = Vector2(
			1 + noise.get_noise_1d(elapsed * 10000 + 10000) * timer * 0.2,
			1 + noise.get_noise_1d(elapsed * 10000 + 1000) * timer * 0.2
			)
	else:
		my_offset = lerp(my_offset, Vector2.ZERO, 0.3)
		zoom = lerp(zoom, Vector2.ONE, 0.5)
		
	offset = my_offset
		
	timer -= delta
	
func shake(time):
	timer = time

func flash():
	if flash_spr == null:
		return
	
	flash_spr.visible = true
	yield(get_tree().create_timer(0.1), "timeout")
	flash_spr.visible = false
