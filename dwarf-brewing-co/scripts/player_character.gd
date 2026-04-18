class_name PlayerCharacter extends Node2D

# Scene Refs
@onready var inventory = %Inventory
@onready var tile_map_layer: TileMapLayer = %TileMapLayer

# Properties
@export var move_speed: float = 200.0
@export var character_size = 32 # pixels

# State
var interactable: Interactable
var has_carried_item: bool = false

# Children Nodes
@onready var tool_hitbox = $ToolHitbox
@onready var active_item_sprite = $ActiveItemSprite

func _ready() -> void:
	_setup_tool_hitbox_signals()
	active_item_sprite.visible = false

func _setup_tool_hitbox_signals():
	tool_hitbox.area_entered.connect(_add_interactable)
	tool_hitbox.area_exited.connect(_remove_interactable)

func _add_interactable(interactable_area: Area2D) -> void:
	interactable = interactable_area.get_parent()

# TODO Fix this to only remove if it is the same area
func _remove_interactable(interactable_area: Area2D) -> void:
	if interactable == interactable_area.get_parent():
		interactable = null

func _process(delta: float) -> void:
	var movement_vector: Vector2 = _get_movement_vector()
	_process_movement(movement_vector, delta)
	if not movement_vector.is_zero_approx():
		_update_tool_hitbox(_get_tool_direction(movement_vector))
	if Input.is_action_just_pressed("ui_interact"):
		_handle_interact()

func _get_movement_vector() -> Vector2:
	return Input.get_vector(
		"ui_left", 
		"ui_right", 
		"ui_up", 
		"ui_down"
	)

func _process_movement(movement_vector: Vector2, delta: float) -> void:
	position += movement_vector * move_speed * delta

func _update_tool_hitbox(tool_direction: Vector2i) -> void:
	var player_coordinates = tile_map_layer.local_to_map(position)
	var tool_coordinate = player_coordinates + tool_direction
	tool_hitbox.position = to_local(tile_map_layer.map_to_local(tool_coordinate))

func _get_tool_direction(movement_vector: Vector2) -> Vector2i:
	if abs(movement_vector.x) > abs(movement_vector.y):
		if movement_vector.x > 0:
			return Vector2i.RIGHT
		else:
			return Vector2i.LEFT
	else:
		if movement_vector.y > 0:
			return Vector2i.DOWN
		else:
			return Vector2i.UP

func _handle_interact():
	if interactable:
		interactable.interact()

func update_active_item():
	var active_item_resource: ItemResource = inventory.get_selected_item()
	if active_item_resource:
		active_item_sprite.visible = true
		active_item_sprite.texture = active_item_resource.atlas_texture
	else:
		active_item_sprite.visible = false
