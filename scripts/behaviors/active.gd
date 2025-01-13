#condition: when y-vel is -, or pos in section (top half)
#behavior: align x, move towards puck

extends State
class_name active
@export var Ai: CharacterBody2D
@onready var puck = get_parent().get_parent().get_parent().get_node("Puck")
@onready var character = get_parent().get_parent().get_parent().get_node("Character")

func _ready():
	if Ai == null:
		Ai = get_parent().get_parent()

func Physics_Update(delta: float):
	Ai.direction = puck.global_position - Ai.global_position
	
	Ai.velocity  = Ai.direction.normalized() * Ai.speed
	
	if (puck.linear_velocity.y > 0 && puck.global_position.y > 600 || character.grabbed):
		Transitioned.emit(self, "passive")

	
		
