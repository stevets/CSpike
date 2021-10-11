extends Spatial

var spirit = false 
var coin = 10
onready var globals = $"/root/Globalnode"
onready var main = get_tree().get_root().get_node("Main")



func _on_Player_destroy(objID):
	if objID.get_parent().name.find("basecube") == 0:
		if objID.get_parent().translation.y == 0:
			if globals.skillgun:
				if objID.get_parent().get_child(1).has_node("bomb"):
					objID.get_parent().global_translate(Vector3(0, -1 ,0))
					print("bomb destruction: ", objID.get_parent().get_child(1).get_child(0).name)
					objID.get_parent().get_child(1).get_child(0).queue_free()
#					globals.game_data["coins"] += 5
#					globals.skillgun = false
				else:
					objID.get_parent().global_translate(Vector3(0, -1 ,0))
#					globals.game_data["coins"] += 5
#					globals.skillgun = false
				if !globals.laserdata.empty():
					var i = 0
					for laserbeam in globals.laserdata:
						i+=1
						print("objID: ",objID.get_parent().get_parent(),"left: ", laserbeam["left"],"right: ", laserbeam["right"])	
						if objID.get_parent().get_parent() == laserbeam["right"] or objID.get_parent().get_parent() == laserbeam["left"]:
							print("destroy laser")
							globals.laserdata.remove(i-1)
							laserbeam["laser"].queue_free()
#							globals.laserdata = null
			elif !globals.skillgun:
				objID.get_parent().global_translate(Vector3(0, -0.5 ,0))
				globals.game_data["coins"] += 10
				objID.get_parent().get_child(3).emitting = true
		elif  objID.get_parent().translation.y == -0.5: 
			if globals.skillgun:
				if objID.get_parent().get_child(1).has_node("bomb"):
					if objID.get_parent().get_child(1).get_child(0).name == "bomb":
						if globals.bombexplodedcheck == objID:
							globals.bombticking.stop()
						objID.get_parent().global_translate(Vector3(0, -0.5 ,0))
						print("bomb destruction: ", objID.get_parent().get_child(1).get_child(0).name)
						objID.get_parent().get_child(1).get_child(0).queue_free()
#						globals.game_data["coins"] += 5
				else:
					objID.get_parent().global_translate(Vector3(0, -0.5 ,0))
#					globals.game_data["coins"] += 5
#					objID.get_parent().get_child(3).emitting = true
				if !globals.laserdata.empty():
					var i = 0
					for laserbeam in globals.laserdata:
						i+=1
						print("objID: ",objID.get_parent().get_parent(),"left: ", laserbeam["left"],"right: ", laserbeam["right"])	
						if objID.get_parent().get_parent() == laserbeam["right"] or objID.get_parent().get_parent() == laserbeam["left"]:
							print("destroy laser")
							globals.laserdata.remove(i-1)
							laserbeam["laser"].queue_free()
			elif !globals.skillgun:
				objID.get_parent().global_translate(Vector3(0, -0.5 ,0))
				globals.game_data["coins"] += 10
				objID.get_parent().get_child(3).emitting = true
				if !globals.laserdata.empty():
					var i = 0
					for laserbeam in globals.laserdata:
						i+=1
						print("objID: ",objID.get_parent().get_parent(),"left: ", laserbeam["left"],"right: ", laserbeam["right"])	
						if objID.get_parent().get_parent() == laserbeam["right"] or objID.get_parent().get_parent() == laserbeam["left"]:
							print("destroy laser")
							globals.laserdata.remove(i-1)
							laserbeam["laser"].queue_free()
#						globals.laserdata = null
						
		objID.get_parent().get_child(3).emitting = false
		
#		objID.get_parent().get_child(3).emitting = true
	if objID.get_parent().name == "token":
		objID.get_parent().queue_free()

func _on_Main_selfdestruct(plyposz):
#	var objname = get_tree().get_root().get_node("/root/main/")
#	print("entered selfdestruct: ")
	var mygroup = get_tree().get_nodes_in_group("cubes")

	var cubeposz
	for member in mygroup:
		cubeposz = member.translation.z
#		print("cubeposz: ", cubeposz)
		if cubeposz > plyposz and member.spirit:
			globals.spiritdied = true
		elif cubeposz > plyposz+1:
			if member.translation.x != 10:
				member.remove_from_group("cubes")
				member.queue_free()
				globals.cubedestroyed = true

