extends Control

#onready var mainscene = preload("res://Scenes/main.tscn")

func _ready():
	pass # Replace with function body.


func _on_play_pressed():
	get_tree().change_scene("res://Scenes/main.tscn")


func _on_settings_pressed():
	get_tree().change_scene("res://Scenes/SettingScreen.tscn")
