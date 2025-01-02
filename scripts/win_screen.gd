extends Control

@onready var label: Label = $MarginContainer/VBoxContainer/Label

func _ready() -> void:
	if(Global.bottom_player_win):
		label.text = "P1 Wins!"
	else:
		label.text = "P2 Wins!"
	Global.bottom_player_win = false
	Global.top_player_win = false

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
