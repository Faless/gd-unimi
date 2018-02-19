extends KinematicBody2D

const Bullet = preload("res://scene/bullet.tscn")

const SPEED = 64
const FIRE_SPEED = .2

var _update_time = 0.0
var _fire_timer = 0.0

func _physics_process(delta):
	if not Network.is_server():
		return
	var state = $PlayerControls.get_state()
	var walking = false
	var dir = Vector2()
	if state.up and not state.down:
		walking = true
		dir.y = -1
	if state.down and not state.up:
		walking = true
		dir.y = 1
	if state.left and not state.right:
		walking = true
		dir.x = -1
	if state.right and not state.left:
		walking = true
		dir.x = 1
	rpc_unreliable("walk_update", OS.get_unix_time(), position, walking, dir * (delta * SPEED))
	if _fire_timer > 0:
		_fire_timer -= delta
	elif state.fire:
		_fire_timer = FIRE_SPEED
		rpc("fire", name + "_" + str(randi()))

sync func walk_update(time, pos, walking, movement):
	if _update_time > time:
		return
	_update_time = time
	position = pos
	if walking:
		rotation = -(PI/2.0-movement.angle())
		move_and_collide(movement)
		if not $Leg/AnimationPlayer.is_playing():
			$Leg/AnimationPlayer.play("walk")
	elif $Leg/AnimationPlayer.is_playing():
		$Leg/AnimationPlayer.stop(true)

sync func fire(bullet_name):
	var bullet = Bullet.instance()
	if not Network.is_server():
		bullet.mode = RigidBody2D.MODE_STATIC
	bullet.name = bullet_name
	bullet.linear_velocity = Vector2(bullet.bullet_speed, 0).rotated(PI/2.0+rotation)
	bullet.position = $Weapon.global_position + ($Weapon.offset + Vector2(0,32)).rotated(rotation)
	bullet.add_collision_exception_with(self)
	if(get_parent() != null):
		get_parent().add_child(bullet)