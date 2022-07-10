extends Node

#onready var globals = $"/root/Globalnode"

onready var titlemusic = $TitleMusicPlayer
onready var gameintro = $GameIntroPlayer
onready var gamemusic = $GameMusicPlayer
onready var gameplaymusic = $GamePlayBackingPlayer
onready var endgame = $EndGamePlayer
onready var swipe = $EffectSwipePlayer
onready var menubutton = $MenuButtonPlayer
onready var magicspell = $EffectMagicSpellPlayer
onready var alarmgun = $AlarmGunPlayer
onready var alarmswipe = $AlarmSwipePlayer
onready var gunshot = $EffectGunPlayer
onready var hitsound = $EffectHitSoundPlayer
onready var rowchangetick = $EffectRowChangePlayer
onready var bombexplode = $EffectBombExplodePlayer
onready var bombticking = $EffectBombTickingPlayer
onready var spirithitbomb2 = $EffectSpiritHitBomb2Player
onready var laserbeam = $LaserBeamPlayer
onready var effectplayerarray = [swipe, magicspell, alarmgun, alarmswipe, gunshot, hitsound, rowchangetick, bombexplode, bombticking, menubutton]
onready var musicplayerarray = [titlemusic, gameintro, gamemusic, gameplaymusic, endgame]
#onready var bombtimer = get_tree().get_node("BombTimer")
#onready var next_scene = load("res://Scenes/main.tscn").instance()


var finalscore = 0
var highscore = 1
var ammo = 50
var health = 100
var coins = 01
var gamerows = 20
var music_volume = -10
var effects_volume = -20
var spiritlocation
var ammogun = false
var skillgun = false
var spiritgun = false
var raycast_length = -8
var lastcubeposition
var cubedestroyed = false
var spiritdied = false
var deltalevelspeed = 0.5
var level = 0
var highlevel = 0
var skill = 0
var levelspeed = 10
#var finallevel = 0
var noammo = "You ran out of ammo!"
var nohealth = "You ran out of health!"
var crashed = "You crashed into a"
var spiritdeath = "You passed your spirit!"
var bombexplodedcheck
var fired_weapon
var laserdata = []
var laserbeamCount = []
var showdebug = false	
var gamevolumes = [-60, -20, -10, 0]
var music_buttons = [false, false, true, false]
var effect_buttons = [false, false, true, false]
var boxes = ["MedicBox", "AmmoBox"]
var effectsadjust = [10, 10, 10, 10, 10, 10, 10, 10 ,10, 10]
var musicadjust = [0, 0, 0, 0, 0]
var bannerinst = 20
var achieveinst = 5
var next_scene
var skill_gun_fires = 0
var tutorial = false
var retrygame = false
var tutorialstep = 0
var tutorialtext = ["Swipe left or right to move white block(player) .... Try It.", "Don't pass your spirit! They don't like that!", "Shoot the colored blocks in front of you that match the color under player to clear the way and collect coins, ammo and health.",\
				 "Press this button to jump forward. Be careful. Make sure the way forward is clear!", "Press this button to move the spirit to a block in front of the player. Watch out for hidden bombs!", "Press this button to break blocks without having to match the colors",\
				 "You can PAUSE the game if you need a break!", "Monitor progress in the game. Raise your spirit to new levels.", "The player will auto jump to next row every 10 seconds at first. New levels will jump faster! The tutorial does not auto jump.", " "]

onready var game_data = {"finalscore": finalscore,
						"highscore": highscore,
						"coins": coins,
						"musicvolume": music_volume,
						"effectsvolume": effects_volume,
						"musicbuttons" : music_buttons,
						"effectbuttons" : effect_buttons,
						"highlevel" : highlevel,
						"skill" : skill,
#						"health": health
						}

func _ready():
	titlemusic.volume_db = music_volume
	gamemusic.volume_db = music_volume
	gameplaymusic.volume_db = music_volume
	gunshot.volume_db = effects_volume
	hitsound.volume_db = effects_volume
	alarmgun.volume_db = effects_volume
	alarmswipe.volume_db = effects_volume
	rowchangetick.volume_db = effects_volume
	swipe.volume_db = effects_volume
	magicspell.volume_db = effects_volume
	bombexplode.volume_db = effects_volume
	bombticking.volume_db = effects_volume
	gameintro.volume_db = music_volume
#	gameintro.play()
	load_game()
#	calc_achievements()

func load_game():
	var load_game = File.new()
	if not load_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var load_nodes = get_tree().get_nodes_in_group("persist")
	for i in load_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	load_game.open("user://savegame.save", File.READ)
	while load_game.get_position() < load_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(load_game.get_line())
#		print("Node Data: ", node_data)
		game_data = node_data
		# Firstly, we need to create the object and add it to the tree and set its position.
#		var new_object = load(node_data["filename"]).instance()
#		get_node(node_data["parent"]).add_child(new_object)
#		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
#		for i in node_data.keys():
#			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#				continue
#			new_object.set(i, node_data[i])
	load_game.close()

func save_game():
	if tutorial:
		pass
	else:
		var save_game = File.new()
		save_game.open("user://savegame.save", File.WRITE)
		var save_nodes = get_tree().get_nodes_in_group("persist")
		for node in save_nodes:
	#		print("node  ",node.name)
			# Check the node is an instanced scene so it can be instanced again during load
			#		if node.filename.empty():
			#			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			#			continue
			if node.filename.empty():
				print("persistent node '%s' is not an instanced scene, skipped" % node.name)
				continue
			# Check the node has a save function
			if !node.has_method("save"):
				print("persistent node '%s' is missing a save() function, skipped" % node.name)
				continue

			# Call the node's save function
			var node_data = node.call("save")
			# Store the save dictionary as a new line in the save file
			save_game.store_line(to_json(node_data))
			break
		save_game.close()	
	
func calc_achievements():
	var achieve = 0
	achieve = floor(game_data["highlevel"]/achieveinst)
	for n in achieve:
		print(n)
