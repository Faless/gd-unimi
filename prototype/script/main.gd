extends Control

func _ready():
	$Panel/VBoxContainer/Local.grab_focus()

func _on_Local_pressed():
	$Local.show_modal(true)
	$Local.get_ok().grab_focus()

func _on_online_pressed():
	$Online.show_modal(true)
	$Online.get_ok().grab_focus()

func _on_local_start():
	print("Start")

func _on_local_cancel():
	$Panel/VBoxContainer/Local.grab_focus()

func _on_online_start():
	if $Online/Control/VBoxContainer/HBoxContainer/CheckButton.pressed:
		Network.start_server()
		get_tree().change_scene("res://scene/world.tscn")
	else:
		var ip = $Online/Control/VBoxContainer/Client/LineEdit.text
		if not ip.is_valid_ip_address():
			ip = "127.0.0.1"
		Network.start_client(ip)
		get_tree().change_scene("res://scene/world.tscn")

func _on_online_cancel():
	$Panel/VBoxContainer/Online.grab_focus()
