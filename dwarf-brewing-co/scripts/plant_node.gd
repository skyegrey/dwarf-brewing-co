class_name PlantNode extends Interactable

@onready var inventory: Inventory
@onready var crop: ItemResource = preload("uid://b8nfnqn6lk755")
@onready var growth_time: float = 5 # seconds

@onready var growth_progress_bar: ProgressBar = $GrowthProgressBar
@onready var is_grown: bool = false

const HOPS_PLANT = preload("uid://bn61sdf1bcb8y")

@onready var sprite = $Sprite

func _ready():
	sprite.texture = HOPS_PLANT.growth_sprite

func _process(delta) -> void:
	if not is_grown:
		_update_growth_progress_bar(delta)

func interact() -> void:
	if is_grown:
		inventory.add_item(crop)
		queue_free()

func _update_growth_progress_bar(delta: float):
	growth_progress_bar.value += delta / growth_time * 100
	if growth_progress_bar.value >= 100:
		_finish_growing()

func _finish_growing():
	sprite.texture = HOPS_PLANT.grown_sprite
	is_grown = true
	growth_progress_bar.visible = false

func skip_growth_phase():
	_finish_growing()
