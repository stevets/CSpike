extends Spatial



func _on_Player_destroy(objID):
	print(objID.get_parent().name)
	if objID.get_parent().name.find("basecube") == 0:
		objID.get_parent().global_translate(Vector3(0, -0.5 ,0))
	if objID.get_parent().name == "token":
		objID.get_parent().queue_free()
		

