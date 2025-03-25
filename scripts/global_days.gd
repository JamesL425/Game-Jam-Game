extends Node

var current_day_index = 0;

@onready var day0: Day = Day.new();

@onready var parcel: PackedScene = preload("res://scenes/parcel.tscn")

var wine_content = ParcelContent.new()
var glass_content = ParcelContent.new()

func init_content() -> void:
	wine_content.item_name = "METAL"
	wine_content.category = ParcelContent.Category.METAL
	wine_content.fragile = true
	glass_content.item_name = "WINE"
	glass_content.category = ParcelContent.Category.GLASS
	glass_content.fragile = true

func generate_insides_of_parcel() -> Array[ParcelContent]:
	var possible_contents = [wine_content,
		glass_content]
	
	var out: Array[ParcelContent] = []
		
	for i in randi_range(1, 3):
		out.append(possible_contents.pick_random())
		print(out[i].item_name)
		
	return out
	
func make_random_parcel() -> Parcel:
	var p: Parcel = parcel.instantiate()
	p.init_box_parcel(generate_insides_of_parcel())
	return p


func _ready() -> void:
	init_content()
	day0.parcels.resize(10)
	for i in 10:
		day0.parcels[i] = make_random_parcel()
	
	day0.parcels.shuffle()
