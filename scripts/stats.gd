extends Node

var max_opens: int = 5

var day_correct: int
var day_opens_remaining: int

func reset_stats() -> void:
	day_correct = 0
	day_opens_remaining = max_opens

func _ready():
	reset_stats()
