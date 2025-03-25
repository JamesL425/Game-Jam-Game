extends Area2D

signal parcel_collected

func _on_body_entered(body: Node2D) -> void:
	# TODO: fragile as fuck
	if (body.name.begins_with("Parcel")):
		var was_correct: bool
		if (name == "RejectBasket"):
			was_correct = body.shouldReject
		else:
			was_correct = !body.shouldReject
		emit_signal("parcel_collected", was_correct)
