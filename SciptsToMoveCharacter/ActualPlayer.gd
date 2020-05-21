extends KinematicBody

var dx = 0

func _on_SwipeDetection_swiped(direction):
	if direction.x >= 0:
		
		dx = dx - .73
		global_transform.origin = Vector3(dx-1.1, 2, 0) #move character to the left
	else:
		dx = dx + .73
		global_transform.origin = Vector3(dx-1.1, 2, 0) #move character to the right
		

func _on_SwipeDetection_swipe_canceled(direction):
		if direction.x >= 0:
			
			dx = dx - .73
			global_transform.origin = Vector3(dx-1.1, 2, 0) #move character to the left
		else:
			dx = dx + .73
			global_transform.origin = Vector3(dx-1.1, 2, 0) #move character to the right
		
