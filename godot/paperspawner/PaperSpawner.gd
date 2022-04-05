extends Node2D

export var paper_scene : PackedScene
export var destroy_scene : PackedScene

func random_pt_in_poly(poly : PoolVector2Array, steps=10):
	var pt = poly[randi() % poly.size()]
	for i in range(steps):
		pt = lerp(pt, poly[randi() % poly.size()], 0.5)
	return pt

func _on_Spawn_Timer_timeout():
	var paper = paper_scene.instance()
	var target = random_pt_in_poly($PaperArea.polygon)
	paper.my_position = Vector3(target.x, target.y, -200)
	paper.target_pt = target
	paper.destroy_scene = destroy_scene
	add_child(paper)
