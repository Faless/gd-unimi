extends StaticBody2D

export var HP = 4
var crate_esplosion = preload("res://scene/crate_explosion_effect.tscn")

func _ready():
	pass

func hit():
	if not Network.is_server():
		return
	HP -= 1
	if HP == 0:
		if Network.is_online():
			rpc("destroy")
		else:
			destroy()
	else:
		if Network.is_online():
			rpc("hit_effect")
		else:
			hit_effect()

sync func hit_effect():
	$Sprite.modulate = Color(1,0,0,1)
	$HitTimer.start()
	yield($HitTimer, "timeout")
	$Sprite.modulate = Color(1,1,1,1)

sync func destroy():
	var explosion = crate_esplosion.instance()
	get_parent().add_child(explosion)
	explosion.position = position
	explosion.emitting = true
	queue_free()