extends Node2D

@onready var inventory = %Inventory

const KEG_NODE = preload("uid://dyihrell4s07f")

@export var max_width = 8
@export var max_kegs = 40
@export var building_spacing = 32
@export var vertical_spacing = 64

func _ready():
	add_keg_node()

func can_add_keg_node():
	return self.get_child_count() < max_kegs

func add_keg_node():
	var node_position = Vector2(
		self.get_child_count() % max_width * -building_spacing,
		self.get_child_count() / max_width * vertical_spacing
	)
	var new_keg_node: KegNode = KEG_NODE.instantiate()
	new_keg_node.inventory = inventory
	new_keg_node.position = node_position
	add_child(new_keg_node)
