extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if(area.name == "Area2D"):
		print("P1Scored")
	else:
		print("P2Scored")


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
