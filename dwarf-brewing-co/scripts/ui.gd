class_name UI extends Control

const HOTBAR_ITEM = preload("uid://d1j54h36qkh0b")


@onready var gold_label: RichTextLabel = %GoldLabel
@onready var modal_background = %ModalBackground
@onready var computer_menu_container = %ComputerMenuContainer
@onready var open_time = %OpenTime
@onready var soil_nodes = %SoilNodes
@onready var casks = %Casks
@onready var kegs = %Kegs

@onready var hotbar_h_box = %HotbarHBox
@onready var seeds_h_box = %SeedsHBox
@onready var upgrades_h_box = %UpgradesHBox

@onready var is_computer_menu_displayed: bool = false

@onready var inventory: Inventory = %Inventory

@onready var purchasable_upgrades = [
	preload("uid://ccuvebiil4ymc"),
	preload("uid://hcn25uhn1eas"),
	preload("uid://ddr1mw2ba0rf2")
]

@onready var purchasable_seeds = [
	preload("uid://casreix1rxosj"),
	preload("uid://d3u5i4r4f7i1u"),
	preload("uid://hv3me8lhxej2"),
	preload("uid://bhhiljf8nt24i")
]
@onready var selected_tab = 0
@onready var shop_tabs = [
	[%SeedsTab, null],
	[%UpgradesTab, null]
]

# State
@onready var focused_shop_item_node: ShopItemNode

const SHOP_ITEM_NODE = preload("uid://bwb4v8peidnj7")

func _ready():
	_setup_hotbar()
	_setup_seed_shop_items()
	_setup_upgrade_shop_items()

func _process(delta) -> void:
	if is_computer_menu_displayed:
		if Input.is_action_just_pressed("ui_interact"):
			if focused_shop_item_node.purchasable_resource is PurchasableItemResource:
				_attempt_purchase(focused_shop_item_node.purchasable_resource)
			
			if focused_shop_item_node.purchasable_resource is PurchasableUpgradeResource:
				_attempt_purchase_upgrade(focused_shop_item_node.purchasable_resource)
			
		if Input.is_action_just_pressed("ui_tab_right"):
			_select_new_tab(min(selected_tab + 1, len(shop_tabs) - 1))
		
		if Input.is_action_just_pressed("ui_tab_left"):
			_select_new_tab(max(selected_tab - 1, 0))
			
		if Input.is_action_just_pressed("ui_close"):
			hide_computer_menu()

func update_gold(new_gold_value):
	gold_label.text = str("Money: ", new_gold_value)

func display_computer_menu():
	is_computer_menu_displayed = true
	get_tree().paused = true
	modal_background.visible = true
	computer_menu_container.animate_in()
	shop_tabs[selected_tab][1].set_focus_to_button()

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

func _attempt_purchase(purchasable_item_resource: PurchasableItemResource):
	var purchase_price = purchasable_item_resource.cost
	if inventory.gold >= purchase_price:
		inventory.spend_gold(purchase_price)
		inventory.add_item(purchasable_item_resource.item_resource)

func _attempt_purchase_upgrade(purchasable_upgrade_resource: PurchasableUpgradeResource):
	var upgrade_price = purchasable_upgrade_resource.cost
	if inventory.gold >= upgrade_price:
		if purchasable_upgrade_resource.name == "Soil Plot":
			if soil_nodes.can_add_soil_node():
				inventory.spend_gold(upgrade_price)
				soil_nodes.add_soil_node()
		elif purchasable_upgrade_resource.name == "Cask":
			if casks.can_add_cask_node():
				inventory.spend_gold(upgrade_price)
				casks.add_cask_node()
		elif purchasable_upgrade_resource.name == "Keg":
			if kegs.can_add_keg_node():
				inventory.spend_gold(upgrade_price)
				kegs.add_keg_node()

func update_bar_open_time(time_remaining: float):
	var minutes_remaining = '%02d' % (int(time_remaining) / 60)
	var seconds_remaining = '%02d' % (int(time_remaining) % 60)
	open_time.text = str(
		'Bar Open in: ', minutes_remaining, ':', seconds_remaining
	)

func update_bar_open_time_set_open():
	open_time.text = 'Bar Open!'

func _setup_seed_shop_items():
	for purchasable_seed: PurchasableItemResource in purchasable_seeds:
		var new_shop_item: ShopItemNode = SHOP_ITEM_NODE.instantiate()
		seeds_h_box.add_child(new_shop_item)
		new_shop_item.set_item(purchasable_seed)
		new_shop_item.on_focus.connect(_set_focused_shop_item_node)
	shop_tabs[0][1] = seeds_h_box.get_child(0)

func _setup_upgrade_shop_items():
	for purchasable_upgrade: PurchasableUpgradeResource in purchasable_upgrades:
		var new_shop_item: ShopItemNode = SHOP_ITEM_NODE.instantiate()
		upgrades_h_box.add_child(new_shop_item)
		new_shop_item.set_item(purchasable_upgrade)
		new_shop_item.on_focus.connect(_set_focused_shop_item_node)
	shop_tabs[1][1] = upgrades_h_box.get_child(0)

func _set_focused_shop_item_node(shop_item_node: ShopItemNode):
	focused_shop_item_node = shop_item_node

func _select_new_tab(new_tab_index: int):
	if selected_tab == new_tab_index:
		return
	
	else:
		shop_tabs[selected_tab][0].visible = false
		shop_tabs[new_tab_index][0].visible = true
		shop_tabs[new_tab_index][1].set_focus_to_button()
		selected_tab = new_tab_index
