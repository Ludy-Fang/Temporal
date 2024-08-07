extends  Bullet

# Determine bullet speed
func _init() -> void:
	bullet_speed = 1000

# Override queue_free, make arrow stuck in environment/enemy instead
func _on_body_entered(_body) -> void:
	bullet_speed = 0
	velocity = Vector2(0, 0)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
