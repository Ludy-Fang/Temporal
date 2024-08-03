extends State
class_name EnemyIdle

# Get enemy, sprite, and ledge/wall check raycasts
@export var enemy : CharacterBody2D
@export var enemy_sprite : Sprite2D
@export var ledge_check_left : RayCast2D
@export var ledge_check_right : RayCast2D
@export var wall_check_right : RayCast2D
@export var wall_check_left : RayCast2D

# Line of sight raycast, and the rotation of the raycast
@export var line_of_sight : RayCast2D
@onready var los_rotation : float = -30

# Movement speed
@export var movement_speed : float = 100.0

# Wander direction and time, which will be randomized
var move_direction : int
var wander_time : float

func Randomize_Movement():
	move_direction = randi_range(-1, 1)
	wander_time = randf_range(1, 3)

# On entering state, randomize movement
func Enter():
	Randomize_Movement()

func Update(delta: float):
	
	# Make raycast sweep an area to detect if player is there
	line_of_sight.set_rotation_degrees(los_rotation)
	los_rotation += 1
	if (los_rotation > 30):
		los_rotation = -30
	
	# Transition to attack state if player is detected
	if line_of_sight.is_colliding() and line_of_sight.get_collider() is Player:
		print("Transitioned from idle to attack")
		Transitioned.emit(self, "attack")
	
	# Once wander time runs out, randomize movement again
	if wander_time > 0:
		wander_time -= delta
	else: 
		Randomize_Movement()

func Physics_Update(_delta: float):
	
	# Flipping enemy in accordance to velocity.x, along with los
	if (enemy.velocity.x > 0):
		enemy_sprite.flip_h = false
		line_of_sight.scale = Vector2(1, 1)
	elif (enemy.velocity.x < 0):
		enemy_sprite.flip_h = true
		line_of_sight.scale = Vector2(-1, 1)
	
	# Check if enemy is going to walk off a ledge/into a wall, and turning around if so
	# Also increasing wander_time to avoid rapid turning
	if (enemy.velocity.x > 0):
		if not ledge_check_right.is_colliding() or wall_check_right.is_colliding():
				move_direction *= -1
				wander_time += 1
	elif (enemy.velocity.x < 0):
		if not ledge_check_left.is_colliding() or wall_check_left.is_colliding():
				move_direction *= -1
				wander_time += 1
	
	# Moving enemy
	if enemy:
		enemy.velocity.x = movement_speed * move_direction
