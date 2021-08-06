extends KinematicBody

signal destroy(objID)

var fired_weapon = false

var red = ColorN("red", 1)
var dx = 1
var space_state
var result
var colorcube
var spiritdetected = false
var bombexploded
var bombset = false
var bombtwo = false
var bombnew
var bombtwosound = false
var objID

onready var globals = $"/root/Globalnode"
onready var didstart = get_tree().get_root().get_node("Main")
onready var bombtick = $BombTick


func _on_Main_swiped(direction):
	var ply = get_tree().get_root().get_node("Main/player1")
	space_state = get_world().direct_space_state
	var playerposx = ply.get_global_transform().origin.x
	var playerposy = ply.get_global_transform().origin.y
	var playerposz = ply.get_global_transform().origin.z
	var resultleft = space_state.intersect_ray(Vector3(playerposx,playerposy,playerposz), Vector3(playerposx - 1.5,playerposy,playerposz), [self])
	var resultright = space_state.intersect_ray(Vector3(playerposx,playerposy,playerposz), Vector3(playerposx + 1.5,playerposy,playerposz), [self])
#	print("resultLeft:", resultleft)
#	print("resultRight:",resultright)
	if direction.x >= 0:
		#print("direction = ", direction.x)
		if playerposx < 1:
			pass
		elif resultleft.has("collider"):
			pass
			
		else:
			ply.global_translate(Vector3(-dx,0,0))  #move character to the left
			
	else:
#		print("direction = ", direction.x)
		if playerposx > 3:
			pass
		elif resultright.has("collider"):
			pass
			
		else:
			ply.global_translate(Vector3(dx, 0, 0)) #move character to the right
			
	
func _process(_delta):
	space_state = get_world().direct_space_state
	var ply = get_tree().get_root().get_node("Main/player1")
	var originx = ply.get_global_transform().origin.x
	var originy = ply.get_global_transform().origin.y
	var originz = ply.get_global_transform().origin.z
	var spiritposz = globals.spiritlocation.get_global_transform().origin.z	
	if globals.ammo <= 0 or spiritposz > originz or globals.health <= 0:
		_on_GameTick_timeout()
	
	while fired_weapon:
		print("fired weapon process running")
		globals.ammo -= 1	
		result = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,originy,originz + globals.raycast_length), [self])
		colorcube = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,-5,originz), [self])
#		var color2 = result.collider.get_parent().get_surface_material(0).albedo_color
#		var colorblock =  colorcube.collider.get_parent().get_surface_material(0).albedo_color
#		var colorglow = result.collider.get_parent().get_parent()
#		var tokenboxes = result.collider.get_parent().name
#		space_state = get_world().direct_space_state
#		var ply = get_tree().get_root().get_node("Main/player1")
#		var originx = ply.get_global_transform().origin.x
#		var originy = ply.get_global_transform().origin.y
#		var originz = ply.get_global_transform().origin.z
#		var spiritposz = globals.spiritlocation.get_global_transform().origin.z
#		if globals.ammo <= 0 or spiritposz > originz:
#			_on_GameTick_timeout()
		
#		result = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,originy,originz + globals.raycast_length), [self])	
#		print("result ", result)
#		colorcube = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,-5,originz), [self])
#		print("colorcube ", colorcube)
		
		if globals.skillgun and result:
			var colorblock =  colorcube.collider.get_parent().get_surface_material(0).albedo_color
			var colorglow = result.collider.get_parent().get_parent()
			var tokenboxes = result.collider.get_parent().name
#			print("tokenboxes: ", tokenboxes)
			if colorglow.get_child(0).name == "basecube":
				spiritdetected = result.collider.get_parent().get_parent().spirit
				print("SPIRIT was detected: ", spiritdetected)
			if colorglow.get_child(0).name == "Medicbox" or colorglow.get_child(0).name == "Ammobox":
				spiritdetected = result.collider.get_parent().get_parent().get_parent().get_parent().get_parent().spirit
				#print("spirit was detected: ", spiritdetected)
			if !spiritdetected or tokenboxes == "token":
#				print("color2 ",color2)
#				print("colorblock ", colorblock)
#				print(result.position.z)
#				print(result.collider.get_parent().get_parent().name)
#				print(color2)
#					print("destroy")
#					print(result.collider)
				globals.skillgun == false	
				var objID = result.collider
				emit_signal("destroy", objID)
					#var ply = get_tree().get_root().get_node("Main/player1")
				globals.hitsound.volume_db = globals.game_data["effectsvolume"]
				globals.hitsound.play()
				print(result.collider)
					
	#			elif abs(ply.get_global_transform().origin.z-result.position.z) > 2:
	#				emit_signal("playermove")
				if result.collider.get_parent().get_parent().name == "AmmoBox":
#					if globals.skillgun == true:
						globals.skillgun == false
						globals.ammo += 25
						globals.game_data["coins"] += 5
						objID = result.collider
						objID.get_parent().queue_free()
						emit_signal("destroy", objID)
				elif result.collider.get_parent().get_parent().name == "MedicBox":
#					if globals.skillgun == true:
						globals.skillgun == false	
						globals.health += 25
						globals.game_data["coins"] += 5
						objID = result.collider
						objID.get_parent().queue_free()
						emit_signal("destroy", objID)
				elif result.collider.get_parent().get_child(1).has_node("bomb"):
					if result.collider.get_parent().get_child(1).get_child(0).name == "bomb":
						globals.skillgun == false
