extends Node

signal swiped(direction)
#signal swipe_canceled(start_position)
signal click()
signal swipedup()

#onready var globals = get_node("/root/Globals")

onready var cubeinst = preload("res://Scenes/cube.tscn")
onready var ballinst = preload("res://Scenes/ball.tscn")
onready var geminst = preload("res://Scenes/gem.tscn")
onready var coneinst = preload("res://Scenes/pyramid.tscn")
onready var playinst = preload("res://Scenes/Player.tscn")
onready var cubetexinst = preload("res://Scenes/newcube.tscn")


var red = ColorN("red", 1)
var blue = ColorN("blue", 1)
var green = ColorN("green", 1)
var yellow = ColorN("yellow", 1)
#var new_color = Color(1,1,1,1)

var colorarray = [red, blue, green, yellow]
var rng = RandomNumberGenerator.new()
var raise_rng = RandomNumberGenerator.new()
export var space = 1
var rows = 20
export var columns = 5

var ply : KinematicBody
onready var tick = $GameTick
onready var globals = $"/root/Globals"

var game_started = true
var game_began = false
var raise = 0

#var score = 0 

func _ready():
	$TitleScreen.set_visibility(true)
	$MusicPlayer.volume_db = globals.music_volume
	#Create game board with cubes and gems-------------------------------------------------
	for  i in range(rows):
		for j in range(columns):
			rng.randomize()
			raise_rng.randomize()
			var my_random_number = rng.randi_range(0, 3)
			var s = cubetexinst.instance()
			
#			var unique_mat = s.get_child(0).mesh.surface_get_material(0).duplicate()
#			s.get_child(0).mesh.surface_get_material(0).albedo_color = colorarray[my_random_number]
#			s.get_child(0).set_surface_material(0, unique_mat)

			var unique_mat = s.get_child(0).get_surface_material(0).duplicate()
			s.get_child(0).set_surface_material(0, unique_mat)
			s.get_child(0).get_surface_material(0).albedo_color = colorarray[my_random_number]
			if i > 5:
				rng.randomize()
				var vis_random = rng.randi_range(0,10)
				var my_random_numberp = rng.randi_range(0, 3)
				raise = raise_rng.randi_range(0,1)
				if vis_random == 1 or vis_random == 5 or vis_random == 9:
					s.get_child(0).get_child(1).mesh = SphereMesh.new()
					s.get_child(0).get_child(1).create_trimesh_collision()
					var unique_mat1 = SpatialMaterial.new()
					#s.get_child(0).get_child(1)
					s.get_child(0).get_child(1).set_surface_material(0, unique_mat1)
					s.get_child(0).get_child(1).get_surface_material(0).albedo_color = colorarray[my_random_numberp]
					add_child(s)
					s.global_translate(Vector3((j * space), raise  ,-i * space))
				elif vis_random == 2 or vis_random == 6:
					s.get_child(0).get_child(1).mesh = CubeMesh.new()
					s.get_child(0).get_child(1).create_trimesh_collision()
					var unique_mat1 = SpatialMaterial.new()
					#s.get_child(0).get_child(1)
					s.get_child(0).get_child(1).set_surface_material(0, unique_mat1)
					s.get_child(0).get_child(1).get_surface_material(0).albedo_color = colorarray[my_random_numberp]
					add_child(s)
					s.global_translate(Vector3((j * space), raise  ,-i * space))
				else:
					add_child(s)
					s.global_translate(Vector3((j * space), 0 ,-i * space))
			else:
				add_child(s)
				s.global_translate(Vector3((j * space), 0 ,-i * space))
			#print(s.get_global_transform().origin)
	#Add Player-----------------------------------------------------------------------------
	ply = playinst.instance()
	var scaleply = 0.25
	ply.scale = Vector3(scaleply,scaleply,scaleply)
	ply.name = "player1"
	add_child(ply)
	ply.global_translate(Vector3(0, 0.8 ,0))
	print(ply.get_children())
	
	$HUD.hide()
#------Swipe dectection and Click-----------------------------------------------
func _process(_delta):
	$HUD.update_score()
var eventtype = [InputEventMouseButton, InputEventScreenTouch]


onready var timer = $Timer
var swipe_start_position = Vector2(0,0)
	
func _input(event):
	if not event is eventtype[0]:
		return
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)
#InputEventScreenTouch: (use this for the phone controls)

func _start_detection(position):
	swipe_start_position = position
	timer.start()
	
func _end_detection(position):
	timer.stop()
	var direction = (position - swipe_start_position)
	var swipedetection = 60
	var hangle = 15
	var vangle = 75
	if direction.length() >= 60:
		var swipeangle = direction.angle_to(Vector2(1, 0))*180/3.14
		print(swipeangle)
		if swipeangle <= hangle or swipeangle >= 180 - hangle:
			if direction.x >= swipedetection or direction.x <= -swipedetection:
				emit_signal('swiped', Vector2(-sign(direction.x), 0.0))
		elif swipeangle >= vangle or swipeangle <= 180 - vangle:
			emit_signal('swipedup')
		else:
			print('swipe again')
	elif game_started :
		$EffectGunPlayer.volume_db = -80
		emit_signal('click')
		print("click")
	else:
		$EffectGunPlayer.volume_db = globals.effects_volume
		emit_signal('click')
		print("beganclick")
			
		


func _on_Timer_timeout():
	emit_signal('swipe_canceled', swipe_start_position)
	

func _on_TitleScreen_start_game():
	$TitleScreen.set_visibility(false)
	$HUD.show()
	tick.start(10)
	game_started = true
	$EffectGunPlayer.volume_db = -80
