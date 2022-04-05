extends Node2D

class_name ZActor

var my_position = Vector3(position.x, position.y, 0.0)
var use_shadow = true
var shadow : Sprite

func _ready():
	if not has_node("Shadow20"):
		shadow = Globals.shadow_scene.instance()
		add_child(shadow)
	else:
		shadow = get_node("Shadow20")

func do_z(gfx):
	
	
