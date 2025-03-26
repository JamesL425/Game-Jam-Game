extends Node2D

@export var parcel_scene: PackedScene

var current_day: Day;
var parcel_index = 0;

func spawn_parcel() -> void:
	if (current_day.done() && current_day.number != 4):
		# TODO: new day
		get_tree().call_deferred("change_scene_to_file", "res://scenes/end_of_day_screen.tscn")
	elif !(current_day.number == 4 and current_day.index == 0):
		var parcel = current_day.next_parcel()
		parcel.position = $game_content/ParcelStartPosition.position
		parcel.name = "Parcel" + str(parcel_index)
		parcel_index += 1
		$game_content.call_deferred("add_child", parcel)
	else:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over_screen.tscn")
func _ready() -> void:
	current_day = GlobalDaysList.get_next_day();
	if current_day.number == 0:
		$"Background Music".play()
	spawn_parcel()

func game_over():
	pass

func _on_approve_basket_parcel_collected(correct: bool) -> void:
	if correct:
		Stats.day_correct += 1
	spawn_parcel()

func _on_reject_basket_parcel_collected(correct: bool) -> void:
	if correct:
		Stats.day_correct += 1
	spawn_parcel()
