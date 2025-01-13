#when y velocity is positive on the bottom half of the arena (player side)
#positions to center/guard

extends State
class_name passive
@onready var puck = get_parent().get_node("Puck")

func Physics_Update(delta: float):
	if (puck.velocity.y < 0 || puck.velocity > 0 && puck.global_position.y < 600):
		Transitioned.emit(self, "active")
