extends CharacterBody2D

func _physics_process(_delta):
	
	if not is_on_floor():
		velocity.y += 100
	
	move_and_slide()
