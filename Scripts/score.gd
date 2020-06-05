extends CanvasLayer

onready var globals = $"/root/Globals"

func _ready():
	pass # Replace with function body.

func hide():
	$ScoreBox.hide()
	
func show():
	$ScoreBox.show()
	
func update_score():
	$ScoreBox/HBoxContainer/score.text = str(globals.finalscore)
