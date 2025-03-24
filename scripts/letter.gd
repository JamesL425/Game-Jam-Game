extends Node2D

func _ready() -> void:
	$Label.text = AddressGenerator.create_address()
