extends Control

onready var globals = $"/root/Globals"


func _ready():
	$MarginContainer/CenterContainer/VBoxContainer/music_volume.value = globals.music_volume
	$MarginContainer/CenterContainer/VBoxContainer/effect_volume.value = globals.effects_volume
	

func _on_Back_pressed():
	var _main = get_tree().change_scene("res://Scenes/main.tscn")


func _on_HSlider_value_changed(_value):
	globals.music_volume = $MarginContainer/CenterContainer/VBoxContainer/music_volume.value


func _on_effect_volume_value_changed(_value):
	globals.effects_volume = $MarginContainer/CenterContainer/VBoxContainer/effect_volume.value 
