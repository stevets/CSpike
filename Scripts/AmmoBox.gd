extends Spatial


var randg = RandomNumberGenerator.new()

func _ready():
	randg.randomize()
	var myrand = randg.randi_range(0,180)
	rotation.y = myrand