#						if bombexploded.has_node("bomb"):
						if globals.bombexplodedcheck == result.collider:
							globals.bombticking.stop()
						objID = result.collider
						emit_signal("destroy", objID)
								
		elif result and colorcube:
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
#				print("color2 ",color2)
#				print("colorblock ", colorblock)
#				print(result.position.z)
#				print(result.collider.get_parent().get_parent().name)
#				print(color2)
				if color2 == colorblock and globals.ammogun:
#					print("destroy")
#					print(result.collider)
					
					var objID = result.collider
#					globals.skillgun = false
					emit_signal("destroy", objID)
					#var ply = get_tree().get_root().get_node("Main/player1")
					globals.hitsound.volume_db = globals.game_data["effectsvolume"]
					globals.hitsound.play()
					
	#			elif abs(ply.get_global_transform().origin.z-result.position.z) > 2:
	#				emit_signal("playermove")
				elif result.collider.get_parent().get_parent().name == "AmmoBox":
					if globals.ammogun == true:
#						globals.skillgun = false
						globals.ammo += 25
						globals.game_data["coins"] += 5
						var objID = result.collider
						objID.get_parent().queue_free()
						emit_signal("destroy", objID)
				elif result.collider.get_parent().get_parent().name == "MedicBox":
					if globals.ammogun == true:
#						globals.skillgun = false
						globals.health += 25
						globals.game_data["coins"] += 5
						var objID = result.collider
						objID.get_parent().queue_free()
						emit_signal("destroy", objID)
				elif globals.ammogun == false:
#					print("hasbomb: ", result.collider.get_parent().get_child(1).has_node("bomb"))
					if result.collider.get_parent().get_child(1).has_node("bomb"):
						if bombset:
							bombtwo = true
						if result.collider.get_parent().get_child(1).get_child(0).name == "bomb" and !bombset:
							if !bombset:
								result.collider.get_parent().get_child(1).get_child(0).visible = true
								globals.bombexplodedcheck = result.collider
								globals.bombticking.play()
								bombtick.start(5)
								bombexploded = result.collider.get_parent().get_child(1)
								print("hi", result.collider.get_parent().get_child(1).get_child(0).name)
								bombset = true
					else:
						bombtwo = false			
#					print("hello", result.collider.get_parent().name)
					
#						print(result.collider.get_parent().get_child(1).get_child(0).name)
					if !bombtwo:
#						if bombset and result.collider.get_parent().get_child(1).has_node("bomb"):
						colorglow.spirit = true
						globals.ammogun = true
	#					emit_signal("resetgun")
#						globals.spiritlocation.get_child(0).get_surface_material(0).emission_enabled = false
						globals.spiritlocation.get_child(0).get_child(2).emitting = false
	#					globals.spiritlocation.get_child(0).get_surface_material(0).emission = Color(0, 0, 0, 1)
						colorglow.get_child(0).get_child(2).emitting = true
#						colorglow.get_child(0).get_surface_material(0).emission_enabled = true
#						colorglow.get_child(0).get_surface_material(0).emission = Color(.5, .5, .5, .5)
						globals.spiritlocation.spirit = false
#						bombset = true
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
		globals.output = globals.crashed
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		globals.save_game()
	elif globals.ammo == 0:# or globals.health == 0:
		if globals.game_data["finalscore"] > globals.game_data["highscore"]:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		globals.output = globals.noammo
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		globals.save_game()
	elif globals.health <= 0:
		if globals.game_data["finalscore"] > globals.game_data["highscore"]:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		globals.output = globals.nohealth
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		globals.save_game()
	elif globals.spiritdied:
		if globals.game_data["finalscore"] > globals.game_data["highscore"]-1:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		globals.save_game()
	else:
		globals.rowchangetick.volume_db = globals.game_data["effectsvolume"]
		globals.rowchangetick.play()
		var cam = get_tree().get_root().get_node("Main/Camera")
		globals.game_data["finalscore"] += 1
		ply.global_translate(Vector3(0,0,-1))
		cam.global_translate(Vector3(0,0,-1))	




func _on_Button_pressed():
	globals.skillgun = false
	if globals.ammogun == false:
		globals.ammogun = true
	elif globals.ammogun == true:
		globals.ammogun = false


func _on_Button2_pressed():
	globals.skillgun = false
	if didstart.game_started:
		globals.raycast_length = -8
		fired_weapon = true
		globals.gunshot.play()
		#didstart.game_started = false
		#emit_signal('click')
		#print("click")


func _on_BombTick_timeout():
	print("Bomb Exploded")
	bombset = false
	bombtwo = false
	print("Bombtwo: ", bombtwo)
	if bombexploded.get_parent().get_parent().spirit:
		globals.health -= 50
#	if bombexploded.get_child(0).has_node("bomb"):
#		globals.bombticking.stop()
#		globals.bombexplode.play()
#	if result.collider.get_parent().get_child(1).get_child(0).name == "bomb":
	print(bombexploded.name)
#	bombexploded.get_child(0).queue_free()
	globals.bombticking.stop()
	if bombexploded.has_node("bomb"):
		bombexploded.get_child(0).queue_free()
		globals.bombexplode.play()


func _on_SkillGun_pressed():
	if globals.game_data["coins"] <= 9:
		pass
	if globals.game_data["coins"] > 9:
		if globals.ammogun == false:
			pass
		else:
			globals.game_data["coins"] -= 10
			globals.skillgun = true
			globals.raycast_length = -21
			fired_weapon = true
	
