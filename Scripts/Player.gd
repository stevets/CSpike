extends KinematicBody

signal destroy(objID)

var fired_weapon = false

var red = ColorN("red", 1)
var dx = 1
var space_state
var result
var colorcube
onready var globals = $"/root/Globalnode"
onready var didstart = get_tree().get_root().get_node("Main")


func _on_Main_swiped(direction):
	var ply = get_tree().get_root().get_node("Main/player1")
	space_state = get_world().direct_space_state
	var playerposx = ply.get_global_transform().origin.x
	var playerposy = ply.get_global_transform().origin.y
	var playerposz = ply.get_global_transform().origin.z
	var resultleft = space_state.intersect_ray(Vector3(playerposx,playerposy,playerposz), Vector3(playerposx - 1.5,playerposy,playerposz), [self])
	var resultright = space_state.intersect_ray(Vector3(playerposx,playerposy,playerposz), Vector3(playerposx + 1.5,playerposy,playerposz), [self])
	print("resultLeft:", resultleft)
	print("resultRight:",resultright)
	if direction.x >= 0:
		#print("direction = ", direction.x)
		if playerposx < 1:
			pass
		elif resultleft.has("collider"):
			pass
			
		else:
			ply.global_translate(Vector3(-dx,0,0))  #move character to the left
			
	else:
		print("direction = ", direction.x)
		if playerposx > 3:
			pass
		elif resultright.has("collider"):
			pass
			
		else:
			ply.global_translate(Vector3(dx, 0, 0)) #move character to the right
			
	
func _process(_delta):
	
	while fired_weapon:
		print("process running")
		globals.ammo -= 1
		if globals.ammo <= 0:
			_on_GameTick_timeout()
		
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
			print(result.collider.get_parent().get_parent().name)
			if color2 == colorblock:
				print("destroy")
				print(result.collider)
				
				var objID = result.collider
				emit_signal("destroy", objID)
				#var ply = get_tree().get_root().get_node("Main/player1")
				globals.hitsound.volume_db = globals.effects_volume
				globals.hitsound.play()
				
#			elif abs(ply.get_global_transform().origin.z-result.position.z) > 2:
#				emit_signal("playermove")
			elif result.collider.get_parent().get_parent().name == "AmmoBox":
				globals.ammo += 25
				var objID = result.collider
				objID.get_parent().queue_free()
				emit_signal("destroy", objID)
			elif result.collider.get_parent().get_parent().name == "MedicBox":
				globals.health += 25
				var objID = result.collider
				objID.get_parent().queue_free()
				emit_signal("destroy", objID)
		
		fired_weapon = false

func _on_Main_click():
	fired_weapon = true
	globals.gunshot.play()
	
	didstart.game_started = false
	


func _on_Main_swipedup():
	pass
#	var ply = get_tree().get_root().get_node("Main/player1")
#	var cam = get_tree().get_root().get_node("Main/Camera")
#	var playerpos = ply.get_global_transform().origin.x
#	ply.global_translate(Vector3(0,0,-1))
#	cam.global_translate(Vector3(0,0,-1))


func _on_GameTick_timeout():
	var ply = get_tree().get_root().get_node("Main/player1")
	space_state = get_world().direct_space_state
	var playerposx = ply.get_global_transform().origin.x
	var playerposy = ply.get_global_transform().origin.y
	var playerposz = ply.get_global_transform().origin.z
	var resultfront = space_state.intersect_ray(Vector3(playerposx,playerposy,playerposz), Vector3(playerposx,playerposy,playerposz -1.5), [self])
	if resultfront.has("collider"):
		if globals.finalscore > globals.highscore:
			globals.highscore = globals.finalscore
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
	else:
		globals.rowchangetick.volume_db = globals.effects_volume
		globals.rowchangetick.play()
		var cam = get_tree().get_root().get_node("Main/Camera")
		globals.finalscore += 1
		ply.global_translate(Vector3(0,0,-1))
		cam.global_translate(Vector3(0,0,-1))
	if playerposz < -18:
		if globals.finalscore > globals.highscore:
			globals.highscore = globals.finalscore
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
	if globals.ammo == 0 or globals.health == 0:
		if globals.finalscore > globals.highscore:
			globals.highscore = globals.finalscore
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		

