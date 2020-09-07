extends Control

signal start_game

#onready var music = get_tree().get_root().get_node("Main/MusicPlayer")
#onready var music = get_tree().get_root().get_node("Main")

func _ready():
	#print("test", music)
	pass # Replace with function body.


func set_visibility(isvisible):
	self.visible = isvisible


func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/main.tscn")
	emit_signal("start_game")
	get_node("/root/Globalnode").get_child(0).playing = false
	#music.name()


func _on_SettingsButton_pressed():
	var _settingscreen = get_tree().change_scene("res://Scenes/SettingScreen.tscn")


func _on_AchievementsButton_pressed():
	var _settingscreen = get_tree().change_scene("res://Scenes/Achievements.tscn")


func _on_NoAdsButton_pressed():
	pass # Replace with function body.
