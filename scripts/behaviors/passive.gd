#when y velocity is positive on the bottom half of the arena (player side)
#positions to center/guard

extends State
class_name passive
@export var Ai: CharacterBody2D
@onready var puck = get_parent().get_parent().get_parent().get_node("Puck")
@onready var casper = get_parent().get_parent().get_parent().get_node("casper")

func _ready():
	if Ai == null:
		Ai = get_parent().get_parent()

func Physics_Update(delta: float):
	Ai.direction = casper.global_position - Ai.global_position
	
	Ai.velocity  = Ai.direction.normalized() * Ai.speed
	
	if(Ai.global_position == casper.global_position):
		Ai.velocity = Vector2.ZERO
	
	if (puck.linear_velocity.y < 0 || puck.linear_velocity.y > 0 && puck.global_position.y < 600):
		Transitioned.emit(self, "active")
