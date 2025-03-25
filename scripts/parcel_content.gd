extends Node2D

class_name ParcelContent;

enum Category {
	GLASS,
	SOFT,
	PLASTIC,
	CHINA
};

# NOTE: use name
# TODO: items that have a different name when seen (white powder could be cocaine or flour)
@export var item_name: String;
@export var category: Category;
@export var fragile: bool;
