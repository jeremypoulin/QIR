extends Control

@onready var local: Button = $MarginContainer/VBoxContainer/Local

func _ready() -> void:
	local.grab_focus()

func _on_local_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")


func _on_tournament_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")


func _on_practice_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
