extends MeshInstance


func _on_Player_destroy(objID):
	print("received signal", objID)
	print(self)
	if objID.get_parent() == self:
		print("objID matched")
		self.queue_free()
