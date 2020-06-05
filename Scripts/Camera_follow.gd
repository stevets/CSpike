extends Camera


export var distance = 10.0
export var height = 52.0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	set_physics_process(true)
#
#	set_as_toplevel(true)


#func _process(delta):
#	var target = get_tree().get_root().get_node("Main/target").get_global_transform().origin
#	var up = Vector3(0,1,0)
#	var ply = get_tree().get_root().get_node("Main/player1")
#	var pos = ply.get_global_transform().origin
#	var playerpos = pos.x
#	var offset = pos - target
#	if playerpos == 0:
#		pos.x = 2.1
#	elif playerpos == 1.1:
#		pos.x = 2.2
#	elif playerpos == 2.2:
#		pos.x = 2.2
#	elif playerpos == 3.3:
#		pos.x = 2.2
#	else:
#		pos.x = 2.3
#	pos.y = 4
#	pos.z = pos.z + 3
#	#offset = offset.normalized()*distance
#	#offset.y = height
#
#	#pos = target + offset

#	look_at_from_position(pos, target, up)
	
