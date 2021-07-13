extends Control

onready var globals = $"/root/Globalnode"
onready var score = get_node("CenterContainer/VBoxContainer/score")
onready var highscore = get_node("CenterContainer/VBoxContainer/newhighscore")
#
func _ready():
	highscore.text = str(globals.game_data["highscore"])
	score.text = str(globals.game_data["finalscore"])
	globals.game_data["finalscore"] = 0         
	
func _on_SettingBack_pressed():
	globals.save_game()
	var _changescene = get_tree().change_scene("res://Scenes/MainScreen.tscn")
	globals.gamemusic.playing = false
	globals.titlemusic.play()

func _on_Retry_pressed():
	globals.save_game()
	var _changescene = get_tree().change_scene("res://Scenes/main.tscn")
	
func save():
	var save_dict = globals.game_data
	return save_dict



