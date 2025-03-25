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
var declared_content: Array[String];

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

func init_letter_parcel(in_has_stamp: bool) -> void:
	$Sprite2D.texture = letter_texture
	resize(letter_scale)
	has_stamp = in_has_stamp
	$Label.text = AddressGenerator.create_address()
	
func init_box_parcel(in_content: Array[ParcelContent]) -> void:
	$Sprite2D.texture = box_texture
	resize(parcel_scale)
	content = in_content
	$Label.text = "To: " + AddressGenerator.create_address() + "\n\n" + "From: " + AddressGenerator.create_address()

func _physics_process(_delta: float) -> void:
	var m_pos = get_global_mouse_position()
	if (picking):
		move_and_collide(m_pos + picking_mouse_rel - position)
		#global_transform.origin = m_pos - picking_mouse_rel

func _on_mouse_entered() -> void:
	can_pick = true

func _on_mouse_exited() -> void:
	can_pick = false

var is_open: bool = false

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("click") && can_pick):
		picking = true
		picking_mouse_rel = position - get_global_mouse_position()
		freeze = true
	elif (event.is_action_released("click") && picking):
		picking = false
		freeze = false
		apply_impulse(force_scale * Input.get_last_mouse_velocity())
		
	if (picking && event.is_action_pressed("rclick")):
		is_open = true;
		open()
	if (is_open && event.is_action_pressed("escape")):
		is_open = false;
		close()

var open_scene: Node;

var letter_open_scene: PackedScene = preload("res://scenes/letter_open_scene.tscn")
var box_open_scene: PackedScene
func open():
	if type == ParcelType.BOX:
	#	pass
	#else:
		var open_letter = letter_open_scene.instantiate()
		open_letter.get_node("Letter/Content/Content").text = letter_text
		set_physics_process(false)
		get_node("../../UI").add_child(open_letter)
		get_node("../../UI").show()
		open_scene = open_letter

func close() -> void:
	set_physics_process(true)
	get_node("../../UI").hide()
	open_scene.queue_free()
