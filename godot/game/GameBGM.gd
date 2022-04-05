extends AudioStreamPlayer

func _ready():
	Globals.game_bgm = self

func fade_in():
	$Tween.interpolate_property(self, "volume_db", -80, volume_db, 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	volume_db = -80
	play()
