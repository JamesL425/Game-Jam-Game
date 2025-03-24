extends Control


func _on_play_button_pressed() -> void:
	# TODO: Load before?
	get_tree().change_scene_to_file("res://scenes/game.tscn");
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit();
	pass # Replace with function body.
