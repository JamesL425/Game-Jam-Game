extends Node2D

signal parcel_resolved

@export var parcel_scene: PackedScene

func _on_parcel_resolved() -> void:
	get_tree().call_group("parcel_group", "queue_free")
	var parcel = parcel_scene.instantiate()
	parcel.position = $ParcelStartPosition.position
	add_child(parcel)

func _ready() -> void:
	new_game()

func new_game():
	var parcel = parcel_scene.instantiate()
	parcel.position = $ParcelStartPosition.position
	add_child(parcel)
	
func game_over():
	pass	
