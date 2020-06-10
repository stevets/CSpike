extends Control

onready var globals = $"/root/Globals"
onready var titlemusic = $"/root/Globalnode"


func _ready():
	$MarginContainer/CenterContainer/VBoxContainer/music_volume.value = globals.music_volume
	$MarginContainer/CenterContainer/VBoxContainer/effect_volume.value = globals.effects_volume
	
func save():
	var save_dict = {"musicvolume": globals.music_volume, "effectsvolume": globals.effects_volume}
	return save_dict
	
func _on_Back_pressed():
	var _main = get_tree().change_scene("res://Scenes/main.tscn")

func _on_HSlider_value_changed(_value):
	globals.music_volume = $MarginContainer/CenterContainer/VBoxContainer/music_volume.value
	titlemusic.get_child(0).volume_db = globals.music_volume

func _on_effect_volume_value_changed(_value):
	globals.effects_volume = $MarginContainer/CenterContainer/VBoxContainer/effect_volume.value 
