class_name ShopItemNode extends MarginContainer

@onready var purchasable_resource: PurchasableResource
@onready var sprite = %Sprite
@onready var name_label = %NameLabel
@onready var price_label = %PriceLabel
@onready var purchase_button = %PurchaseButton

signal on_focus

func _ready():
	purchase_button.focus_entered.connect(_on_focus_entered)

func set_item(_purchasable_resource: PurchasableResource):
	purchasable_resource = _purchasable_resource
	sprite.texture = purchasable_resource.texture
	name_label.text = purchasable_resource.name
	price_label.text = str(purchasable_resource.cost, ' gold')

func set_focus_to_button():
	purchase_button.grab_focus()

func _on_focus_entered():
	on_focus.emit(self)
