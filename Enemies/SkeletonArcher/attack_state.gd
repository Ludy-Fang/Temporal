extends State

@export var enemy_sprite : Sprite2D
@export var enemy : CharacterBody2D
@export var player : CharacterBody2D
@export var movement_speed : float = 50.0
@export var ledge_check_left : RayCast2D
@export var ledge_check_right : RayCast2D
var direction : Vector2

func Enter():
	player = get_tree().get_nodes_in_group("Player")[0]

func Update(_delta: float):
	# Flipping sprite in accordance to velocity.x
	if (enemy.velocity.x > 0):
		enemy_sprite.flip_h = false
	elif (enemy.velocity.x < 0):
		enemy_sprite.flip_h = true

func Physics_Update(_delta: float):
	if (player.global_position.x > enemy.position.x):
		enemy.velocity.x = movement_speed
	else:
		enemy.velocity.x = -movement_speed
	
	if (enemy.velocity.x > 0) and (not ledge_check_right.is_colliding()):
		enemy.velocity.x = 0
	elif (enemy.velocity.x < 0) and (not ledge_check_left.is_colliding()):
		enemy.velocity.x = 0
	
	enemy.move_and_slide()
