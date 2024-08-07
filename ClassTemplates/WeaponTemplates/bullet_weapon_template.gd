extends Node2D
class_name Bullet_Weapon

@onready var bullet : PackedScene
@export var player : CharacterBody2D
@export var spawn_position : Marker2D
@export var bullet_cooldown : Timer

var player_position : Vector2
var can_shoot : bool = true

func _process(_delta) -> void:
	flip_weapon()
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		bullet_cooldown.start()
		shooting()

func flip_weapon() -> void:
	player_position.x = player.global_position.x
	
	# Flip the weapon if mouse is on left side of screen
	if (get_global_mouse_position().x > player_position.x):
		scale = Vector2(1, 1)
	else:
		scale = Vector2(1, -1)

func shooting() -> void:
	# Create bullet instance, and set its rotation and spawn location
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = spawn_position.global_position
	add_child(bullet_instance)

func _on_timer_timeout() -> void:
	can_shoot = true
