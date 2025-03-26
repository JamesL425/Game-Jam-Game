extends Node2D

func _ready() -> void:
	$Background/CenterContainer/VBoxContainer/Container.text = "Score: " + str(Stats.day_correct) + "/10"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	Stats.reset_stats()
	pass # Replace with function body.
