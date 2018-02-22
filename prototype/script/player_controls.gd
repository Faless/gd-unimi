extends Node

var _state = {
	"time": 0,
	"up": false,
	"down": false,
	"left": false,
	"right": false,
	"fire": false,
}

var _control_id = "p1"

func _ready():
	if Network.get_peer_id() == get_network_master() and not Network.is_server():
		Network.connect("network_tick", self, "_sync_state")
	if not Network.is_online() and get_parent() != null:
		_control_id = "p%s" % get_parent().name

func _sync_state():
	rpc_unreliable_id(1, "sync_state", _state)

func _input(ev):
	if ev.is_echo() or (Network.get_peer_id() != get_network_master() and Network.is_online()):
		return
	if ev.is_action("%s_up" % _control_id):
		_state.up = ev.is_pressed()
	if ev.is_action("%s_down" % _control_id):
		_state.down = ev.is_pressed()
	if ev.is_action("%s_left" % _control_id):
		_state.left = ev.is_pressed()
	if ev.is_action("%s_right" % _control_id):
		_state.right = ev.is_pressed()
	if ev.is_action("%s_fire" % _control_id):
		_state.fire = ev.is_pressed()
	_state.time = OS.get_unix_time()

func get_state():
	return _state

slave func sync_state(state):
	if state.time < _state.time:
		return # Old message
	_state = state