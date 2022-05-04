extends HBoxContainer
onready var globals = $"/root/Globalnode"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_off_toggled(button_pressed):
	$low.pressed = false
	$med.pressed = false
	$high.pressed = false
	$off.pressed = button_pressed
	globals.game_data["effectbuttons"][0] = button_pressed
	globals.game_data["effectbuttons"][1] = false
	globals.game_data["effectbuttons"][2] = false
	globals.game_data["effectbuttons"][3] = false
	globals.game_data["effectsvolume"] = globals.gamevolumes[0]
	seteffectvolumes()
	

func _on_low_toggled(button_pressed):
	$off.pressed = false
	$med.pressed = false
	$high.pressed = false
	$low.pressed = button_pressed
	globals.game_data["effectbuttons"][0] = false
	globals.game_data["effectbuttons"][1] = button_pressed
	globals.game_data["effectbuttons"][2] = false
	globals.game_data["effectbuttons"][3] = false
	globals.game_data["effectsvolume"] = globals.gamevolumes[1]
	seteffectvolumes()


func _on_med_toggled(button_pressed):
	$low.pressed = false
	$off.pressed = false
	$high.pressed = false
	$med.pressed = button_pressed
	globals.game_data["effectbuttons"][0] = false
	globals.game_data["effectbuttons"][1] = false
	globals.game_data["effectbuttons"][2] = button_pressed
	globals.game_data["effectbuttons"][3] = false
	globals.game_data["effectsvolume"] = globals.gamevolumes[2]
	seteffectvolumes()


func _on_high_toggled(button_pressed):
	$low.pressed = false
	$med.pressed = false
	$off.pressed = false
	$high.pressed = button_pressed
	globals.game_data["effectbuttons"][0] = false
	globals.game_data["effectbuttons"][1] = false
	globals.game_data["effectbuttons"][2] = false
	globals.game_data["effectbuttons"][3] = button_pressed
	globals.game_data["effectsvolume"] = globals.gamevolumes[3]
	seteffectvolumes()
	
func seteffectvolumes():
	var i = 0
	for player in globals.effectplayerarray:
		player.volume_db =  globals.game_data["effectsvolume"] - globals.effectsadjust[i]
		i+=1
		
	
