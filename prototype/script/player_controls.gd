extends Node

var _state = {
	"time": 0,
	"up": false,
	"down": false,
	"left": false,
	"right": false,
	"fire": false,
}

func _ready():
	if Network.get_peer_id() == get_network_master() and not Network.is_server():
		Network.connect("network_tick", self, "_sync_state")

func _sync_state():
	rpc_unreliable_id(1, "sync_state", _state)

func _input(ev):
	if ev.is_echo() or Network.get_peer_id() != get_network_master():
		return
	if ev.is_action("p1_up"):
		_state.up = ev.is_pressed()
	if ev.is_action("p1_down"):
		_state.down = ev.is_pressed()
	if ev.is_action("p1_left"):
		_state.left = ev.is_pressed()
	if ev.is_action("p1_right"):
		_state.right = ev.is_pressed()
	if ev.is_action("p1_fire"):
		_state.fire = ev.is_pressed()
	_state.time = OS.get_unix_time()

func get_state():
	return _state

slave func sync_state(state):
	if state.time < _state.time:
		return # Old message
	_state = state