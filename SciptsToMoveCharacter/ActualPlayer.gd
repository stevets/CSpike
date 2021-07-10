extends KinematicBody

signal destroy(objID)

var fired_weapon = false

var red = ColorN("red", 1)
var dx = 1
var space_state
var result
var colorcube
onready var globals = $"/root/Globalnode"
onready var ply = get_tree().get_root().get_node("Main/player1")

func _ready():
	pass



func _on_Main_swiped(direction):
	var ply = get_tree().get_root().get_node("Main/player1")
	var playerpos = ply.get_global_transform().origin.x
	if direction.x >= 0:
		#print("direction = ", direction.x)
		if playerpos < 1:
			pass
		else:
			ply.global_translate(Vector3(-dx,0,0))  #move character to the left
	else:
		print("direction = ", direction.x)
		if playerpos > 3:
			pass
		else:
			ply.global_translate(Vector3(dx, 0, 0)) #move character to the right
	
func _process(delta):
	
	while fired_weapon:
		print("process running")
		space_state = get_world().direct_space_state
		var ply = get_tree().get_root().get_node("Main/player1")
		var originx = ply.get_global_transform().origin.x
		var originy = ply.get_global_transform().origin.y
		var originz = ply.get_global_transform().origin.z
		result = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,originy,-21), [self])	
		print("result ", result)
		colorcube = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,-5,originz), [self])
		print("colorcube ", colorcube)
		
		
		

		if result and colorcube:
			var color2 = result.collider.get_parent().get_surface_material(0).albedo_color
			var colorblock =  colorcube.collider.get_parent().get_surface_material(0).albedo_color
			print("color2 ",color2)
			print("colorblock ", colorblock)
			print(result.position.z)
			if color2 == colorblock:
				print("destroy")
				print(result.collider)
				var objID = result.collider
				emit_signal("destroy", objID)
				#var ply = get_tree().get_root().get_node("Main/player1")
				ply.get_child(3).playing = true
				
#			elif abs(ply.get_global_transform().origin.z-result.position.z) > 2:
#				emit_signal("playermove")
				
		
		fired_weapon = false

func _on_Main_click():
	fired_weapon = true
	var ply = get_tree().get_root().get_node("Main/player1")
	ply.get_child(2).playing = true


func _on_Main_swipedup():
	pass
#	var ply = get_tree().get_root().get_node("Main/player1")
#	var cam = get_tree().get_root().get_node("Main/Camera")
#	var playerpos = ply.get_global_transform().origin.x
#	ply.global_translate(Vector3(0,0,-1))
#	cam.global_translate(Vector3(0,0,-1))


func _on_GameTick_timeout():
	
	var ply = get_tree().get_root().get_node("Main/player1")
	ply.get_child(1).playing = true
	var cam = get_tree().get_root().get_node("Main/Camera")
	var playerpos = ply.get_global_transform().origin.x
	var playerposz = ply.get_global_transform().origin.z
	
	globals.finalscore += 1
#	var currentscore = int(score.text)
#	score.text = str(currentscore + 1)
	ply.global_translate(Vector3(0,0,-1))
	cam.global_translate(Vector3(0,0,-1))
	ply.get_child(1).playing = false
	if playerposz < -19:
		#var globals = $"/root/Globalnode"
		#globals.finalscore = currentscore
		if globals.finalscore > globals.highscore:
			globals.highscore = globals.finalscore
		get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")

