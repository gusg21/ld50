extends Sprite

export var player_num : int

func _physics_process(delta):
	if Globals.num_players >= player_num:
		visible = true
	else:
		visible = false
