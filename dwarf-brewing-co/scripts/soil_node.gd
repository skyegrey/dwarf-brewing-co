class_name SoilNode extends Interactable

@onready var inventory: Inventory
@onready var plant_node: PlantNode 

const PLANT_NODE = preload("uid://bp57bmaoke17m")

func interact() -> void:
	if plant_node:
		plant_node.interact()
	else:
		var active_inventory_item = inventory.get_active_item()
		if active_inventory_item is PlantableItemResource:
			_plant(inventory.consume_active_item())

func _plant(seed_item_resource: PlantableItemResource) -> void:
	plant_node = PLANT_NODE.instantiate()
	plant_node.inventory = inventory
	add_child(plant_node)
	plant_node.set_plant_resource(seed_item_resource.plant)
