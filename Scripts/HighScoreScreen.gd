extends Control

onready var globals = $"/root/Globalnode"
onready var score = get_node("VBoxContainer/score")
onready var highscore = get_node("VBoxContainer/newhighscore")
onready var outputfeedback = get_node("VBoxContainer/outputfeedback")

func _ready():
	highscore.text = str(globals.game_data["highscore"])
	score.text = str(globals.game_data["finalscore"])
	outputfeedback.text = str(globals.output)
#	globals.game_data["finalscore"] = 0         
	
func _on_SettingBack_pressed():
#	globals.save_game()
	var _changescene = get_tree().change_scene("res://Scenes/MainScreen.tscn")
	globals.gamemusic.playing = false
	globals.titlemusic.play()
	globals.ammo = 50
	globals.health = 100

func _on_Retry_pressed():
#	globals.save_game()
	var _changescene = get_tree().change_scene("res://Scenes/main.tscn")
	globals.ammo = 50
	globals.health = 100
	
func save():
	var save_dict = globals.game_data
	return save_dict
	



