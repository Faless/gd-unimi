extends StaticBody2D

export var HP = 4
var crate_esplosion = preload("res://scene/crate_explosion_effect.tscn")

func _ready():
	pass

sync func hit():
	HP-=1
	if(HP == 0):
		_destroy()
	else:
		_hit_effect()

func _hit_effect():
	$Sprite.modulate = Color(1,0,0,1)
	yield( get_tree().create_timer(0.2),"timeout" )
	$Sprite.modulate = Color(1,1,1,1)

func _destroy():
	var explosion = crate_esplosion.instance()
	get_parent().add_child(explosion)
	explosion.position = position
	explosion.emitting = true
	queue_free()
#func _process(delta):

#	pass
