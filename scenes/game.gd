extends Node2D

@export var parcel_scene: PackedScene

var current_day: Day;
var parcel_index = 0;

func spawn_parcel() -> void:
	if (current_day.done()):
		# TODO: new day
		get_tree().call_deferred("change_scene_to_file", "res://scenes/end_of_day_screen.tscn")
	else:
		var parcel = current_day.next_parcel()
		parcel.position = $game_content/ParcelStartPosition.position
		parcel.name = "Parcel" + str(parcel_index)
		parcel_index += 1
		$game_content.call_deferred("add_child", parcel)

func _ready() -> void:
	current_day = GlobalDaysList.get_next_day();
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
