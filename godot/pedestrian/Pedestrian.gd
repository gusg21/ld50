extends KinematicBody2D

var target_pt : Vector2
var target : Node
var trapped : bool = false
var velocity : Vector2

var papers_grabbed = 0

func trap(pt):
	trapped = true
	target_pt = pt
	target = self

func _physics_process(delta):
	$Grabbed.text = str(papers_grabbed)
	$Grabbed.visible =  false
	
	if target == null and !trapped:
		while target == null:
			target = Globals.papers[randi() % Globals.papers.size()]
		
		if target != null:
			target_pt = target.global_position
	
	velocity = velocity.linear_interpolate((target_pt - global_position).normalized() * 30, 0.1)
	velocity = move_and_slide(velocity)
	
	if abs(velocity.x) > 0.1:
		$GFX.flip_h = velocity.x > 0
	
	if global_position.distance_to(target_pt) < 5:
		if trapped:
			queue_free()
		else:
			target = null
	
	if velocity.length_squared() < 0.5:
		target = null
	
	z_index = global_position.y
	
	var papers_processed = []
	for col_idx in range(get_slide_count()):
		var col = get_slide_collision(col_idx)
		if col.collider.is_in_group("void"):
			Globals.docs_destroyed += papers_grabbed
			queue_free()
		elif col.collider.is_in_group("paper") and papers_processed.find(col.collider) == -1:
			Globals.papers.erase(col.collider)
			col.collider.queue_free()
			papers_processed.append(col.collider)
			
			if col.collider == target and !trapped:
				target = null
	
#	update()

func apply_velocity(vel):
	velocity += vel * 10

func _draw():
#	draw_circle(Vector2.ZERO, 2, Color.lime)
#	draw_circle(to_local(target_pt), 20, Color.aqua)
	pass
