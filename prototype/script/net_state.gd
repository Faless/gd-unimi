extends Node

signal network_disconnected()
signal spawn_player(player_id)
signal delete_player(player_id)
signal network_tick()

const NETWORK_TICK = 0.0166
var _players = []
var _net_timer = 0.0

func _ready():
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("connection_failed", self, "_network_failed")
	get_tree().connect("server_disconnected", self, "_network_failed")

func _physics_process(delta):
	_net_timer += delta
	if _net_timer > NETWORK_TICK:
		emit_signal("network_tick")
		_net_timer = 0.0

func start_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(6969)
	get_tree().network_peer = host

func start_client(ip):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, 6969)
	get_tree().network_peer = host

func _peer_connected(peer_id):
	_players.append(peer_id)
	emit_signal("spawn_player", peer_id)

func is_server():
	return get_tree().network_peer == null or get_tree().is_network_server()

func get_peer_id():
	return 1 if get_tree().network_peer == null else get_tree().get_network_unique_id()

slave func add_player(peer_id):
	print("add player", peer_id)

func _peer_disconnected(peer_id):
	_players.erase(peer_id)
	emit_signal("delete_player", peer_id)

func _network_failed():
	get_tree().network_peer = null
	emit_signal("network_disconnected")