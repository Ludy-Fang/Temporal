extends State
class_name EnemyIdle

# Get enemy, sprite, and raycasts
@export var enemy : CharacterBody2D
@export var enemy_sprite : Sprite2D
@export var ledge_check_left : RayCast2D
@export var ledge_check_right : RayCast2D

# Movement speed
@export var movement_speed : float = 100.0

# Wander direction and time, which will be randomized
var move_direction : Vector2
var wander_time : float

func Randomize_Movement():
	move_direction = Vector2(randf_range(-50, 50), 0).normalized()
	wander_time = randf_range(1, 3)

# On entering state, randomize movement
func Enter():
	Randomize_Movement()

func Update(delta: float):
	
	# Flipping sprite in accordance to velocity.x
	if (enemy.velocity.x > 0):
		enemy_sprite.flip_h = false
	elif (enemy.velocity.x < 0):
		enemy_sprite.flip_h = true
	
	# Once wanter time runs out, randomize movement again
	if wander_time > 0:
		wander_time -= delta
	else: 
		Randomize_Movement()

func Physics_Update(_delta: float):
	
	# Check if enemy is going to walk off a ledge, and turning around if so
	# Also increasing wander_time to avoid rapid turning
	if (enemy.velocity.x > 0):
		if not ledge_check_right.is_colliding():
			move_direction *= -1
			wander_time += 1
	elif (enemy.velocity.x < 0):
		if not ledge_check_left.is_colliding():
			move_direction *= -1
			wander_time += 1
	
	# Moving enemy
	if enemy:
		enemy.velocity = move_direction * movement_speed
