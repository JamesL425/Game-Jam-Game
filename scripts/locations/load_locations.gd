extends Node

@export var locations_json: JSON;

var locations: Variant;

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

func _ready() -> void:
	locations = locations_json.get_data()
	rng.randomize()
	print(create_address())

# TODO: weighted random based on population
func create_address() -> String:
	var country_index = rng.randi_range(0, locations.size()-1)
	var country = locations[country_index]
	var city_index = rng.randi_range(0, country.cities.size() - 1)
	var city = country.cities[city_index]
	var street_index = rng.randi_range(0, city.streets.size() - 1)
	var street = city.streets[street_index]
	var house = rng.randi_range(1, street.length);
	var out: String = str(house) + " " + street.name + "\n" + city.name + "\n" + country.name;
	return out
