extends Node

signal paper_grabbed

# menu
var any_controllers : bool = false
var num_players = 1
var bg : Sprite
var menu_fade : Sprite
var menu_cutscene : MenuCutscene
var menu_player : MenuPlayer
var menu_bgm : AudioStreamPlayer
var menu_bgm_location : float

# game
var shadow_scene = preload("res://shadow/Shadow.tscn")
var camera : GusCamera
var papers_grabbed = 0
var papers = []
var game_bgm : AudioStreamPlayer
var game_progress = 0
var game_length = 10
var warning_threshold = 0.7
var docs_destroyed = 0
var doc_goal = 1
var big_display : BigDisplay
