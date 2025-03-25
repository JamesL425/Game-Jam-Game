extends Node2D

var should_have_stamp: bool;

func _ready() -> void:
	$Label.text = AddressGenerator.create_address()
