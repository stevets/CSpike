extends MeshInstance




func _on_Player_destroy(objID):
		if objID.get_parent().name.find("gem") == 1:
			objID.get_parent().queue_free()
