extends Node2D

export var pedestrians : Array

var spawn_time = 2

func _on_Timer_timeout():
	var ped = pedestrians[randi() % pedestrians.size()].instance()
	
	add_child(ped)
	
	$Timer.wait_time = spawn_time * rand_range(0.8, 2)
