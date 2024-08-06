extends CharacterBody2D
class_name Player

# Variables for jumping 
@export var jump_height : float = 100.0
@export var jump_time_to_peak : float = 0.6
@export var jump_time_to_descent : float = 0.5
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

# Sprites, timers, collision, and raycheck
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var roll_cooldown : Timer = $RollCooldown
@onready var roll_timer : Timer = $RollTimer
@onready var collision_cooldown : Timer = $CollisionDisabled
@onready var ground_check : RayCast2D = $GroundCheck
@onready var player_collision : CollisionShape2D = $CollisionShape2D

# Jump/roll buffer and coyote time frames
@export var jump_buffer_time : int = 15
@export var coyote_time : int = 20
@export var roll_buffer_time : int = 20
var jump_buffer_counter : int = 0
var coyote_counter : int = 0
var roll_buffer_counter : int = 0

# Friction and air friction
const friction : float = 0.5
const air_friction : float = 0.2
const maximum_falling_velocity : float = 400.0
var previous_velocity : Vector2

# Variables for movement
@export var max_speed : float = 200.0
@export var roll_speed : float = 400.0
@export var acceleration : float = 50.0

# Bool variables
var can_roll : bool = true
var player_direction : bool = true
var rolling : bool = false

func _physics_process(delta):
	roll()
	moving()
	jumping(delta)
	move_and_slide()
	platform_check()
	
	# Getting previous velocity for air friction
	previous_velocity = velocity

func roll():
	
	# Roll buffer
	if Input.is_action_pressed("roll"):
		roll_buffer_counter = roll_buffer_time
	
	if (roll_buffer_counter > 0):
		roll_buffer_counter -= 1
	
	if (roll_buffer_counter > 0) and can_roll:
		# Change bools to indicate player is rolling and start timers
		can_roll = false
		rolling = true
		roll_timer.start()
		roll_cooldown.start()
		
		# Setting player's velocity to the roll speed
		if player_direction:
			velocity.x = roll_speed
		else:
			velocity.x = -roll_speed

func get_gravity() -> float:
	
	# Reduce gravity if roll is active
	if rolling:
		return fall_gravity / 4
	
	else:
		# Returns normal gravity if player is jumping
		if (velocity.y < 0.0):
			return jump_gravity
		
		# Returns greater gravity if player is falling
		else:
			return fall_gravity

func moving():
	
	# Movement and flipping sprite left/right
	if Input.is_action_pressed("right"):
		if not rolling:
			velocity.x += acceleration
			sprite_2d.flip_h = false
			$KnightCrossbow.scale = Vector2(1, 1)
			player_direction = true
	
	elif Input.is_action_pressed("left"):
		if not rolling:
			velocity.x -= acceleration
			sprite_2d.flip_h = true
			$KnightCrossbow.scale = Vector2(-1, 1)
			player_direction = false
	
	# Returning velocity.x to 0 if no keys are pressed and not rolling
	else:
		if not rolling:
			velocity.x = lerp(velocity.x, 0.0, friction)
	
	# Capping velocity.x to maximum_speed if player is not rolling
	if (velocity.x > max_speed) or (velocity.x < -max_speed):
		if not rolling:
			velocity.x = clamp(velocity.x, -max_speed, max_speed)

func jumping(delta):
	
	# Applying gravity
	if not is_on_floor():
		velocity.y += get_gravity() * delta
		
		# Applying air friction if player is not rolling
		if not rolling:
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

func platform_check():
	var collider : Object = ground_check.get_collider()
	if collider:
		if collider.is_in_group("Platform") and Input.is_action_pressed("down"):
			player_collision.disabled = true
			collision_cooldown.start()

# Roll cooldown and time of rolling
func _on_roll_cooldown_timeout():
	can_roll = true

func _on_roll_timer_timeout():
	rolling = false

func _on_collision_disabled_timeout():
	player_collision.disabled = false
