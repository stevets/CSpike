extends Node

onready var cubeinst = preload("res://Scenes/cube.tscn")
onready var ballinst = preload("res://Scenes/ball.tscn")
onready var geminst = preload("res://Scenes/gem.tscn")
onready var coneinst = preload("res://Scenes/pyramid.tscn")

var red = ColorN("red", 1)
var blue = ColorN("blue", 1)
var green = ColorN("green", 1)
var yellow = ColorN("yellow", 1)
#var new_color = Color(1,1,1,1)


var colorarray = [red, blue, green, yellow]
var rng = RandomNumberGenerator.new()
export var space = 1.1
export var rows = 20
export var columns = 5

func _ready():
	for  i in range(rows):
		for j in range(columns):
			rng.randomize()
			var my_random_number = rng.randi_range(0, 3)
			#print(randomize())
			var s = cubeinst.instance()
			s.translate(Vector3((j-3)*space, 0 ,-i* space))
			var unique_mat = s.get_surface_material(0).duplicate()
			s.set_surface_material(0, unique_mat)
			s.get_surface_material(0).albedo_color = colorarray[my_random_number]
			if i > 5:
				rng.randomize()
				var vis_random = rng.randi_range(0,10)
				var my_random_numberp = rng.randi_range(0, 3)
				
				if vis_random == 1 or vis_random == 5 or vis_random == 9:
					var p = ballinst.instance()
					p.translate(Vector3((j-3)*space, 1 ,-i* space))
					var unique_matp = p.get_surface_material(0).duplicate()
					p.set_surface_material(0, unique_matp)
					p.get_surface_material(0).albedo_color = colorarray[my_random_numberp]
					add_child(p)
				elif vis_random == 2 or vis_random == 6:
					var g = geminst.instance()
					g.translate(Vector3((j-3)*space, 1 ,-i* space))
					g.rotate_x(45)
					g.rotate_y(45)
					var unique_matp = g.get_surface_material(0).duplicate()
					g.set_surface_material(0, unique_matp)
					g.get_surface_material(0).albedo_color = colorarray[my_random_numberp]
					add_child(g)
					
		
			add_child(s)
			
