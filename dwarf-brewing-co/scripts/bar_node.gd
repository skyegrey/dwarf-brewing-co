class_name BarNode extends Interactable

func interact(player_character: PlayerCharacter) -> void:
	if player_character.has_carried_item:
		_deliver_beer(player_character)

func _deliver_beer(player_character: PlayerCharacter):
	player_character.consume_carried_item()
	player_character.earn_gold(1)
