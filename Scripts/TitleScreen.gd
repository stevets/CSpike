extends Control

signal start_game

#onready var mainscene = preload("res://Scenes/main.tscn")
onready var globals = get_node("/root/Globals")
onready var music = get_tree().get_root().get_node("Main/MusicPlayer")
func _ready():
	$CenterContainer/VBoxContainer/highscore.text = str(globals.highscore)
	print(str(globals.get_parent()))


func _on_play_pressed():
	emit_signal("start_game")
	get_node("/root/Globalnode").get_child(0).playing = false
	music.play()
	
	#get_tree().change_scene("res://Scenes/main.tscn")

func _on_settings_pressed():
	var _settingscreen = get_tree().change_scene("res://Scenes/SettingScreen.tscn")

func set_visibility(isvisible):
	self.visible = isvisible
