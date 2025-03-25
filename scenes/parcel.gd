extends RigidBody2D

var can_pick: bool = false;
var picking: bool = false;
var picking_mouse_rel: Vector2;

var shouldReject: bool = true;

var is_fragile: bool = true;
var fragile_jerk_max: float = 1000;

var prev_velocity: Vector2 = Vector2(0, 0);

@export var force_scale = 0.5;

func _ready() -> void:
	$Address.text = "To: " + AddressGenerator.create_address() + "\n\n" + "From: " + AddressGenerator.create_address()
	if not is_fragile:
		$Fragile.hide()

func _physics_process(delta: float) -> void:
	var m_pos = get_global_mouse_position()
	if (picking):
		var velocity: Vector2 = m_pos + picking_mouse_rel - position
		var collision: KinematicCollision2D = move_and_collide(velocity)
		if collision:
			velocity -= collision.get_remainder()
		if (is_fragile):
			if (velocity - prev_velocity).length_squared() > fragile_jerk_max:
				print("Broke")
		prev_velocity = velocity
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
