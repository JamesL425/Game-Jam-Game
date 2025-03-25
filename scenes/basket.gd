extends Area2D

signal parcel_collected

@export var fg_texture: Texture;
@export var bg_texture: Texture;

func _ready() -> void:
	$BasketSprite.texture = fg_texture
	$bgSprite.texture = bg_texture

func _on_body_entered(body: Node2D) -> void:
	# TODO: fragile as fuck
	if (body.name.begins_with("Parcel")):
		var was_correct: bool
		if (name == "RejectBasket"):
			was_correct = body.shouldReject
		else:
			was_correct = !body.shouldReject
		emit_signal("parcel_collected", was_correct)
		body.queue_free()
