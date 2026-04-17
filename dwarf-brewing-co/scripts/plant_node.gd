class_name PlantNode extends Interactable

@onready var inventory: Inventory
@onready var growth_time: float = 5 # seconds

@onready var growth_progress_bar: ProgressBar = $GrowthProgressBar
@onready var is_grown: bool = false

@onready var sprite = $Sprite

@onready var plant_resource: PlantResource

func _process(delta) -> void:
	if not is_grown:
		_update_growth_progress_bar(delta)

func interact() -> void:
	if is_grown:
		inventory.add_item(plant_resource.finished_product)
		queue_free()

func _update_growth_progress_bar(delta: float):
	growth_progress_bar.value += delta / growth_time * 100
	if growth_progress_bar.value >= 100:
		_finish_growing()

func _finish_growing():
	sprite.texture = plant_resource.grown_sprite
	is_grown = true
	growth_progress_bar.visible = false

func skip_growth_phase():
	_finish_growing()

func set_plant_resource(_plant_resource: PlantResource):
	plant_resource = _plant_resource
	sprite.texture = plant_resource.growth_sprite
