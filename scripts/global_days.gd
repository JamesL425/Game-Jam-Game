extends Node

var current_day_index = 0;

@onready var day0: Day = Day.new();

@onready var parcel: PackedScene = preload("res://scenes/parcel.tscn")

func make_random_parcel() -> Parcel:
	var p: Parcel = parcel.instantiate()
	return p


func _ready() -> void:
	day0.parcels.resize(10)
	for i in 10:
		day0.parcels[i] = make_random_parcel()
	
	day0.parcels.shuffle()
