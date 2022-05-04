extends Control

onready var globals = $"/root/Globalnode"



func _ready():
	$VBoxContainer/VBoxContainer/VBoxContainer/music_volume/off.pressed = globals.game_data["musicbuttons"][0]
	$VBoxContainer/VBoxContainer/VBoxContainer/music_volume/low.pressed = globals.game_data["musicbuttons"][1]
	$VBoxContainer/VBoxContainer/VBoxContainer/music_volume/med.pressed = globals.game_data["musicbuttons"][2]
	$VBoxContainer/VBoxContainer/VBoxContainer/music_volume/high.pressed = globals.game_data["musicbuttons"][3]
	
	$VBoxContainer/VBoxContainer/VBoxContainer/effects_volume/off.pressed = globals.game_data["effectbuttons"][0]
	$VBoxContainer/VBoxContainer/VBoxContainer/effects_volume/low.pressed = globals.game_data["effectbuttons"][1]
	$VBoxContainer/VBoxContainer/VBoxContainer/effects_volume/med.pressed = globals.game_data["effectbuttons"][2]
	$VBoxContainer/VBoxContainer/VBoxContainer/effects_volume/high.pressed = globals.game_data["effectbuttons"][3]

func _on_Back_pressed():
	globals.save_game()
	globals.titlemusic.playing = false
	globals.gameintro.play()
	var _main = get_tree().change_scene("res://Scenes/SceneSwitcher.tscn")

#func _on_effect_volume_pressed():
#	globals.game_data["effectsvolume"] = -60
#
#func _on_music_volume_pressed():
#	var musicv = $MarginContainer/VBoxContainer/music_volume.pressed
#	globals.titlemusic.playing = musicv

func save():
	var save_dict = globals.game_data
	return save_dict
