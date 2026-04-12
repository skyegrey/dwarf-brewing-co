class_name Inventory extends Node

@onready var ui = %UI
@onready var player_character = %PlayerCharacter

@export var gold: int = 0

@export var inventory: Array[ItemResource]
@export var inventory_size: int = 10

@export var selected_item: int = 0


func _ready() -> void:
	ui.update_gold(gold)
	_setup_inventory()

func _process(delta: float) -> void:
	_update_hotbar_active_item()
	

func add_gold(amount: int) -> void:
	gold += amount
	ui.update_gold(gold)

func _setup_inventory():
	inventory.resize(inventory_size)

func add_item(item_resource: ItemResource):
	inventory[_get_first_available_item_slot()] = item_resource
	update_inventory_displays()

func get_active_item() -> ItemResource:
	return inventory[selected_item]

func change_selected_item(new_selected_item):
	ui.update_selected_item(selected_item, new_selected_item)
	selected_item = new_selected_item
	player_character.update_active_item()

func consume_active_item() -> void:
	inventory[selected_item] = null
	update_inventory_displays()

func update_inventory_displays():
	ui.update_inventory(inventory)
	player_character.update_active_item()

func _get_first_available_item_slot():
	for index in range(inventory.size()):
		if inventory[index] == null:
			return index

func _update_hotbar_active_item():
	if Input.is_action_just_pressed("ui_select_right_hotbar_item"):
		change_selected_item((selected_item + 1) % 10)
	elif Input.is_action_just_pressed("ui_select_left_hotbar_item"):
		change_selected_item((selected_item - 1) % 10)

func get_selected_item():
	return inventory[selected_item]
