extends Control

onready var globals = $"/root/Globals"
onready var titlemusic = $"/root/Globalnode"


func _ready():
	pass
	
func save():
	var save_dict = {"musicvolume": globals.music_volume, "effectsvolume": globals.effects_volume}
	return save_dict
	
func _on_Back_pressed():
	var _main = get_tree().change_scene("res://Scenes/MainScreen.tscn")



func _on_effect_volume_pressed():
	globals.effects_volume = -60


func _on_music_volume_pressed():
	var musicv = $MarginContainer/VBoxContainer/music_volume.pressed
	get_node("/root/Globalnode").get_child(0).playing = musicv

