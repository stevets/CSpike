extends KinematicBody

signal destroy(objID)
signal playermove()
var res = false

var red = ColorN("red", 1)
var dx = 1.1
var space_state
var result
var colorcube
	
func _on_Main_swiped(direction):
	var ply = get_tree().get_root().get_node("Main/player1")
	var playerpos = ply.get_global_transform().origin.x
	if direction.x >= 0:
		#print("direction = ", direction.x)
		if playerpos < 1.1:
			#print("before left: ", playerpos)
			ply.global_translate(Vector3(4.4,0,0))  #move character to the left
			#print("after left: ", ply.get_global_transform().origin.x)
		else:
			#print("before left: ", playerpos)
			ply.global_translate(Vector3(-dx,0,0))  #move character to the left
			#print("after left: ", ply.get_global_transform().origin.x)
	else:
		print("direction = ", direction.x)
		if playerpos > 4:
			#print("before right: ", playerpos)
			ply.global_translate(Vector3(-4.4, 0, 0)) #move character to the right
			#print("after right: ", ply.get_global_transform().origin.x)
		else:
			#print("before right: ", playerpos)
			ply.global_translate(Vector3(dx, 0, 0)) #move character to the right
			#print("after right: ", ply.get_global_transform().origin.x)
	#print(ply.get_global_transform().origin.x)
	#print("x = ",originx," y = ", originy," z = ", originz)
#	space_state = get_world().direct_space_state
#	#var ply = get_tree().get_root().get_node("Main/player1")
#	var originx = ply.get_global_transform().origin.x
#	var originy = ply.get_global_transform().origin.y
#	var originz = ply.get_global_transform().origin.z
#	result = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,originy,-21))	
#	print("result ", result)
#	colorcube = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,-5,originz))
#	print("colorcube ", colorcube)
#	res = true
	
func _process(delta):
	
	while res:
		print("process running")
		space_state = get_world().direct_space_state
		var ply = get_tree().get_root().get_node("Main/player1")
		var originx = ply.get_global_transform().origin.x
		var originy = ply.get_global_transform().origin.y
		var originz = ply.get_global_transform().origin.z
		result = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,originy,-21))	
		print("result ", result)
		colorcube = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,-5,originz))
		print("colorcube ", colorcube)
		
		
		

		if result and colorcube:
			var color2 = result.collider.get_parent().get_surface_material(0).albedo_color
			var colorblock =  colorcube.collider.get_parent().get_surface_material(0).albedo_color
			print("color2 ",color2)
			print("colorblock ", colorblock)
			print(result.position.z)
			if color2 == colorblock:
				print("destroy")
				print(result.collider)
				var objID = result.collider
				emit_signal("destroy", objID)
				emit_signal("playermove")
			elif abs(ply.get_global_transform().origin.z-result.position.z) > 2:
				emit_signal("playermove")
				
		
		res = false

func _on_Main_click():
	res = true
