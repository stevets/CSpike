extends Control

onready var globals = $"/root/Globalnode"
onready var score = get_node("CenterContainer/VBoxContainer/score")
onready var highscore = get_node("CenterContainer/VBoxContainer/newhighscore")
onready var titlemusic = $"/root/Globalnode"
#
func _ready():
	highscore.text = str(globals.highscore)
	score.text = str(globals.finalscore)
	globals.finalscore = 0
	globals.save_game()               
	
func _on_SettingBack_pressed():
	var _changescene = get_tree().change_scene("res://Scenes/MainScreen.tscn")
	titlemusic.get_node("TitleMusicPlayer").play()

func _on_Retry_pressed():
	var _changescene = get_tree().change_scene("res://Scenes/main.tscn")
#	titlemusic.get_node("TitleMusicPlayer").play()
	
func save():
	var save_dict = {"highscore": globals.highscore,
					"coins": globals.coins}
	return save_dict



