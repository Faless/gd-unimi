extends ConfirmationDialog

func _on_CheckButton_toggled( button_pressed ):
	if button_pressed:
		get_node("Control/VBoxContainer/Client").hide()
	else:
		get_node("Control/VBoxContainer/Client").show()
