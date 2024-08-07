extends Area2D
class_name Bullet

var velocity : Vector2 = Vector2.RIGHT
@export var bullet_speed : int

# Bullets will always be visible
func _ready() -> void:
	set_as_top_level(true)

# Change position by multiplying velocity by bullet speed and delta
# Rotation is set by weapon scripts
func _process(delta: float) -> void:
	position += (velocity * bullet_speed).rotated(rotation) * delta

# Queue_free if hit or exits screen
func _on_body_entered(_body) -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
