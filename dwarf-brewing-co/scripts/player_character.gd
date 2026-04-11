class_name PlayerCharacter extends Node2D

# Scene Refs
@onready var inventory = %Inventory

# Properties
@export var move_speed: float = 200.0
@export var character_size = 32 # pixels

# State
var interactable: Interactable
var has_carried_item: bool = false

# Children Nodes
@onready var tool_hitbox = $ToolHitbox
@onready var carried_item = $CarriedItem

func _ready() -> void:
	_setup_tool_hitbox_signals()

func _setup_tool_hitbox_signals():
	tool_hitbox.area_entered.connect(_set_interactable)
	tool_hitbox.area_exited.connect(_unset_interactable)

func _set_interactable(interactable_area: Area2D) -> void:
	interactable = interactable_area.get_parent()

# TODO Fix this to only remove if it is the same area
func _unset_interactable(interactable_area: Area2D) -> void:
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
	tool_hitbox.position = tool_direction * character_size

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
		interactable.interact(self)

func _update_carried_item():
	has_carried_item = true
	carried_item.visible = true

# Pubilc Functions
func add_to_inventory():
	_update_carried_item()

func consume_carried_item():
	has_carried_item = false
	carried_item.visible = false

func earn_gold(gold_amount: int):
	inventory.add_gold(gold_amount)
