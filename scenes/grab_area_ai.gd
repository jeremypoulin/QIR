extends Area2D

func body_entered(body):
	print("yo")
	if body is RigidBody2D:
		print("bruh")
		body.mode = RigidBody2D.FREEZE_MODE_STATIC
		body.get_parent().remove_child(body)
		get_parent().add_child(body)
