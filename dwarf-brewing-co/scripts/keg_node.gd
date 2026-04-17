class_name KegNode extends Interactable

@onready var inventory = %Inventory

# Properties
@export var base_brewing_time: float = 3.0 # seconds
@onready var recipes: Array[RecipeResource] = [
	preload("uid://nyouuylxa0p3"),
	preload("uid://o6eats7wa1k3"),
	preload("uid://dcmgjwr37ld6t"),
	preload("uid://cuscqn3gwj0ur"),
	preload("uid://dwxo3pa1vgg37"),
	preload("uid://c2e8quasj0mtd"),
	preload("uid://dsdbg7uv7klv6")
]


# State
@export var is_brewing: bool = false
@export var has_finished_brewing: bool = false
@export var finished_product = BrewedItemResource
@onready var brewing_items: Dictionary[BrewableItemResource, int]


# Children Nodes
@onready var brew_progress_bar: ProgressBar = $BrewProgressBar
@onready var finished_item_sprite: Sprite2D = $FinishedItemSprite



func _process(delta) -> void:
	if is_brewing:
		_update_brewing_progress_bar(delta)

func interact() -> void:
	if has_finished_brewing:
		_pickup_finished_item()
	
	elif is_brewing:
		var combined_recipe = find_combined_recipe(inventory.get_active_item())
		if combined_recipe:
			_add_ingredient(inventory.consume_active_item())
			finished_product = combined_recipe.finished_product

	else:
		if inventory.get_active_item() is BrewableItemResource:
			_brew(inventory.consume_active_item())
	


func _brew(brewable_item_resource: BrewableItemResource) -> void:
	brewing_items[brewable_item_resource] = 0
	for recipe in recipes:
		if recipe.ingredients == brewing_items:
			finished_product = recipe.finished_product
	is_brewing = true
	brew_progress_bar.visible = true

func find_combined_recipe(new_ingredient: BrewableItemResource) -> RecipeResource:
	var combined_ingredients: Dictionary[BrewableItemResource, int] = brewing_items.duplicate()
	combined_ingredients[new_ingredient] = 0
	for recipe: RecipeResource in recipes:
		if combined_ingredients == recipe.ingredients:
			return recipe
	return null

func _add_ingredient(brewable_item_resource: BrewableItemResource) -> void:
	brewing_items[brewable_item_resource] = 0
	

func _update_brewing_progress_bar(delta: float) -> void:
	brew_progress_bar.value += delta / base_brewing_time * 100
	if brew_progress_bar.value >= brew_progress_bar.max_value:
		_finish_brewing()

func _finish_brewing():
	is_brewing = false
	has_finished_brewing = true
	brew_progress_bar.value = 0
	brew_progress_bar.visible = false
	_update_finish_item_sprite()

func _pickup_finished_item() -> void:
	inventory.add_item(finished_product)
	brewing_items = {}
	finished_product = null
	has_finished_brewing = false
	_update_finish_item_sprite()

func _update_finish_item_sprite():
	if finished_product:
		finished_item_sprite.texture = finished_product.atlas_texture
	else:
		finished_item_sprite.texture = null
