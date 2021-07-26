extends CanvasLayer

onready var globals = $"/root/Globalnode"


func _ready():
	pass # Replace with function body.

func hide():
	$ScoreBox.hide()
	
func show():
	$ScoreBox.show()
	
func update_score():
	$ScoreBox/VBoxContainer/HBoxContainer/score.text = str(globals.game_data["finalscore"])
	
func update_ammo():
	$ScoreBox/VBoxContainer/HBoxContainer/ammo.text = str(globals.ammo)
	
func update_health():
	$ScoreBox/VBoxContainer/HBoxContainer/health.text = str(globals.health)
	
func update_coins():
	$ScoreBox/VBoxContainer/HBoxContainer/coins.text = str(globals.game_data["coins"])
	
func update_spirit_gun():
	if globals.ammogun == false:
		$ScoreBox/VBoxContainer/FireButtons/Button.get("custom_fonts/font").outline_color = Color(1,0,0,1)
		$ScoreBox/VBoxContainer/FireButtons/Button.text = "Spirit Gun"
	elif globals.ammogun == true:
		$ScoreBox/VBoxContainer/FireButtons/Button.get("custom_fonts/font").outline_color = Color(0,0,0,1)
		$ScoreBox/VBoxContainer/FireButtons/Button.text = "Regular Gun"
