extends KinematicBody2D

const SPEED = 64

var _state = {
	"up": false,
	"down": false,
	"left": false,
	"right": false,
}

func _process(delta):
	var walking = false
	var dir = Vector2()
	if _state.up and not _state.down:
		walking = true
		dir.y = -1
	if _state.down and not _state.up:
		walking = true
		dir.y = 1
	if _state.left and not _state.right:
		walking = true
		dir.x = -1
	if _state.right and not _state.left:
		walking = true
		dir.x = 1
	walk_update(walking, dir * (delta * SPEED))

func walk_update(walking, movement):
	if walking:
		rotation = -(PI/2.0-movement.angle())
		move_and_collide(movement)
		if not $Leg/AnimationPlayer.is_playing():
			$Leg/AnimationPlayer.play("walk")
	elif $Leg/AnimationPlayer.is_playing():
		$Leg/AnimationPlayer.stop(true)

func _input(ev):
	if ev.is_echo():
		return
	if ev.is_action("p1_up"):
		_state.up = ev.is_pressed()
	if ev.is_action("p1_down"):
		_state.down = ev.is_pressed()
	if ev.is_action("p1_left"):
		_state.left = ev.is_pressed()
	if ev.is_action("p1_right"):
		_state.right = ev.is_pressed()
