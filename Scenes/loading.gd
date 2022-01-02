extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var runonce = true


# Called when the node enters the scene tree for the first time.
func _ready():
	loadgame()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if runonce:
#		print("loadgame")
#		loadgame()
#		runonce = false
#	pass
func loadgame():
	var _chscene = get_tree().change_scene("res://Scenes/main.tscn")
