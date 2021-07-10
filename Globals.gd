extends Node

var finalscore = 0
var highscore = 1
var ammo = 50
var health = 100
var coins = 0
var gamerows = 20
var music_volume = 0
var effects_volume = -6
func _ready():
	load_game()
	print(highscore)
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		print("Node Data: ", node_data)
		if node_data.has("effectsvolume"):
			#music_volume = node_data["musicvolume"]
			effects_volume = node_data["effectsvolume"]
		elif node_data.has("highscore"):
			highscore = node_data["highscore"]

	save_game.close()
