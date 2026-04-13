class_name BarNode extends Interactable

@onready var inventory = %Inventory

@onready var quests = {
	
}

func interact() -> void:
	if inventory.get_active_item() is BrewedItemResource:
		inventory.consume_active_item()
		inventory.add_gold(2)
