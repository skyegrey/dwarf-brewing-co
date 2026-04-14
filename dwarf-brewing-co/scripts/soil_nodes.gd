class_name SoilNodes extends Node2D

@onready var inventory = %Inventory

const SOIL_NODE = preload("uid://dtlkjcavbqns5")

const max_width = 5
const max_height = 7
const soil_spacing: float = 37

func _ready():
	add_soil_node()
	add_soil_node()
	add_soil_node()

func add_soil_node():
	var node_position = Vector2(
		self.get_child_count() % max_width * soil_spacing,
		self.get_child_count() / max_height * -soil_spacing
	)
	var new_soil_node: SoilNode = SOIL_NODE.instantiate()
	new_soil_node.inventory = inventory
	new_soil_node.position = node_position
	add_child(new_soil_node)
