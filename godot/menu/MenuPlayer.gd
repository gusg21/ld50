extends Sprite

class_name MenuPlayer

var elapsed = 0
var x_max = 0
var x_min = 0
var moving = false
var cutscene = false

func _ready():
	Globals.menu_player = self
	
	x_max = position.x
	x_min = position.x - 100
	
func _physics_process(delta):
	elapsed += delta
	if moving:
		scale.y = 1 + sin(elapsed * 50) / 30
	else:
		scale.y = lerp(scale.y, 1, 0.3)

func stop():
	moving = false
	cutscene = true
	$Timer.stop()
	$Tween.remove_all()
	$Tween.stop_all()
	
func look_right():
	$Tween.interpolate_property(self, "scale:x", scale.x, -1, 0.1, Tween.TRANS_QUAD)
	$Tween.start()

func look_left():
	$Tween.interpolate_property(self, "scale:x", scale.x, 1, 0.1, Tween.TRANS_QUAD)
	$Tween.start()

func _on_Timer_timeout():
	if cutscene:
		return
	
	var target_x = rand_range(x_min, x_max)
	if target_x > position.x:
		$Tween.interpolate_property(self, "scale:x", scale.x, -1, 0.1, Tween.TRANS_QUAD)
	else:
		$Tween.interpolate_property(self, "scale:x", scale.x, 1, 0.1, Tween.TRANS_QUAD)
	$Tween.interpolate_property(self, "position:x", position.x, target_x, 1.5, Tween.TRANS_LINEAR)
	$Tween.start()
	
	$Timer.wait_time = rand_range(1.5, 4)
	$Timer.start()
	
	moving = true


func _on_Tween_tween_all_completed():
	moving = false
