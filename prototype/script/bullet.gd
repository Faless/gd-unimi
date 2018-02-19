extends RigidBody2D

export var bullet_speed = 100

var _update_time = 0.0

func _ready():
	if Network.is_server():
		Network.connect("network_tick", self, "send_pos_update")
	pass

func send_pos_update():
	rpc_unreliable("update_pos", OS.get_unix_time(), global_position)

slave func update_pos(time, pos):
	if _update_time > time:
		return
	_update_time = time
	global_position = pos

func _on_Timer_timeout():
	call_deferred("queue_free")