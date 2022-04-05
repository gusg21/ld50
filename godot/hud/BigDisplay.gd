extends Node2D

class_name BigDisplay

func _ready():
	Globals.big_display = self

func display(text):
	$Text.text = text
	
	$BG.visible = true
	$BG.modulate.a = 0
	$Text.visible = true
	$Text.rect_position.x = $BG.position.x + 400
	
	$Tween.interpolate_property($BG, "modulate:a", 0, 1, 0.5, Tween.TRANS_LINEAR)
	$Tween.interpolate_property($Text, "rect_position:x", $BG.position.x + 400, $BG.position.x - $Text.rect_size.x / 2 - 10, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	
	yield(get_tree().create_timer(2.5), "timeout")
	
	$Tween.interpolate_property($BG, "modulate:a", 1, 0, 0.5, Tween.TRANS_LINEAR)
	$Tween.interpolate_property($Text, "rect_position:x", $BG.position.x - $Text.rect_size.x / 2 - 10, $BG.position.x - 400, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	
	$BG.visible = false
	$Text.visible = false
