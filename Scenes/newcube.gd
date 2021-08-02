extends Spatial

var spirit = false 
var coin = 10
onready var globals = $"/root/Globalnode"



func _on_Player_destroy(objID):
	if objID.get_parent().name.find("basecube") == 0:
		if objID.get_parent().translation.y == 0:
			objID.get_parent().global_translate(Vector3(0, -0.5 ,0))
		elif  objID.get_parent().translation.y == -0.5: 
#			print("bomb detection: ", objID.get_parent().get_child(1).name)
			if objID.get_parent().get_child(1).has_node("bomb"):
				if objID.get_parent().get_child(1).get_child(0).name == "bomb":
					objID.get_parent().global_translate(Vector3(0, -0.5 ,0))
					print("bomb destruction: ", objID.get_parent().get_child(1).get_child(0).name)
					objID.get_parent().get_child(1).get_child(0).queue_free()
			else:
				objID.get_parent().global_translate(Vector3(0, -0.5 ,0))
	if objID.get_parent().name == "token":
		objID.get_parent().queue_free()
		



func _on_Main_selfdestruct(plyposz):
#	var objname = get_tree().get_root().get_node("/root/main/")
#	print("entered selfdestruct: ")
	var mygroup = get_tree().get_nodes_in_group("cubes")

	var cubeposz
	for member in mygroup:
		cubeposz = member.translation.z
		if cubeposz > plyposz and member.spirit:
			globals.spiritdied = true
		elif cubeposz > plyposz+1:
			if member.translation.x != 10:
				member.remove_from_group("cubes")
				member.queue_free()
				globals.cubedestroyed = true
#	var instpath =  "/root/Main/@newcube@"
#	print("player pos: ", plyposz)
#	for i in 145:
#		if is_instance_valid(get_tree().get_root().get_node(instpath + str(i))):
#			ObjId = get_tree().get_root().get_node(instpath + str(i))
#			instanceobj.append(ObjId)
#	var thiscube = self
##	print("thiscube: ", instanceobj)
#	queue_free()
	
#	var nnodeposz = self.translation.z
#	print(nnodeposz, " ",plyposz, " self name: ", self.name)
#	if nnodeposz >plyposz:
#		self.queue_free()


