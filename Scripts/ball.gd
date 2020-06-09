extends MeshInstance


#
func _on_Player_destroy(objID):
	print(objID.get_parent().name.find("ball"))
	print(objID.get_parent().get_children())
	if objID.get_parent().name.find("ball") == 1:
		 objID.get_parent().queue_free()
