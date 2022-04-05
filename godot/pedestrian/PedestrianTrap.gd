extends Area2D



func _on_Pedestrian_Trap_body_entered(body):
	if body.is_in_group("pedestrian"):
		body.trap($new_target.global_position)
