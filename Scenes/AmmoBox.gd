extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var randg = RandomNumberGenerator.new()
#var myrand = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	randg.randomize()
	var myrand = randg.randi_range(0,180)
	rotation.y = myrand
