extends Control

func _ready() -> void:
	TranslationServer.set_locale("en");
	$"Menu Music".play()

func _on_play_button_pressed() -> void:
	# TODO: Load before?
	$"Menu Music".stop()
	get_tree().change_scene_to_file("res://scenes/game.tscn");
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	$"Menu Music".stop()
	get_tree().quit();
	pass # Replace with function body.


func _on_language_dropdown_item_selected(index: int) -> void:
	if (index == 0):
		TranslationServer.set_locale("en");
	else:
		TranslationServer.set_locale("ja");
