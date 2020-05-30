extends MeshInstance




func _on_Player_destroy(objID):
	objID.get_parent().queue_free()

