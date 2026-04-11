class_name Inventory extends Node

@onready var ui = %UI

@export var gold: int = 0

func _ready() -> void:
	ui.update_gold(gold)

func add_gold(amount: int) -> void:
	gold += amount
	ui.update_gold(gold)
