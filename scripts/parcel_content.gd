extends Node2D

class_name ParcelContent;

enum Category {
	GLASS,
	SOFT,
	PLASTIC,
	CHINA,
	METAL,
	HARD
};

enum Classification {
	ALCOHOL,
	ART,
	CLOTHING,
	FOOD,
	PERISHABLES,
	WEAPON,
	TOY,
	NONE
}

# NOTE: use name
# TODO: items that have a different name when seen (white powder could be cocaine or flour)
@export var item_name: String;
@export var category: Category;
@export var classification: Classification;
@export var fragile: bool;

func init() -> Node:
	var label: Label = Label.new()
	label.text = tr(item_name)
	return label
