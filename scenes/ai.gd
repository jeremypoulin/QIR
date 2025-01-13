extends CharacterBody2D
class_name ai
@onready var puck = get_parent().get_node("Puck")

var direction_type = 0
var rising = true
var throw_counter = 0
var stun_counter = 0
var stunned = false
var grabbed = false
var grab_counter = 0
var throwing = true
var no_collisions = 0
var speed = 400
var outgoing_force = speed * 0.1
var lunge_counter = 0.0
var lunge_duration = 0.0
var lunging = false
var direction = Vector2.ZERO
var collision_counter = 0
var spacer = 0
var other_direction = Vector2.ZERO

func _physics_process(delta):
	if(!grabbed && !stunned):
		move_and_slide()
	
	if(!grabbed && grab_counter > 0):
		grab_counter -= 1
	
	if(throwing):
		no_collisions -= 1
		if(no_collisions <= 0):
			puck.set_collision_mask_value(6, true)
			set_collision_mask_value(3, true)
			throwing = false
			no_collisions = 0
	
	if(collision_counter > 0):
		collision_counter -= 1
		
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if(collision.get_collider() is RigidBody2D && collision_counter == 0 && no_collisions <= 0):
			collision_counter = 50
			if(lunging):
				collision.get_collider().apply_central_impulse(-collision.get_normal() * (outgoing_force * 3))
			else:
				collision.get_collider().apply_central_impulse(-collision.get_normal() * outgoing_force)
			if(abs(puck.linear_velocity.length()) > abs(speed) * 3/4 && puck.linear_velocity.length() > 300 || velocity == Vector2.ZERO && puck.linear_velocity.length() >= 300):
				stunned = true
				stun_counter = 50
				velocity = Vector2.ZERO
	
	if(stunned && stun_counter > 0):
		stun_counter -= 1
		if(stun_counter <= 0):
			stunned = false
			
	if(grabbed):
		spacer -= 1
		$Arrow.visible = true
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
				
		
	if(!puck.complete && Input.is_action_pressed("ui_grab") && grab_counter == 0):
		_grab()
				
	if(puck.complete && Input.is_action_just_pressed("ui_grab")):
		_throw()
			
			
func _grab():
	if(puck.in_range && !puck.complete && Input.is_action_pressed("ui_grab") && !stunned):
		spacer = 3
		puck.complete = true
		print("grab!")
		puck.linear_velocity = Vector2.ZERO
		grabbed = true
		puck.freeze = true
		puck.scale.x = 0.5
		puck.scale.y = 0.5
		puck.global_position = global_position
		
func _throw():
	if(spacer <= 0):
		spacer = 0
		$Arrow.visible = false
		puck.complete = false
		grabbed = false
		puck.freeze = false
		grab_counter = 50
		throwing = true
		no_collisions = 50
		puck.set_collision_mask_value(4, false)
		set_collision_mask_value(3, false)
		puck.scale.x = 1
		puck.scale.y = 1
		if(direction == Vector2.ZERO):
			puck.linear_velocity = (speed + (10 * throw_counter)) * Vector2.UP
		else:
			puck.linear_velocity = (speed + (10 * throw_counter)) * direction
		throw_counter = 0
		puck.global_position.x = global_position.x
		puck.global_position.y = global_position.y
