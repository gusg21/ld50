extends KinematicBody2D

export var textures : Array

# set by spawner
var target_pt = Vector2()
var destroy_scene : PackedScene

var my_position = Vector3()
var my_velocity = Vector2()
var falling = true
var original_x
var elapsed = 0
var sway_freq = 2
var weight = 20
var angle = 0
var angular_velocity = 0.01
var blown = false

func _ready():
	$Collider.disabled = true
	angular_velocity *= rand_range(0.5, 2)
	weight = weight + rand_range(-5, 10)
	original_x = global_position.x
	$GFX.texture = textures[randi() % textures.size()]
	visible = false

func _physics_process(delta):
	elapsed += delta
	
	if falling:
		my_position.z += delta * weight
		
		if global_position.y > target_pt.y:
			falling = false
			Globals.papers.append(self)
			angle = 0
			global_position = $GFX.global_position
			my_position = Vector3(global_position.x, global_position.y, 0)
			$GFX.position = Vector2.ZERO
		else:
			$GFX.position.x = sin(elapsed * sway_freq) * 20
			$GFX.position.y = -(sin(elapsed * sway_freq) + 1) * 5
			angle += angular_velocity
			
	$Collider.disabled = falling
	$GFX.modulate.a = 0.3 if falling else 1
	
	my_velocity = lerp(my_velocity, Vector2.ZERO, 0.1)
	
	angle += my_velocity.length() / 10
	$GFX.rotation = floor(angle * PI/2) * PI/2
	
	if !falling:
		my_velocity = move_and_slide(my_velocity)
		
	my_position.x += my_velocity.x
	my_position.y += my_velocity.y
	
	global_position = Vector2(
		my_position.x, my_position.y + my_position.z
	)
	
	for slide_idx in get_slide_count():
		var col = get_slide_collision(slide_idx)
		if col.collider.is_in_group("void"):
			queue_free()
			Globals.papers.erase(self)
			if blown:
				Globals.docs_destroyed += 1
				var particle = destroy_scene.instance()
				particle.global_position = global_position
				get_parent().add_child(particle)
			
	
	z_index = my_position.y + $GFX.position.y
	
	visible = true

func apply_velocity(velocity):
	if !falling:
#		print(velocity)
		my_velocity = velocity
		blown = true

func _on_Area_body_entered(body : Node):
	if falling:
		return
	
	if body.is_in_group("void"):
		queue_free()
		Globals.papers.erase(self)
