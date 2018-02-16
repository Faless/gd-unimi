extends Control

func _ready():
	$Panel/VBoxContainer/Local.grab_focus()

func _on_Local_pressed():
	$Local.show_modal(true)
	$Local.get_ok().grab_focus()


func _on_local_start():
	print("Start")

func _on_local_cancel():
	$Panel/VBoxContainer/Local.grab_focus()
