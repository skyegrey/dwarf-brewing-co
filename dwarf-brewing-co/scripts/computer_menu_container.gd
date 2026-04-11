class_name ComputerMenuContainer extends MarginContainer


func animate_in():
	var animate_in_tween: Tween = get_tree().create_tween()
	animate_in_tween.tween_property(
		self,
		"position:y",
		0,
		.25
	)
	animate_in_tween.set_pause_mode(
		Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS
	)

func animate_out():
	var animate_out_tween: Tween = get_tree().create_tween()
	animate_out_tween.tween_property(
		self,
		"position:y",
		800,
		.25
	)
