class_name DwarvenComputerNode extends Interactable

@onready var ui = %UI

func interact() -> void:
	ui.display_computer_menu()
