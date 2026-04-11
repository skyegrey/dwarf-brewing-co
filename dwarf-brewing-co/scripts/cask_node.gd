class_name CaskNode extends Interactable

# Properties
@export var base_brewing_time: float = 3.0 # seconds

# State
@export var is_brewing: bool = false
@export var has_finished_item: bool = false

# Children Nodes
@onready var brew_progress_bar: ProgressBar = $BrewProgressBar
@onready var finished_item_sprite: Sprite2D = $FinishedItemSprite

func _process(delta) -> void:
	if is_brewing:
		_update_brewing_progress_bar(delta)

func interact(player_character: PlayerCharacter) -> void:
	if has_finished_item:
		_pickup_finished_item(player_character)
		
	elif not is_brewing:
		if player_character.has_carried_item:
			player_character.consume_carried_item()
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
	brew_progress_bar.value = 0
	brew_progress_bar.visible = false
	finished_item_sprite.visible = true
	has_finished_item = true

func _pickup_finished_item(player_character: PlayerCharacter) -> void:
	player_character.add_to_inventory()
	finished_item_sprite.visible = false
	has_finished_item = false
