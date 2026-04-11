class_name UI extends Control

@onready var gold_label: RichTextLabel = %GoldLabel
@onready var modal_background = %ModalBackground
@onready var computer_menu_container = %ComputerMenuContainer

@onready var is_computer_menu_displayed: bool = false

func _process(delta) -> void:
	if is_computer_menu_displayed:
		if Input.is_action_just_pressed("ui_close"):
			hide_computer_menu()	

func update_gold(new_gold_value):
	gold_label.text = str("Money: ", new_gold_value)

func display_computer_menu():
	is_computer_menu_displayed = true
	get_tree().paused = true
	modal_background.visible = true
	computer_menu_container.animate_in()

func hide_computer_menu():
	is_computer_menu_displayed = false
	get_tree().paused = false
	modal_background.visible = false
	computer_menu_container.animate_out()
