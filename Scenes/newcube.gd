extends Spatial

var spirit = false 
onready var globals = $"/root/Globalnode"



func _on_Player_destroy(objID):
#	print(objID.get_parent().name)
	if objID.get_parent().name.find("basecube") == 0:
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
			if globals.game_data["finalscore"] > globals.game_data["highscore"]:
				globals.game_data["highscore"] = globals.game_data["finalscore"]
			var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
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


