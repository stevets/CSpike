extends Control

onready var globals = $"/root/Globalnode"

func _ready():
	calc_achievements()
	
func _on_Button_pressed():
	var _main = get_tree().change_scene("res://Scenes/SceneSwitcher.tscn")

func calc_achievements():
	var achieve = 0
	achieve = floor(globals.game_data["highlevel"]/globals.achieveinst)
	for n in achieve:
		$VSplitContainer/ScrollContainer/VBoxContainer.get_child(n).disabled = false
		$VSplitContainer/ScrollContainer/VBoxContainer.get_child(n).text = "Acheived level  " + str(globals.achieveinst * (n+1))
