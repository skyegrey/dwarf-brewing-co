class_name KegNode extends Interactable

const BEER = preload("uid://cutqkvsijjsfa")

@onready var inventory = %Inventory

# Properties
@export var base_brewing_time: float = 3.0 # seconds

# State
@export var is_brewing: bool = false
@export var has_finished_item: bool = false
var finished_product: ItemResource

# Children Nodes
@onready var brew_progress_bar: ProgressBar = $BrewProgressBar
@onready var finished_item_sprite: Sprite2D = $FinishedItemSprite

func _process(delta) -> void:
	if is_brewing:
		_update_brewing_progress_bar(delta)

func interact() -> void:
	if finished_product:
		_pickup_finished_item()
		
	elif not is_brewing:
		if inventory.get_active_item() is BrewableItemResource:
			inventory.consume_active_item()
			_brew()

func _brew() -> void:
	is_brewing = true
	brew_progress_bar.visible = true

func _update_brewing_progress_bar(delta: float) -> void:
	brew_progress_bar.value += delta / base_brewing_time * 100
	if brew_progress_bar.value >= brew_progress_bar.max_value:
		_finish_brewing()

func _finish_brewing():
	is_brewing = false
	finished_product = BEER
	brew_progress_bar.value = 0
	brew_progress_bar.visible = false
	_update_finish_item_sprite()

func _pickup_finished_item() -> void:
	inventory.add_item(finished_product)
	finished_product = null
	_update_finish_item_sprite()

func _update_finish_item_sprite():
	if finished_product:
		finished_item_sprite.texture = finished_product.atlas_texture
	else:
		finished_item_sprite.texture = null
