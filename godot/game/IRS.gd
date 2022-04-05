extends Node2D

export var follow_path : NodePath
onready var follow = get_node(follow_path)
var elapsed = 0

func _physics_process(delta):
	elapsed += delta
	follow.unit_offset = Globals.game_progress
	var velocity = follow.global_position - global_position
	global_position = follow.global_position
	$GFX.flip_h = velocity.x > 0
	$GFX.position.y = abs(sin(elapsed * 10)) * -2
	$GFX.rotation = sin(elapsed * 10) / 10
	
	$Alert.emitting = Globals.game_progress > Globals.warning_threshold
	if $Alert.emitting and !$AlertSound.playing:
		$AlertSound.play()
