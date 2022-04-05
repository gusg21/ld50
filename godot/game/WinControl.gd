extends Node2D

export var next_level : PackedScene
export var level_text : String
export var level_length : float = 90.0
export var doc_goal : int = 900

var lost = false
var won = false

func _ready():
	Globals.doc_goal = doc_goal
	Globals.game_length = level_length


func _physics_process(delta):
	if Globals.game_progress >= 1 and !lost:
		lost = true
		get_tree().paused = true
		Globals.big_display.display("YOU LOSE...")
		yield(get_tree().create_timer(4), "timeout")
		Globals.camera.flash()
		yield(get_tree().create_timer(0.1), "timeout")
		Globals.game_progress = 0
		get_tree().paused = false		
		get_tree().change_scene("res://menu/MainMenu.tscn")
	if Globals.docs_destroyed >= Globals.doc_goal and !won:
		won = true
		get_tree().paused = true
		Globals.big_display.display("YOU WIN!")
		yield(get_tree().create_timer(4), "timeout")
		Globals.camera.flash()
		yield(get_tree().create_timer(0.1), "timeout")
		Globals.game_progress = 0
		Globals.docs_destroyed = 0
		get_tree().paused = false		
		get_tree().change_scene_to(next_level)


func _on_Timer_timeout():
	Globals.big_display.display(level_text)
