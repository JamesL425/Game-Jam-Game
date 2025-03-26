extends RigidBody2D

class_name Parcel;

var can_pick: bool = false;
var picking: bool = false;
var picking_mouse_rel: Vector2;

var shouldReject: bool = true;

enum ParcelType {
	LETTER,
	BOX,
}

var type: ParcelType = ParcelType.BOX;
# for letter
var has_stamp: bool;
var letter_text: String = "Hello, World"

# for box
var content: Array[ParcelContent];
var declared_content: Array[ParcelContent.Classification];

@export var force_scale = 0.5;
@export var letter_scale: Vector2 = Vector2(5, 2.5);
@export var parcel_scale: Vector2 = Vector2(10, 10);
@export var letter_texture: Texture;
@export var box_texture: Texture;

var hitbox_scale_constant: Vector2;
var sprite_scale_constant: Vector2;

func resize(this_scale: Vector2) -> void:
	sprite_scale_constant = Vector2($Sprite2D.texture.get_width(), $Sprite2D.texture.get_height())
	hitbox_scale_constant = $Hitbox.shape.get_size()
	$Hitbox.scale = this_scale
	$Sprite2D.scale = this_scale / sprite_scale_constant * hitbox_scale_constant;

func init_letter_parcel(in_has_stamp: bool, in_letter_text: String) -> void:
	$Sprite2D.texture = letter_texture
	resize(letter_scale)
	has_stamp = in_has_stamp
	letter_text = in_letter_text
	$AddressLetter.text = AddressGenerator.create_address()
	type = ParcelType.LETTER
	
func init_box_parcel(in_content: Array[ParcelContent], in_declarations: Array[ParcelContent.Classification]) -> void:
	$Sprite2D.texture = box_texture
	resize(parcel_scale)
	content = in_content
	declared_content = in_declarations
	$AddressBox.text = "To: " + AddressGenerator.create_address() + "\n\n" + "From: " + AddressGenerator.create_address()
	if content.any(func(c): return c.fragile) or randi_range(0, 4) == 0:
		$FragileLabel.show()
	type = ParcelType.BOX

var prev_velocity: Vector2 = Vector2(0, 0);
var shake_accel: float = 1000;

func momentary_accel_compute(dt: float, curr_velocity: Vector2, p_velocity: Vector2) -> void:
	var accel = (curr_velocity - p_velocity) / dt
	if (accel.length() > shake_accel && curr_velocity.dot(p_velocity) < 0):
		if content.any(func(c): return c.category == ParcelContent.Category.GLASS):
			$"Glass Sound".play()
		if content.any(func(c): return c.category == ParcelContent.Category.METAL):
			$"Metal Sound".play()
		if content.any(func(c): return c.fragile):
			print("Broke")

func _physics_process(delta: float) -> void:
	var m_pos = get_global_mouse_position()
	if (picking):
		var curr_velocity = m_pos + picking_mouse_rel - position
		var collision: KinematicCollision2D = move_and_collide(curr_velocity)
		if collision:
			curr_velocity -= collision.get_remainder()
		momentary_accel_compute(delta, curr_velocity, prev_velocity)
		prev_velocity = curr_velocity
		#global_transform.origin = m_pos - picking_mouse_rel

func _on_mouse_entered() -> void:
	can_pick = true

func _on_mouse_exited() -> void:
	can_pick = false

var UI_Path: String = "../../UI"

var vertical_spacer: VBoxContainer

func select() -> void:
	picking = true
	picking_mouse_rel = position - get_global_mouse_position()
	freeze = true
	if (type == ParcelType.BOX):
		vertical_spacer = VBoxContainer.new();
		for c in declared_content:
			var label = Label.new()
			label.text = str(ParcelContent.Classification.keys()[c])
			vertical_spacer.add_child(label)
		get_node(UI_Path).add_child(vertical_spacer)
	
func deselect() -> void:
	picking = false
	freeze = false
	apply_impulse(force_scale * Input.get_last_mouse_velocity())
	prev_velocity = Vector2(0, 0)
	if (type == ParcelType.BOX):
		vertical_spacer.queue_free()

var is_open: bool = false

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("click") && can_pick):
		select()
	elif (event.is_action_released("click") && picking):
		deselect()
		
	if (picking && event.is_action_pressed("rclick")):
		if Stats.day_opens_remaining > 0:
			is_open = true;
			open()
			Stats.day_opens_remaining -= 1
			get_node(UI_Path + "/RemainingOpens").text = "Remaining Opens: " + str(Stats.day_opens_remaining) + "/5"
	if (is_open && event.is_action_pressed("escape")):
		is_open = false;
		close()

var open_scene: Node;

var letter_open_scene: PackedScene = preload("res://scenes/letter_open_scene.tscn")
var box_open_scene: PackedScene = preload("res://scenes/box_open_scene.tscn")
func open():
	if type == ParcelType.BOX:
		var open_box = box_open_scene.instantiate()
		var label: Label
		for c in content:
			label = Label.new()
			label.text = c.item_name
			open_box.get_node("Box/Content").add_child(label)
		set_physics_process(false)
		get_node(UI_Path).add_child(open_box)
		#get_node(UI_Path).show()
		open_scene = open_box
	else:
		var open_letter = letter_open_scene.instantiate()
		open_letter.get_node("Letter").text = letter_text
		set_physics_process(false)
		get_node(UI_Path).add_child(open_letter)
		#get_node(UI_Path).show()
		open_scene = open_letter

func close() -> void:
	set_physics_process(true)
	#get_node(UI_Path).hide()
	open_scene.queue_free()
