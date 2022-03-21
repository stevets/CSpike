extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	var _main = get_tree().change_scene("res://Scenes/SceneSwitcher.tscn")


func _on_AdsOff_pressed():
	MobileAds.hide_banner()
	MobileAds.destroy_banner()
