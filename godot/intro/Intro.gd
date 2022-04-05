extends Node2D

var done = false
var was_select

func _ready():
	$Tween.interpolate_property($BGM, "volume_db", -80, -11, 3, Tween.TRANS_QUAD, Tween.EASE_OUT, 1)
	$Tween.start()
	
func select():
	return Input.is_joy_button_pressed(0, 0) or Input.is_action_pressed("select")

func _physics_process(delta):
	if done and !select() and was_select:
		get_tree().change_scene("res://menu/MainMenu.tscn")
		Globals.menu_bgm_location = $BGM.get_playback_position()
	
	was_select = select()

func _on_Timer_timeout():
	for i in range(5):
		print(i)
		var n = get_node("Line" + str(i))
		print(n)
		n.visible = true
		n.modulate.a = 0
		$Tween.interpolate_property(n, "modulate:a", 0.0, 1.0, 2, Tween.TRANS_LINEAR)
		$Tween.start()
		yield(get_tree().create_timer(4), "timeout")
		if i == 0:
			$Tween.interpolate_property(n, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR)
			$Tween.start()
	
	done = true
