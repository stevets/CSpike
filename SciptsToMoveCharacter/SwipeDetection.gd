extends Node

signal swiped(direction)
#signal swipe_canceled(start_position)
signal click()

var eventtype = [InputEventMouseButton, InputEventScreenTouch]


onready var timer = $Timer
var swipe_start_position = Vector2()
	
func _input(event):
	if not event is eventtype[0]:
		return
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)
#InputEventScreenTouch: (use this for the phone controls)

func _start_detection(position):
	swipe_start_position = position
	timer.start()
	
func _end_detection(position):
	timer.stop()
	var direction = (position - swipe_start_position)
	var swipedetection = 60
	if direction.x >= swipedetection or direction.x <= -swipedetection:
		emit_signal('swiped', Vector2(-sign(direction.x), 0.0))
	else:
		emit_signal('click')
	#print(direction) - for testing directional change in this function

func _on_Timer_timeout():
	emit_signal('swipe_canceled', swipe_start_position)
