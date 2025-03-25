extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	# TODO: fragile as fuck
	if (body.name == "Parcel"):
		if (name == "RejectBasket"):
			if body.shouldReject:
				print("correct")
		else:
			if (!body.shouldReject):
				print("correct")
		body.queue_free()
