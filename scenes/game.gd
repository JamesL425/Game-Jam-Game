extends Node2D

signal parcel_resolved

@export var parcel_scene: PackedScene

func _on_parcel_resolved() -> void:
	var parcel = parcel_scene.instantiate()
	parcel.position = $ParcelStartPosition.position

func _ready() -> void:
	new_game()

func new_game():
	var parcel = parcel_scene.instantiate()
	add_child(parcel)
	
func game_over():
	pass	
