class_name PlantNode extends Interactable

func interact(player_character: PlayerCharacter) -> void:
	#var crop = harvest()
	player_character.add_to_inventory()
