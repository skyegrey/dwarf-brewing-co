class_name UI extends Control

const HOTBAR_ITEM = preload("uid://d1j54h36qkh0b")

@onready var gold_label: RichTextLabel = %GoldLabel
@onready var modal_background = %ModalBackground
@onready var computer_menu_container = %ComputerMenuContainer

@onready var hotbar_h_box = %HotbarHBox

@onready var is_computer_menu_displayed: bool = false

@onready var inventory: Inventory = %Inventory

const HOPS_SEEDS = preload("uid://1uydqbfi33bw")

func _ready():
	_setup_hotbar()

func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_interact"):
		if is_computer_menu_displayed:
			_purchase_seeds()
	
	if Input.is_action_just_pressed("ui_close"):
		if is_computer_menu_displayed:
			hide_computer_menu()

func update_gold(new_gold_value):
	gold_label.text = str("Money: ", new_gold_value)

func display_computer_menu():
	is_computer_menu_displayed = true
	get_tree().paused = true
	modal_background.visible = true
	computer_menu_container.animate_in()

func hide_computer_menu():
	is_computer_menu_displayed = false
	get_tree().paused = false
	modal_background.visible = false
	computer_menu_container.animate_out()

func _setup_hotbar():
	var hotbar_size = 10
	for hotbar_index in hotbar_size:
		var new_hotbar_item = HOTBAR_ITEM.instantiate()
		hotbar_h_box.add_child(new_hotbar_item)
	hotbar_h_box.get_child(0).set_active()

func update_inventory(inventory: Array[ItemResource]):
	_update_hotbar(inventory.slice(0, 10))

func _update_hotbar(hotbar_inventory: Array[ItemResource]):
	for item_index in hotbar_inventory.size():
		var item_resource = hotbar_inventory[item_index]
		var hotbar_item_node: HotbarItemNode = hotbar_h_box.get_child(item_index)
		hotbar_item_node.set_item(item_resource)

func update_selected_item(
		old_selected_item_index: int, 
		new_selected_item_index: int
	) -> void:
		hotbar_h_box.get_child(old_selected_item_index).set_inactive()
		hotbar_h_box.get_child(new_selected_item_index).set_active()

func _purchase_seeds():
	var purchase_price = 1
	if inventory.gold >= purchase_price:
		inventory.spend_gold(purchase_price)
		inventory.add_item(HOPS_SEEDS)
