extends Node

const Player = preload("res://scene/player.tscn")

func _ready():
	seed(OS.get_unix_time())
	if not Network.is_online():
		add_player(1)
		add_player(2)
		$WorldContainer.hide()
	else:
		$Views.hide()
		Network.connect("network_disconnected", self, "_back_to_main")
		if Network.is_server():
			Network.connect("spawn_player", self, "add_player")
			Network.connect("delete_player", self, "remove_player")
			add_player(1)

func add_player(peer_id):
	var pos = Vector2(randi() % 700 + 50, randi() % 500 + 50)
	if Network.is_online():
		for p in $WorldContainer/Viewport.get_children():
			if not (p is preload("res://script/player.gd")):
				continue
			rpc_id(peer_id, "spawn_player", int(p.name), p.global_position)
		var p = spawn_player(peer_id, pos)
		rpc("spawn_player", int(p.name), p.global_position)
	else:
		var p = spawn_player(peer_id, pos)
		get_node("Views/Player%s/Viewport" % p.name).world_2d = $WorldContainer/Viewport.world_2d
		p.get_node("Camera2D").custom_viewport = get_node("Views/Player%s/Viewport" % p.name)
		p.get_node("Camera2D").current = true
		p.get_node("Camera2D").make_current()

slave func spawn_player(peer_id, pos):
	var p = Player.instance()
	p.name = str(peer_id)
	p.position = pos
	p.get_node("PlayerControls").set_network_master(peer_id)
	$WorldContainer/Viewport.add_child(p)
	return p

func remove_player(peer_id):
	if not has_node(str(peer_id)):
		return
	var node = get_node(str(peer_id))
	if Network.is_online() and Network.is_server():
		node.rpc("destroy")
	else:
		node.destroy()

func _back_to_main():
	get_tree().change_scene("res://scene/main.tscn")