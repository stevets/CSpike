extends CanvasLayer

onready var globals = $"/root/Globalnode"


func _ready():
	pass # Replace with function body.

func hide():
	$ScoreBox.hide()
	
func show():
	$ScoreBox.show()
	
func update_score():
	$ScoreBox/VBoxContainer/VBoxContainer/ScoreHBox/score.text = str(globals.game_data["finalscore"])
	
func update_ammo():
	$ScoreBox/VBoxContainer/VBoxContainer/ScoreHBox/ammo.text = str(globals.ammo)
	
func update_health():
	$ScoreBox/VBoxContainer/VBoxContainer/ScoreHBox/health.text = str(globals.health)
func died():
	pass

func update_coins():
	$ScoreBox/VBoxContainer/VBoxContainer/ScoreHBox/coins.text = str(globals.game_data["coins"])
	
func update_spirit_gun():
	if globals.ammogun == false:
		$ScoreBox/VBoxContainer/FireButtons/VBoxContainer/FirstHBox/Button.get("custom_fonts/font").outline_color = Color(1,0,0,1)
		$ScoreBox/VBoxContainer/FireButtons/VBoxContainer/FirstHBox/Button.text = "Spirit Gun"
	elif globals.ammogun == true:
		$ScoreBox/VBoxContainer/FireButtons/VBoxContainer/FirstHBox/Button.get("custom_fonts/font").outline_color = Color(0,0,0,1)
		$ScoreBox/VBoxContainer/FireButtons/VBoxContainer/FirstHBox/Button.text = "Regular Gun"
