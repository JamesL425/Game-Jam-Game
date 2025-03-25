extends Node

var current_day_index = 0;

@onready var day0: Day = Day.new();

@onready var parcel: PackedScene = preload("res://scenes/parcel.tscn")

var wine_content = ParcelContent.new()
var glass_content = ParcelContent.new()

func init_content() -> void:
	wine_content.item_name = "WINE"
	wine_content.category = ParcelContent.Category.GLASS
	wine_content.fragile = true

func make_random_parcel() -> Parcel:
	var p: Parcel = parcel.instantiate()
	p.init_box_parcel([wine_content])
	return p


func _ready() -> void:
	init_content()
	day0.parcels.resize(10)
	for i in 10:
		day0.parcels[i] = make_random_parcel()
	
	day0.parcels.shuffle()
