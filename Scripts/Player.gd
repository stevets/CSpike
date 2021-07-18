extends KinematicBody

signal destroy(objID)
signal click()
signal resetgun()

var fired_weapon = false

var red = ColorN("red", 1)
var dx = 1
var space_state
var result
var colorcube
var spiritdetected = false

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
			var colorglow = result.collider.get_parent().get_parent()
			var tokenboxes = result.collider.get_parent().name
			print("tokenboxes: ", tokenboxes)
			if colorglow.get_child(0).name == "basecube":
				spiritdetected = result.collider.get_parent().get_parent().spirit
				print("SPIRIT was detected: ", spiritdetected)
			if colorglow.get_child(0).name == "Medicbox" or colorglow.get_child(0).name == "Ammobox":
				spiritdetected = result.collider.get_parent().get_parent().get_parent().get_parent().get_parent().spirit
				#print("spirit was detected: ", spiritdetected)
			if !spiritdetected or tokenboxes == "token":
				print("color2 ",color2)
				print("colorblock ", colorblock)
				print(result.position.z)
				print(result.collider.get_parent().get_parent().name)
				print(color2)
				if color2 == colorblock and globals.ammogun:
					print("destroy")
					print(result.collider)
					
					var objID = result.collider
					emit_signal("destroy", objID)
					#var ply = get_tree().get_root().get_node("Main/player1")
					globals.hitsound.volume_db = globals.game_data["effectsvolume"]
					globals.hitsound.play()
					
	#			elif abs(ply.get_global_transform().origin.z-result.position.z) > 2:
	#				emit_signal("playermove")
				elif result.collider.get_parent().get_parent().name == "AmmoBox":
					if globals.ammogun == true:
						globals.ammo += 25
						var objID = result.collider
						objID.get_parent().queue_free()
						emit_signal("destroy", objID)
				elif result.collider.get_parent().get_parent().name == "MedicBox":
					if globals.ammogun == true:
						globals.game_data["health"] += 25
						var objID = result.collider
						objID.get_parent().queue_free()
						emit_signal("destroy", objID)
				elif globals.ammogun == false:
					print("hello", result.collider.get_parent().name)
					colorglow.spirit = true
					globals.ammogun = true
					emit_signal("resetgun")
					colorglow.get_child(0).get_surface_material(0).emission_enabled = true
					colorglow.get_child(0).get_surface_material(0).emission = Color(.5, .5, .5, .5)
					globals.spiritlocation.spirit = false
					globals.spiritlocation.get_child(0).get_surface_material(0).emission_enabled = false
					globals.spiritlocation.get_child(0).get_surface_material(0).emission = Color(0, 0, 0, 1)
					globals.spiritlocation = colorglow
							
		fired_weapon = false

func _on_Main_click():
#	fired_weapon = true
#	globals.gunshot.play()
#
#	didstart.game_started = false
	pass
	


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
		if globals.game_data["finalscore"] > globals.game_data["highscore"]:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
	else:
		globals.rowchangetick.volume_db = globals.game_data["effectsvolume"]
		globals.rowchangetick.play()
		var cam = get_tree().get_root().get_node("Main/Camera")
		globals.game_data["finalscore"] += 1
		ply.global_translate(Vector3(0,0,-1))
		cam.global_translate(Vector3(0,0,-1))
	if playerposz < -18:
		if globals.game_data["finalscore"] > globals.game_data["highscore"]:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
	if globals.ammo == 0 or globals.game_data["health"] == 0:
		if globals.game_data["finalscore"] > globals.game_data["highscore"]:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		




func _on_Button_pressed():
	if globals.ammogun == false:
		globals.ammogun = true
	elif globals.ammogun == true:
		globals.ammogun = false


func _on_Button2_pressed():
	if didstart.game_started:
		fired_weapon = true
		globals.gunshot.play()
		#didstart.game_started = false
		#emit_signal('click')
		#print("click")
