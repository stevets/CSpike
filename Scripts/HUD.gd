extends CanvasLayer

onready var globals = $"/root/Globalnode"

func _ready():
	pass # Replace with function body.

func hide():
	$ScoreBox.hide()
	
func show():
	$ScoreBox.show()
	
func update_score():
	$ScoreBox/HBoxContainer/score.text = str(globals.finalscore)
	
func update_ammo():
	$ScoreBox/HBoxContainer/ammo.text = str(globals.ammo)
	
func update_health():
	$ScoreBox/HBoxContainer/health.text = str(globals.health)
	
func update_coins():
	$ScoreBox/HBoxContainer/coins.text = str(globals.coins)
