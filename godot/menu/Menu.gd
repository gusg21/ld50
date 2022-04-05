extends Node2D

var selection = 1
var push_registered = false
var up_y = 48
var down_y = -77 - 26

var credits_focus = false
var evade_focus = false

func right():
	return (Input.get_joy_axis(0, 0) > 0.5 or Input.is_joy_button_pressed(0, 15)) or Input.is_action_just_pressed("move_right")

func left():
	return (Input.get_joy_axis(0, 0) < -0.5 or Input.is_joy_button_pressed(0, 14)) or Input.is_action_just_pressed("move_left")

func neither():
	return abs(Input.get_joy_axis(0, 0)) < 0.5 and \
			(not Input.is_joy_button_pressed(0, 14) and not Input.is_joy_button_pressed(0, 15)) and \
			Input.get_axis("move_left", "move_right") == 0

func select():
	return Input.is_joy_button_pressed(0, 0) or Input.is_action_just_pressed("select")

func back():
	return Input.is_joy_button_pressed(0, 1) or Input.is_action_just_pressed("back")

func _physics_process(delta):
	if evade_focus:
		return
	
	Globals.num_players = max(Input.get_connected_joypads().size(), 1)
	Globals.any_controllers = Input.get_connected_joypads().size() > 0
	
	if !credits_focus:
		if right() and !push_registered:
			selection -= 1
			$Switch.play()
			push_registered = true
		
		if left() and !push_registered:
			selection += 1
			$Switch.play()
			push_registered = true
		
		if neither():
			push_registered = false
			
		selection = wrapi(selection, 0, 3)
		
		if select():
			$Select.play()
			
			if selection == 0:
				$Tween.interpolate_property(Globals.bg, "position:y", up_y, down_y, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
				for i in range(3):
					$Tween.interpolate_property(get_node("o" + str(i)), "modulate:a", 1, 0.5, 0.5, Tween.TRANS_LINEAR)
				$Tween.start()
				yield($Tween, "tween_all_completed")
				credits_focus = true
			if selection == 2:
				$Tween.interpolate_property(self, "modulate:a", 1, 0, 1, Tween.TRANS_LINEAR)
				$Tween.start()
				Globals.num_players = max(Input.get_connected_joypads().size(), 1)
				Globals.menu_cutscene.play()
				evade_focus = true
								
			if selection == 1: # quit
				$Tween.stop_all()
				get_tree().paused = true
				$Tween.interpolate_property(Globals.menu_fade, "modulate:a", 0, 1, 0.5, Tween.TRANS_LINEAR)
				$Tween.start()
				yield($Tween, "tween_all_completed")
				get_tree().quit(0)
	else:
		if back():
			$Back.play()
			
			$Tween.interpolate_property(Globals.bg, "position:y", down_y, up_y, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			for i in range(3):
				$Tween.interpolate_property(get_node("o" + str(i)), "modulate:a", 0.5, 1, 0.5, Tween.TRANS_LINEAR)				
			$Tween.start()
			yield($Tween, "tween_all_completed")
			credits_focus = false

	var o = get_node("o" + str(selection))
	$Selection.global_position = o.rect_global_position + o.rect_size / 2 + Vector2(0, 1)
