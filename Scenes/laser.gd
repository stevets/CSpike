extends CSGCylinder

onready var collshapelength = $StaticBody/CollisionShape.scale.y
#onready var particleslength = $CPUParticles.emission_box_extents.y

func _ready():
	pass # Replace with function body.

func shapecalc(height):
	$StaticBody/CollisionShape.scale.y = height/2
#	$CPUParticles.emission_box_extents.y = height/2
