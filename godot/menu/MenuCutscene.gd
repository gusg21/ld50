extends Node2D

class_name MenuCutscene

export var knock_scene : PackedScene
export var game_scene : PackedScene
export var ruined_tex : Texture
export var ruined_irs : Texture
export var bg_path : NodePath
export var desk_path : NodePath
export var paper_scene : PackedScene

onready var bg = get_node(bg_path)
onready var desk = get_node(desk_path)

func _ready():
	Globals.menu_cutscene = self

func knock():
	var k = knock_scene.instance()
	$Knocks.add_child(k)

func play():
	Globals.menu_player.stop()
	
	$Tween.interpolate_property(Globals.menu_bgm, "volume_db", Globals.menu_bgm.volume_db, -80, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	
	# knocks
	knock()
	yield(get_tree().create_timer(0.2), "timeout")
	knock()
	Globals.menu_player.look_right()
	yield(get_tree().create_timer(0.2), "timeout")
	knock()
	
	Globals.menu_bgm.stop()
	
	# wait
	yield(get_tree().create_timer(2), "timeout")
	
	# show irs
	$Door.play()
	$Tween.interpolate_property($IRS, "position:x", $IRS.position.x + 30, $IRS.position.x, 1, Tween.TRANS_LINEAR)
	$IRS.moving = true
	$Tween.start()
	$IRS.visible = true
	$IRS.position.x = $IRS.position.x + 30
	yield($Tween, "tween_all_completed")
	$IRS.moving = false
	
	# wait
	yield(get_tree().create_timer(1), "timeout")
	
	# IRS talk
	$Chatter1.play()
	$IRS.moving = true
	yield(get_tree().create_timer(4.6), "timeout")
#	$Chatter1.play()
	$IRS.moving = false
	
	yield(get_tree().create_timer(1), "timeout")
	
	# player talk
	Globals.menu_player.moving = true
	$Chatter2.play()
	yield(get_tree().create_timer(3.2), "timeout")
	Globals.menu_player.moving = false
	
	yield(get_tree().create_timer(1), "timeout")
	
	# IRS talk
	$Chatter3.play()
	$IRS.moving = true
	$IRS/Angry.emitting = true
	yield(get_tree().create_timer(1.8), "timeout")
	$IRS/Angry.emitting = false	
	$IRS.moving = false
	
	# walk calmly to window
	Globals.menu_player.moving = true
	Globals.menu_player.look_left()
	$Tween.interpolate_property(Globals.menu_player, "global_position:x", Globals.menu_player.global_position.x, $JumpLocation.global_position.x, 1.5, Tween.TRANS_LINEAR)
	$Tween.start()
	
	# wait
	yield(get_tree().create_timer(2), "timeout")
	
	# the funny
	Globals.menu_player.visible = false
	Globals.camera.shake(0.5)
	Globals.camera.flash()
	bg.texture = ruined_tex
	$Tween.interpolate_property(desk, "position:x", desk.position.x, desk.position.x - 20, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.interpolate_property($IRS, "position:x", $IRS.position.x, $IRS.position.x - 80, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.start()
	$IRS.texture = ruined_irs
	$Window.play()
	$Dog.play()
	$Explosion.emitting = true
	
	yield(get_tree().create_timer(4), "timeout")
	
	# go to game
	get_tree().change_scene_to(game_scene)
