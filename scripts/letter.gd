extends Node2D

@export var addressGenerator: Node;

func _ready() -> void:
	$Label.text = addressGenerator.create_address()
