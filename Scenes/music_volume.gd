extends HBoxContainer

onready var globals = $"/root/Globalnode"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _on_off_toggled(button_pressed):
	print("buttons0")
	$low.pressed = false
	$med.pressed = false
	$high.pressed = false
	$off.pressed = button_pressed
	globals.game_data["musicbuttons"][0] = button_pressed
	globals.game_data["musicbuttons"][1] = false
	globals.game_data["musicbuttons"][2] = false
	globals.game_data["musicbuttons"][3] = false
	globals.game_data["musicvolume"] = globals.gamevolumes[0]
	setmusicvolumes()
	

func _on_low_toggled(button_pressed):
	print("buttons1")
	$off.pressed = false
	$med.pressed = false
	$high.pressed = false
	$low.pressed = button_pressed
	globals.game_data["musicbuttons"][0] = false
	globals.game_data["musicbuttons"][1] = button_pressed
	globals.game_data["musicbuttons"][2] = false
	globals.game_data["musicbuttons"][3] = false
	globals.game_data["musicvolume"] = globals.gamevolumes[1]
	setmusicvolumes()


func _on_med_toggled(button_pressed):
	print("buttons2")
	$low.pressed = false
	$off.pressed = false
	$high.pressed = false
	$med.pressed = button_pressed
	globals.game_data["musicbuttons"][0] = false
	globals.game_data["musicbuttons"][1] = false
	globals.game_data["musicbuttons"][2] = button_pressed
	globals.game_data["musicbuttons"][3] = false
	globals.game_data["musicvolume"] = globals.gamevolumes[2]
	setmusicvolumes()


func _on_high_toggled(button_pressed):
	print("buttons3")
	$low.pressed = false
	$med.pressed = false
	$off.pressed = false
	$high.pressed = button_pressed
	globals.game_data["musicbuttons"][0] = false
	globals.game_data["musicbuttons"][1] = false
	globals.game_data["musicbuttons"][2] = false
	globals.game_data["musicbuttons"][3] = button_pressed
	globals.game_data["musicvolume"] = globals.gamevolumes[3]
	setmusicvolumes()

func setmusicvolumes():
	var i = 0
	for player in globals.musicplayerarray:
		player.volume_db =  globals.game_data["musicvolume"] - globals.musicadjust[i]
		i+=1
