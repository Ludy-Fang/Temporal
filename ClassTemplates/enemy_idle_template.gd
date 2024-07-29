extends State
class_name EnemyIdle

@export var enemy : CharacterBody2D
@export var movement_speed : float = 100.0

var move_direction : Vector2
var wander_time : float

func Randomize_Movement():
	move_direction = Vector2(randf_range(-50, 50), 0).normalized()
	wander_time = randf_range(1, 3)

func Enter():
	Randomize_Movement()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else: 
		Randomize_Movement()

func Physics_Update(_delta: float):
	if enemy:
		enemy.velocity = move_direction * movement_speed
