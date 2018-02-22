extends RigidBody2D

export var bullet_speed = 100

var _update_time = 0.0
var _exploded = false

func _ready():
	if Network.is_server():
		Network.connect("network_tick", self, "send_pos_update")
		$Timer.start()
	else:
		collision_mask = 0
		collision_layer = 0

func send_pos_update():
	if _exploded or not Network.is_online():
		return
	rpc_unreliable("update_pos", OS.get_unix_time(), global_position)

slave func update_pos(time, pos):
	if _exploded or _update_time > time:
		return
	_update_time = time
	global_position = pos

sync func explode(pos):
	_exploded = true
	global_position = pos
	collision_layer = 0
	collision_mask = 0
	mode = MODE_STATIC
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer, "animation_finished")
	call_deferred("queue_free")

func _explode():
	if not Network.is_online():
		explode(global_position)
	elif Network.is_server():
		rpc("explode", global_position)

func _on_Timer_timeout():
	_explode()

func _on_Bullet_body_entered(body):
	_explode()