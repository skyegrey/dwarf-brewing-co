class_name PlantNode extends Interactable

@onready var inventory = %Inventory

@onready var crop: ItemResource = preload("uid://b8nfnqn6lk755")

func interact() -> void:
	inventory.add_item(crop)
