class_name DwarvenComputerNode extends Interactable

@onready var ui = %UI

func interact(player_character: PlayerCharacter) -> void:
	ui.display_computer_menu()
