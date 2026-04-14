class_name BarNode extends Interactable

# Scenes Refs
@onready var inventory = %Inventory
@onready var ui = %UI

# Children Refs
@onready var new_quest_timer = $NewQuestTimer
@onready var patrons = $Patrons
@onready var bar_open_timer = $BarOpenTimer

# Properties
@onready var requestable_drinks = [
	preload("uid://cutqkvsijjsfa")
]
@export var max_patrons = 5

# State Vars
@onready var available_positions = []
@onready var is_bar_open: bool = false

const PATRON_NODE = preload("uid://gh08mjkhus02")

func _ready():
	bar_open_timer.timeout.connect(_open_bar)
	new_quest_timer.timeout.connect(_create_quest)
	_create_available_bar_positions()

func _create_available_bar_positions():
	for patron_index in range(max_patrons):
		available_positions.append(Vector2(0, 32 * patron_index))

func _process(delta):
	if not is_bar_open:
		ui.update_bar_open_time(bar_open_timer.time_left)

func _open_bar():
	is_bar_open = true
	ui.update_bar_open_time_set_open()
	new_quest_timer.start()

func _create_quest():
	if patrons.get_child_count() >= max_patrons:
		return
	var requested_drink: BrewedItemResource = _roll_requested_drink()
	_create_patron(requested_drink)

func _roll_requested_drink():
	return requestable_drinks.pick_random()

func _create_patron(requested_drink: BrewedItemResource):
	var new_patron: PatronNode = PATRON_NODE.instantiate()
	new_patron.position = available_positions.pop_front()
	patrons.add_child(new_patron)

func interact() -> void:
	var active_item: ItemResource = inventory.get_active_item()
	if active_item is BrewedItemResource:
		for patron: PatronNode in patrons.get_children():
			if patron.requested_item == active_item:
				inventory.consume_active_item()
				inventory.add_gold(2)
				available_positions.append(patron.position)
				available_positions.sort_custom(
					func(position1, position2): return position1.y < position2.y
				)
				patron.queue_free()
				return
