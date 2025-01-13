#condition: when y-vel is -, or pos in section (top half)
#behavior: align x, move towards puck

extends State
class_name active
@export var Ai: CharacterBody2D
@onready var puck = get_parent().get_parent().get_parent().get_node("Puck")

var move_direction : Vector2

func _ready():
	if Ai == null:
		Ai = get_parent().get_parent()

func Physics_Update(delta: float):
	Ai.direction = puck.global_position - Ai.global_position
	
	Ai.velocity  = Ai.direction.normalized() * Ai.speed
	
		
