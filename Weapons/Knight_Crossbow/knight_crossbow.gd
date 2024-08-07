extends Bullet_Weapon

# Preload crossbow bolt scene
func _init() -> void:
	bullet = preload("res://Weapons/Knight_Crossbow/knight_crossbow_bolt.tscn")

func flip_weapon() -> void:
	player_position.x = player.global_position.x
	
	# Flip the weapon if mouse is on left side of screen
	if (get_global_mouse_position().x > player_position.x):
		scale = Vector2(1, 1)
		position = Vector2(0, 3)
	else:
		scale = Vector2(1, -1)

func _on_timer_timeout() -> void:
	can_shoot = true
