class_name PatronNode extends Node2D

# Children Refs
@onready var requested_item_sprite = $RequestSprite/RequestedItemSprite

# State
@onready var requested_item: BrewedItemResource = preload("uid://b4cvaygbu37t6")

func _ready():
	requested_item_sprite.texture = requested_item.atlas_texture
