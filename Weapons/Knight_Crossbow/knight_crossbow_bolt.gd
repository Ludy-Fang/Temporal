extends Area2D

@export var bolt_speed : int = 1000

func _ready():
	
	# Bullets will always be visible
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT * bolt_speed).rotated(rotation) * delta
