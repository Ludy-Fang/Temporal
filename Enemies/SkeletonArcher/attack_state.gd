extends State

@export var enemy_sprite : Sprite2D
@export var enemy : CharacterBody2D
@export var player : CharacterBody2D
@export var movement_speed : float = 50.0
@export var ledge_check_left : RayCast2D
@export var ledge_check_right : RayCast2D
@export var line_of_sight : RayCast2D
@export var range_check : RayCast2D
var direction : Vector2

func Enter():
	line_of_sight.scale = Vector2(1, 1)
	player = get_tree().get_nodes_in_group("Player")[0]

func Update(_delta: float):
	line_of_sight.look_at(player.global_position)
	range_check.look_at(player.global_position)
	
	if line_of_sight.get_collider() is Player == false:
		print(line_of_sight.get_collider())
		print("Transitioned from attack to idle")
		Transitioned.emit(self, "idle")

func Physics_Update(_delta: float):
	
	# Flipping enemy in accordance to velocity.x, along with los
	if (enemy.velocity.x > 0):
		enemy_sprite.flip_h = false
	elif (enemy.velocity.x < 0):
		enemy_sprite.flip_h = true
	
	if (player.global_position.x > enemy.position.x):
		enemy.velocity.x = movement_speed
	else:
		enemy.velocity.x = -movement_speed
	
	if (enemy.velocity.x > 0) and (not ledge_check_right.is_colliding()):
		enemy.velocity.x = 0
	elif (enemy.velocity.x < 0) and (not ledge_check_left.is_colliding()):
		enemy.velocity.x = 0
	
	enemy.move_and_slide()
