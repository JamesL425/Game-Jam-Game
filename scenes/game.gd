extends Node2D

@export var parcel_scene: PackedScene

var current_day: Day;
var parcel_index = 0;

func spawn_parcel() -> void:
	if (current_day.done()):
		# TODO: new day
		pass
	
	#get_tree().call_group("parcel_group", "queue_free")
	
	#var parcel = parcel_scene.instantiate()
	var parcel = current_day.next_parcel()
	parcel.position = $game_content/ParcelStartPosition.position
	parcel.name = "Parcel" + str(parcel_index)
	parcel_index += 1
	$game_content.call_deferred("add_child", parcel)

func _ready() -> void:
	current_day = GlobalDaysList.day0;
	spawn_parcel()
	$UI.hide();
	
func game_over():
	pass

func _on_approve_basket_parcel_collected(correct: bool) -> void:
	if correct:
		print("correct")
	spawn_parcel()


func _on_reject_basket_parcel_collected(correct: bool) -> void:
	if correct:
		print("correct")
	spawn_parcel()
