extends AudioStreamPlayer

export var particles_path : NodePath
onready var particles = get_node(particles_path)

func _ready():
	Globals.menu_bgm = self
	play(Globals.menu_bgm_location)

func _physics_process(delta):
	particles.emitting = playing
