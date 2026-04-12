class_name HotbarItemNode extends NinePatchRect

@onready var item_sprite = %ItemSprite
@onready var item_highlight = $ItemHighlight

func set_item(item_resource: ItemResource):
	if item_resource:
		item_sprite.texture = item_resource.atlas_texture
	else:
		item_sprite.texture = null

func set_active():
	item_highlight.visible = true

func set_inactive():
	item_highlight.visible = false
