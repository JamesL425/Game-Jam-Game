extends Node

var current_day_index = 0;

@onready var day0: Day = Day.new();

@onready var parcel: PackedScene = preload("res://scenes/parcel.tscn")

var wine = create_parcel_content("WINE", ParcelContent.Category.GLASS, ParcelContent.Classification.ALCOHOL, true)
var glass = create_parcel_content("GLASS", ParcelContent.Category.GLASS, ParcelContent.Classification.NONE, true)
var clothes = create_parcel_content("CLOTHES", ParcelContent.Category.SOFT, ParcelContent.Classification.CLOTHING, false)
var plate = create_parcel_content("PLATE", ParcelContent.Category.CHINA, ParcelContent.Classification.ART, true)
var stone = create_parcel_content("STONE", ParcelContent.Category.HARD, ParcelContent.Classification.ART, false)
var pickle = create_parcel_content("PICKLE", ParcelContent.Category.GLASS, ParcelContent.Classification.FOOD, true)
var toy = create_parcel_content("TOY", ParcelContent.Category.PLASTIC, ParcelContent.Classification.TOY, false)

func create_parcel_content(item_name: String, category: ParcelContent.Category, classification: ParcelContent.Classification, fragile: bool) -> ParcelContent:
	var p: ParcelContent = ParcelContent.new()
	p.category = category
	p.item_name = item_name
	p.fragile = fragile
	p.classification = classification
	return p

func generate_insides_of_parcel() -> Array[ParcelContent]:
	var possible_contents = [wine, glass, clothes, plate, stone, pickle, toy]
	
	var out: Array[ParcelContent] = []
		
	for i in randi_range(1, 3):
		out.append(possible_contents.pick_random())
		print(out[i].item_name)
		
	return out

var should_reject_last_generated_parcel_declarations: bool = false
func generate_declarations(content: Array[ParcelContent]) -> Array[ParcelContent.Classification]:
	should_reject_last_generated_parcel_declarations = false
	var out: Array[ParcelContent.Classification]
	var dict: Dictionary[ParcelContent.Classification, int]
	for c in content:
		dict[c.classification] = 1
	out = dict.keys()
	out.shuffle()
	if out.size() == 0:
		return out
	
	while (randi_range(0, 5) == 0 and out.size() > 0):
		out.remove_at(out.size()-1)
		should_reject_last_generated_parcel_declarations = true
	
	return out

func make_random_parcel() -> Parcel:
	var p: Parcel = parcel.instantiate()
	var content = generate_insides_of_parcel()
	var declarations = generate_declarations(content)
	p.init_box_parcel(content, declarations)
	p.shouldReject = should_reject_last_generated_parcel_declarations
	return p


func _ready() -> void:
	day0.parcels.resize(10)
	for i in 10:
		day0.parcels[i] = make_random_parcel()
	
	day0.parcels.shuffle()
