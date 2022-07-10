extends Node2D
onready var globals = $"/root/Globalnode"


func _on_Button_pressed():
#	print("Tutorial Text: ",globals.tutorialtext.size())
#	print("Tutorial Step: ",globals.tutorialstep)
	if globals.tutorialstep < globals.tutorialtext.size() + 1:
		globals.tutorialstep += 1
	$Swipe.stop(true)
#	visible = false

