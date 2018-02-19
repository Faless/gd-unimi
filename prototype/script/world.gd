extends Node2D

const Player = preload("res://scene/player.tscn")

func _ready():
	seed(OS.get_unix_time())
	if Network.is_server():
		Network.connect("spawn_player", self, "add_player")
		add_player(1)

func add_player(peer_id):
	for p in get_children():
		if not (p is preload("res://script/player.gd")):
			continue
		rpc_id(peer_id, "spawn_player", int(p.name), p.global_position)
	var pos = Vector2(randi() % 700 + 50, randi() % 500 + 50)
	var p = spawn_player(peer_id, pos)
	rpc("spawn_player", int(p.name), p.global_position)

slave func spawn_player(peer_id, pos):
	var p = Player.instance()
	p.name = str(peer_id)
	p.position = pos
	p.get_node("PlayerControls").set_network_master(peer_id)
	add_child(p)
	return p