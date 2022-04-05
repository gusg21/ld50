extends KinematicBody2D

export var squish_tex : Texture
export var normal_tex : Texture
export var my_device = 0

var elapsed = 0
var last_mouse_pos

var original_tex
var original_leaf_offset = Vector2.ZERO
var fall_height = 6000
var falling = false
var splat_amt = .2
var display_banner = false


var my_position = Vector3()
var velocity = Vector2()
var aim_angle = 0
var going_right = false
var playable = false
var moving = false
var friction = .3
var move_speed = 50

func _ready():
	print(Globals.num_players, my_device)
	if !(Globals.num_players > my_device):
		queue_free()
	
	visible = false
	randomize()
	
	$GFX.texture = normal_tex
	original_tex = $GFX.texture
	original_leaf_offset = $Leafblower.offset
	
	fall_height *= rand_range(0.9, 1.1)
	$Tween.interpolate_property(
		self, "my_position", my_position + Vector3(0, 0, -fall_height), my_position, fall_height / 1600, Tween.TRANS_LINEAR
	)
	$Tween.start()
	falling = true
	my_position += Vector3(0, 0, -fall_height)
	$Audio/Falling.play()
	$Leafblower.visible = false
	
	Globals.connect("paper_grabbed", self, "_on_paper_grabbed")

func get_move_vector():
	if my_device == 0:
		var key_move = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		)
		if key_move.length_squared() != 0:
			return key_move

	return Vector2(
			dz(Input.get_joy_axis(my_device, 0)),
			dz(Input.get_joy_axis(my_device, 1))
			)

func _physics_process(delta):
	elapsed += delta
	
	if playable:
		var target_velocity = get_move_vector() * move_speed
		
		velocity = velocity.linear_interpolate(target_velocity, friction);
		
		move_and_slide(velocity)
	
		if target_velocity.x > 0 and !going_right:
			$Tween.interpolate_property($GFX, "scale:x", 1, -1, 0.05, Tween.TRANS_QUAD)
			$Tween.start()
		if target_velocity.x < 0 and going_right:
			$Tween.interpolate_property($GFX, "scale:x", -1, 1, 0.05, Tween.TRANS_QUAD)
			$Tween.start()
		
		if target_velocity.x != 0:
			going_right = target_velocity.x > 0
		
		if target_velocity.x == 0 and moving:
			$Tween.interpolate_property($GFX, "scale:y", $GFX.scale.y, 1, 0.1, Tween.TRANS_QUAD)
			$Tween.start() 
		
		moving = target_velocity.x != 0
		
		if moving:
			$GFX.scale.y = 1 + sin(elapsed * 50) / 30
		
		do_leafblower()
	
	z_index = global_position.y
	
	if falling:
		$GFX.position = Vector2(my_position.x, my_position.y + my_position.z)
	else:
		$GFX.position = Vector2.ZERO
		
		if !Globals.game_bgm.playing:
			Globals.game_bgm.fade_in()
		
		
	last_mouse_pos = get_global_mouse_position()
	
	visible = Globals.num_players > my_device

func dz(x):
	if abs(x) < 0.05:
		return 0
	return x

func is_leafblowing():
	if my_device == 0:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			return true
	
	return Input.is_joy_button_pressed(my_device, 5) or Input.is_joy_button_pressed(my_device, 7) or Input.get_joy_axis(my_device, 7) > 0.5

func get_aim_vec():
	if my_device == 0 and last_mouse_pos != get_global_mouse_position():
		return -(get_global_mouse_position() - global_position)
	
	return Vector2(
		-Input.get_joy_axis(my_device, 2),
		-Input.get_joy_axis(my_device, 3)
	)

func do_leafblower():
	var aim_vec = get_aim_vec()
	if aim_vec.length() > 0.3:
		aim_angle = aim_vec.angle()
		$Leafblower.flip_v = aim_vec.x < 0
		$Leafblower/CPUParticles2D.position.y = -1 if $Leafblower.flip_v else 1
	
	$Leafblower.rotation = aim_angle
	
	if is_leafblowing():
		if !$Leafblow.playing:
			$Leafblow.play()
		$Leafblower/CPUParticles2D.emitting = true
		$Leafblower.offset = original_leaf_offset + Vector2(
			rand_range(-2, 2),
			rand_range(-2, 2)
		)
		
		var primary_direction : Vector2 = -aim_vec 
		primary_direction = primary_direction.normalized()
		
		var spacing = 0.1
		var count = 2 # on either side
		var exclude = [self]
		
		var shape : SegmentShape2D = SegmentShape2D.new()
		shape.a = global_position
		shape.b = global_position + primary_direction * 100
		var query : Physics2DShapeQueryParameters = Physics2DShapeQueryParameters.new()
		query.collide_with_areas = true
		query.collide_with_bodies = true
		query.set_shape(shape)
		query.exclude = exclude
		var results = get_world_2d().direct_space_state.intersect_shape(query, 100)

		for result in results:
			if result.collider is KinematicBody2D and !result.collider.is_in_group("player"):
				var paper = result.collider
				paper.apply_velocity(primary_direction * 10)
	else:
		if $Leafblow.playing:
			$Leafblow.stop()
		$Leafblower/CPUParticles2D.emitting = false		
		$Leafblower.offset = original_leaf_offset

func _on_paper_grabbed():
	var r = randi() % 3
	if r == 0:
		$Audio/Pickup.play()
	elif r == 1:
		$Audio/Pickup2.play()
	elif r == 2:
		$Audio/Pickup3.play()

func _on_Tween_tween_completed(object, key):
	if falling:
		falling = false
		$GFX.texture = squish_tex
		$Shadow20.visible = false
		Globals.camera.shake(0.5)
		Input.start_joy_vibration(my_device, 1, 1, 0.1)
		$Audio/Splat.play()
		$Audio/Falling.stop()
		$Tween.interpolate_property(self, "scale", 
			Vector2(1 + splat_amt, 1 + splat_amt), 
			Vector2.ONE, 0.5, 
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$Tween.start()
		yield(get_tree().create_timer(1), "timeout")
		$GFX.texture = original_tex
		$Shadow20.visible = true
		playable = true
		$Tween.interpolate_property(self, "scale", 
			Vector2(1, .5), 
			Vector2.ONE, 0.5, 
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$Tween.start()
		$Leafblower.visible = true
		
		
