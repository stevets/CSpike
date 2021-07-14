extends Control

onready var globals = $"/root/Globalnode"


func _ready():
	$Menu/HBoxContainer/highscore.text = str(globals.game_data["highscore"])


func set_visibility(isvisible):
	self.visible = isvisible


func _on_Play_pressed():
	var _chscene = get_tree().change_scene("res://Scenes/main.tscn")
	globals.titlemusic.playing = false



func _on_SettingsButton_pressed():
	var _settingscreen = get_tree().change_scene("res://Scenes/SettingScreen.tscn")


func _on_AchievementsButton_pressed():
	var _settingscreen = get_tree().change_scene("res://Scenes/Achievements.tscn")


func _on_NoAdsButton_pressed():
	pass # Replace with function body.
 
