#condition: when y-vel is -, or pos in section (top half)
#behavior: align x, move towards puck

extends State
class_name active

var puck_direction : Vector2

func Enter():
	move_direction = Vector2()