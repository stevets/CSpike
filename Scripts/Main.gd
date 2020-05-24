extends Node

signal swiped(direction)
#signal swipe_canceled(start_position)
signal click()

onready var cubeinst = preload("res://Scenes/cube.tscn")
onready var ballinst = preload("res://Scenes/ball.tscn")
onready var geminst = preload("res://Scenes/gem.tscn")
onready var coneinst = preload("res://Scenes/pyramid.tscn")
onready var playinst = preload("res://Scenes/Player.tscn")


var red = ColorN("red", 1)
var blue = ColorN("blue", 1)
var green = ColorN("green", 1)
var yellow = ColorN("yellow", 1)
#var new_color = Color(1,1,1,1)

var colorarray = [red, blue, green, yellow]
var rng = RandomNumberGenerator.new()
export var space = 1.1
export var rows = 40
export var columns = 5

var ply : KinematicBody

func _ready():
	#Create game board with cubes and gems-------------------------------------------------
	for  i in range(rows):
		for j in range(columns):
			rng.randomize()
			var my_random_number = rng.randi_range(0, 3)
			var s = cubeinst.instance()
			#s.translate(Vector3(j * space, 0 ,-i * space))
			var unique_mat = s.get_surface_material(0).duplicate()
			s.set_surface_material(0, unique_mat)
			s.get_surface_material(0).albedo_color = colorarray[my_random_number]
			if i > 5:
				rng.randomize()
				var vis_random = rng.randi_range(0,10)
				var my_random_numberp = rng.randi_range(0, 3)
				
				if vis_random == 1 or vis_random == 5 or vis_random == 9:
					var p = ballinst.instance()
					#p.translate(Vector3((j)*space, 1 ,-i* space))
					var unique_matp = p.get_surface_material(0).duplicate()
					p.set_surface_material(0, unique_matp)
					p.get_surface_material(0).albedo_color = colorarray[my_random_numberp]
					add_child(p)
					p.global_translate(Vector3(j*space, 1 ,-i* space))
				elif vis_random == 2 or vis_random == 6:
					var g = geminst.instance()
					#g.translate(Vector3((j)*space, 1 ,-i* space))
					g.rotate_x(45)
					g.rotate_y(45)
					var unique_matp = g.get_surface_material(0).duplicate()
					g.set_surface_material(0, unique_matp)
					g.get_surface_material(0).albedo_color = colorarray[my_random_numberp]
					add_child(g)
					g.global_translate(Vector3(j*space, 1 ,-i* space))
			add_child(s)
			s.global_translate(Vector3((j * space), 0 ,-i * space))
			#print(s.get_global_transform().origin)
	#Add Player-----------------------------------------------------------------------------
	ply = playinst.instance()
	var scaleply = 0.25
	ply.scale = Vector3(scaleply,scaleply,scaleply)
	ply.name = "player1"
	add_child(ply)
	ply.global_translate(Vector3(0, 1 ,0))
	print(ply.get_children())

#------Swipe dectection and Click-----------------------------------------------

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
	if direction.x >= swipedetection or direction.x <= -swipedetection:
		emit_signal('swiped', Vector2(-sign(direction.x), 0.0))
	else:
		emit_signal('click')
		print("click")
		
	

func _on_Timer_timeout():
	emit_signal('swipe_canceled', swipe_start_position)
#func _on_SwipeDetection_click(): #(use this for whatever event we use when the player clicks)
	#print('hi')




func _on_Player_playermove():
	ply.global_translate(Vector3(0,0,-1.1))
