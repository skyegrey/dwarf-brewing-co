class_name RecipeResource extends Resource

@export var finished_product: BrewedItemResource
@export var ingredients: Dictionary[BrewableItemResource, int]
