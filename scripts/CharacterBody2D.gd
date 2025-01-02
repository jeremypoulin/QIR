extends CharacterBody2D

var direction_type = 0
var rising = true
var throw_counter = 0
var stun_counter = 0
var stunned = false
var grabbed = false
var speed = 400
var outgoing_force = speed * 0.1
var lunge_counter = 0.0
var lunge_duration = 0.0
var lunging = false
var collision_counter = 0
var direction = Vector2.ZERO
@onready var puck = get_parent().get_node("Puck")
@onready var lunge_bar = get_parent().get_node("Control/LungeBar")
@onready var throw_bar = get_parent().get_node("Control/ThrowBar")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	#display lunge bar
	lunge_bar.value = lunge_counter
	#display throw bar
	throw_bar.value = throw_counter
	#get velocity vector and convert to unit vector
	direction = Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	if(direction != Vector2.ZERO):
		direction_type = 0
		direction = direction.normalized()
	else:
		animated_sprite.play("idle")
		
	if(direction.x > 0 && direction.y == 0):
		direction_type = 1
		animated_sprite.play("right")
	if(direction.x < 0 && direction.y == 0):
		direction_type = 2
		animated_sprite.play("left")
	if(direction.y > 0 && direction.x == 0):
		direction_type = 3
		animated_sprite.play("down")
	if(direction.y < 0 && direction.x == 0):
		direction_type = 4
		animated_sprite.play("up")
	if(direction.x > 0 && direction.y > 0):
		direction_type = 5
		animated_sprite.play("down")
	if(direction.x > 0 && direction.y < 0):
		direction_type = 6
		animated_sprite.play("up")
	if(direction.x < 0 && direction.y > 0):
		direction_type = 7
		animated_sprite.play("down")
	if(direction.x < 0 && direction.y < 0):
		direction_type = 8
		animated_sprite.play("up")
	#lunge cooldown counter
	if(Input.is_action_pressed("ui_lunge") == false && lunge_counter < 100.0):
		lunge_counter += 1.0
	#while(Input.is_action_pressed("ui_lunge") == true && lunge_counter > 0):
		#lunge_counter -= 1
		
	#lunge mechanic
	if(Input.is_action_pressed("ui_lunge") == true && lunge_counter == 100.0 || lunge_duration > 0.0):
		print("lunging")
		if(lunging == false):
			lunge_duration = 10.0
		lunging = true
		lunge_counter = 0.0
		lunge_bar.value = lunge_bar.min_value
		speed = 1200
		if(lunge_duration > 0.0):
			lunge_duration -= 1.0
			if(lunge_duration == 0.0):
				lunging = false
				
	else:
		speed = 400
	#normal movement
	if(!grabbed && !stunned):
		velocity = direction * speed
		move_and_slide()

	#collision cooldown counter
	if(collision_counter > 0):
		collision_counter -= 1
	#collision
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if(collision.get_collider() is RigidBody2D && collision_counter == 0):
			collision_counter = 50
			collision.get_collider().apply_central_impulse(-collision.get_normal() * outgoing_force)
			velocity = Vector2.ZERO
			stunned = true
			stun_counter = 50
			
	if(stunned && stun_counter > 0):
		stun_counter -= 1
		if(stun_counter <= 0):
			stunned = false
	if(grabbed):
		print("GRABBED")
		if(rising == true):
			throw_counter += 2
			if(throw_counter >= 100):
				rising = false
		if(rising == false):
			throw_counter -= 2
			if(throw_counter <= 0):
				rising = true
				_throw()
		
	
	if(!puck.complete && Input.is_action_pressed("ui_grab")):
		_grab()
				
	if(puck.complete && Input.is_action_pressed("ui_throw")):
		_throw()
		
func _grab():
	if(puck.in_range && !puck.complete && Input.is_action_pressed("ui_grab")):
		puck.complete = true
		print("grab!")
		puck.linear_velocity = Vector2.ZERO
		grabbed = true
		puck.freeze = true
		puck.scale.x = 0.5
		puck.scale.y = 0.5
		puck.global_position = global_position
		
func _throw():
	puck.complete = false
	grabbed = false
	puck.freeze = false
	if(direction_type == 0 || 4):
		puck.global_position.x = global_position.x + 0
		puck.global_position.y = global_position.y - 100
	if(direction_type == 1):
		puck.global_position.x = global_position.x + 100
		puck.global_position.y = global_position.y - 0
	if(direction_type == 2):
		puck.global_position.x = global_position.x - 100
		puck.global_position.y = global_position.y - 0
	if(direction_type == 3):
		puck.global_position.x = global_position.x + 0
		puck.global_position.y = global_position.y + 100
	if(direction_type == 5):
		puck.global_position.x = global_position.x + 100
		puck.global_position.y = global_position.y + 100
	if(direction_type == 6):
		puck.global_position.x = global_position.x + 100
		puck.global_position.y = global_position.y - 100
	if(direction_type == 7):
		puck.global_position.x = global_position.x - 100
		puck.global_position.y = global_position.y + 100
	if(direction_type == 8):
		puck.global_position.x = global_position.x - 100
		puck.global_position.y = global_position.y - 100
	puck.scale.x = 1
	puck.scale.y = 1
	if(direction == Vector2.ZERO):
		puck.linear_velocity = (speed + (10 * throw_counter)) * Vector2.UP
	else:
		puck.linear_velocity = (speed + (10 * throw_counter)) * direction
	throw_counter = 0
