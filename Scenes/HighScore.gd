extends VBoxContainer

onready var globals = $"/root/Globalnode"
onready var score = get_node("score")
onready var highscore = get_node("newhighscore")
onready var outputfeedback = get_node("outputfeedback")

func _ready():
	highscore.text = str(globals.game_data["highscore"])
	score.text = str(globals.game_data["finalscore"])
	outputfeedback.text = str(globals.output)
	globals.spiritdied = false


func save():
	var save_dict = globals.game_data
	return save_dict
