extends Node

class_name Day;

@export var parcels: Array[Parcel];
var index: int;

var has_newspaper: bool;
var newspaper_content: String;

func _ready() -> void:
	index = 0

func done() -> bool:
	return index >= parcels.size()

func next_parcel() -> Parcel:
	var prev_index = index
	index += 1
	return parcels[prev_index]
