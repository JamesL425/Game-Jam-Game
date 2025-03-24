extends Node2D

signal parcel_resolved

@export var parcel_scene: PackedScene

func _on_parcel_resolved() -> void:
	var parcel = parcel_scene.instantiate()
	parcel.position = $ParcelStartPosition.position

func new_game():
	pass

func game_over():
	pass	
