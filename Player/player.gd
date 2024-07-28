extends CharacterBody2D

# Variables for jumping 
@export var jump_height : float = 100.0
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

# Sprite and timers
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var roll_cooldown : Timer = $RollCooldown

# Buffer and coyote time frames
@export var jump_buffer_time : int = 15
@export var coyote_time : int = 15
var jump_buffer_counter : int = 0
var coyote_counter : int = 0

# Friction and air friction
const friction : float = 0.5
const air_friction : float = 0.2
const maximum_falling_velocity : float = 400.0
var previous_velocity : Vector2

# Variables for movement
@export var max_speed : float = 200.0
@export var roll_speed : float = 600.0
@export var acceleration : float = 50.0

# Bool variables
var can_roll : bool = true
var player_direction : bool = true

func _physics_process(delta):
	
	if position.y > 20:
		position = Vector2(3, -20)
	
	if Input.is_action_pressed("roll") and can_roll:
		can_roll = false
		
		roll_cooldown.start()
		
		# Applying a high velocity.x instantly for roll
		if (player_direction == true):
			velocity.x = roll_speed * delta
		else:
			velocity.x = -roll_speed * delta
	
	moving()
	jumping(delta)
	move_and_slide()
	
	# Getting previous velocity for air friction
	previous_velocity = velocity

func get_gravity() -> float:
	
	# Returns normal gravity if player is jumping
	if (velocity.y < 0.0):
		return jump_gravity
	
	# Returns greater gravity if player is falling
	else:
		return fall_gravity

func moving():
	
	# Movement and flipping sprite left/right
	if Input.is_action_pressed("right"):
		velocity.x += acceleration
		sprite_2d.flip_h = false
		player_direction = true
	
	elif Input.is_action_pressed("left"):
		velocity.x -= acceleration
		sprite_2d.flip_h = true
		player_direction = false
	
	# Returning velocity.x to 0 if no keys are pressed
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	
	# Lerping velocity.x to maximum_speed if player is not rolling
	if (velocity.x > max_speed) or (velocity.x < -max_speed):
		if (player_direction == true):
			velocity.x = lerp(velocity.x, max_speed, friction)
		else: 
			velocity.x = lerp(velocity.x, -max_speed, friction)

func jumping(delta):
	
	# Applying gravity and air friction
	if not is_on_floor():
		velocity.y += get_gravity() * delta
		velocity.x = lerp(previous_velocity.x, velocity.x, air_friction)
	# Setting maximum falling gravity
	if (velocity.y >= maximum_falling_velocity):
		velocity.y = maximum_falling_velocity
	
	# Coyote time
	if is_on_floor():
		coyote_counter = coyote_time
	
	if not is_on_floor():
		if coyote_counter > 0:
			coyote_counter -= 1
	
	# Allowing smaller jumps with smaller presses
	if Input.is_action_just_released("up") and velocity.y < 0:
			velocity.y = -jump_velocity / 10
	
	# Jump buffer
	if Input.is_action_just_pressed("up"):
		jump_buffer_counter = jump_buffer_time
	
	if (jump_buffer_counter > 0):
		jump_buffer_counter -= 1
	
	# Jumping
	if (jump_buffer_counter > 0) and (coyote_counter > 0):
		velocity.y = jump_velocity
		jump_buffer_counter = 0

# Roll cooldown and time of rolling
func _on_roll_cooldown_timeout():
	can_roll = true
