extends RigidBody2D

class_name Parcel;

var can_pick: bool = false;
var picking: bool = false;
var picking_mouse_rel: Vector2;

var shouldReject: bool = true;

@export var force_scale = 0.5;

func _ready() -> void:
	$Label.text = "To: " + AddressGenerator.create_address() + "\n\n" + "From: " + AddressGenerator.create_address()

func _physics_process(delta: float) -> void:
	var m_pos = get_global_mouse_position()
	if (picking):
		move_and_collide(m_pos + picking_mouse_rel - position)
		#global_transform.origin = m_pos - picking_mouse_rel


func _on_mouse_entered() -> void:
	can_pick = true

func _on_mouse_exited() -> void:
	can_pick = false

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("click") && can_pick):
		picking = true
		picking_mouse_rel = position - get_global_mouse_position()
		freeze = true
	elif (event.is_action_released("click") && picking):
		picking = false
		freeze = false
		apply_impulse(force_scale * Input.get_last_mouse_velocity())
