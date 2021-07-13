extends Control

onready var globals = $"/root/Globalnode"



func _ready():
	pass
	
	
func _on_Back_pressed():
	globals.save_game()
	var _main = get_tree().change_scene("res://Scenes/MainScreen.tscn")



func _on_effect_volume_pressed():
	globals.game_data["effectsvolume"] = -60


func _on_music_volume_pressed():
	var musicv = $MarginContainer/VBoxContainer/music_volume.pressed
	globals.titlemusic.playing = musicv
	
func save():
	var save_dict = globals.game_data
	return save_dict
