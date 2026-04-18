extends Node2D

@onready var inventory = %Inventory

const CASK_NODE = preload("uid://2ocuf1212p3h")

@export var max_width = 4
@export var max_casks = 7
@export var building_spacing = 32
@export var vertical_spacing = 64

func _ready():
	add_cask_node()

func can_add_cask_node():
	return self.get_child_count() < max_casks

func add_cask_node():
	var node_position = Vector2(
		self.get_child_count() % max_width * -building_spacing,
		self.get_child_count() / max_width * vertical_spacing
	)
	var new_cask_node: CaskNode = CASK_NODE.instantiate()
	new_cask_node.inventory = inventory
	new_cask_node.position = node_position
	add_child(new_cask_node)
