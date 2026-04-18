class_name CaskNode extends Interactable

@onready var inventory: Inventory

@onready var count_label = $CountLabel

@onready var stored_drink: BrewedItemResource
@onready var amount_stored: int = 0

func interact() -> void:
	var active_item: ItemResource = inventory.get_active_item()
	if active_item is BrewedItemResource:
		if not stored_drink:
			stored_drink = inventory.consume_active_item()
			amount_stored = 1
			update_count_label()
		elif stored_drink.name == active_item.name:
			inventory.consume_active_item()
			amount_stored += 1
			update_count_label()
	elif not active_item:
		if stored_drink:
			inventory.add_item(stored_drink)
			amount_stored -= 1
			update_count_label()
			if amount_stored == 0:
				stored_drink = null

func update_count_label():
	if amount_stored == 0:
		count_label.visible = false
	else:
		count_label.visible = true
		count_label.text = str(amount_stored)
