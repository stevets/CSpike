extends CanvasLayer

onready var globals = $"/root/Globalnode"

func _ready():
	pass # Replace with function body.

func hide():
	$ScoreBox.hide()

func show():
	$ScoreBox.show()

func update_score():
	$ScoreBox/HBoxContainer/score.text = str(globals.game_data["finalscore"])

func update_ammo():
	$ScoreBox/HBoxContainer/ammo.text = str(globals.game_data["ammo"])
