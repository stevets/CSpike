extends KinematicBody

signal destroy(objID)
signal laser(laserdata)



var fired_weapon = false

var red = ColorN("red", 1)
var dx = 1
var result
var colorbasecube
var spiritdetected = false
var bombexploded
var bombset = false
var bombtwo = false
var bombnew
var bombtwosound = false
var objID
var color2 = null
var resultfront
var originx
var originy
var originz
var resultleft
var resultright
var ply
var laserdata

onready var globals = $"/root/Globalnode"
onready var didstart = get_tree().get_root().get_node("Main")
onready var space_state = get_world().direct_space_state
#onready var ply = get_tree().get_root().get_node("Main/player1")
onready var bombtick = $BombTick

func _ready():
	pass
	
func _on_Main_swiped(direction):
	originx = ply.get_global_transform().origin.x
	originy = ply.get_global_transform().origin.y
	originz = ply.get_global_transform().origin.z
#	resultfront = space_state.intersect_ray(Vector3(originx+1,originy,originz), Vector3(originx +1,originy,originz + globals.raycast_length), [self])
	resultleft = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx - 1.5,originy,originz), [self])
	resultright = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx + 1.5,originy,originz), [self])
	if direction.x >= 0:
		if originx < 1:
			globals.alarmswipe.play()
		elif !resultleft.has("collider"):
			ply.global_translate(Vector3(-dx,0,0))  #move character to the left
		else:
			globals.alarmswipe.play()
		resultfront = space_state.intersect_ray(Vector3(originx-1,originy,originz), Vector3(originx-1 ,originy,originz + globals.raycast_length), [self])
	else:
		if originx > 3:
			globals.alarmswipe.play()
		elif !resultright.has("collider"):
			ply.global_translate(Vector3(dx, 0, 0)) #move character to the right
		else:
			globals.alarmswipe.play()
		resultfront = space_state.intersect_ray(Vector3(originx+1,originy,originz), Vector3(originx +1,originy,originz + globals.raycast_length), [self])
	
func _process(_delta):
	space_state = get_world().direct_space_state
	var resultgone
	ply = get_tree().get_root().get_node("Main/player1")
	originx = ply.get_global_transform().origin.x
	originy = ply.get_global_transform().origin.y
	originz = ply.get_global_transform().origin.z
	var spiritposz = globals.spiritlocation.get_global_transform().origin.z	
	if globals.ammo <= 0 or spiritposz > originz or globals.health <= 0:
		_on_GameTick_timeout()
	result = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,originy,originz + globals.raycast_length), [self])
	colorbasecube = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,-5,originz), [self])
	if result.has("collider") and result.collider.get_parent().translation.y >= 0 and result.collider.get_parent().get_parent().name != "MedicBox" \
		and result.collider.get_parent().get_parent().name != "AmmoBox" and  not "laser" in result.collider.get_parent().name:
		if resultfront: #!= null: 
			if "material/1" in resultfront.collider.get_parent():
				if typeof(resultfront) == TYPE_DICTIONARY and resultfront.size() != 0 and is_instance_valid(resultfront.collider):
					resultfront.collider.get_parent().get_surface_material(0).emission = Color(0,0,0,1)
		resultfront = result
		resultfront.collider.get_parent().get_surface_material(0).emission = Color(0.8,0,0,1)
		resultfront.collider.get_parent().get_surface_material(0).emission_enabled = true
	else:
		if resultfront:
			if "material/1" in resultfront.collider.get_parent():
				if typeof(resultfront) == TYPE_DICTIONARY and resultfront.size() != 0 and is_instance_valid(resultfront.collider):
					resultfront.collider.get_parent().get_surface_material(0).emission = Color(0,0,0,1)
		resultfront = null
#-------------------------FIRED WEAPON------------------------------------------------------------------------
	if fired_weapon:
#		print("fired weapon process running")
#		globals.ammo -= 1	
		if globals.skillgun and result:
#			var colorbaseblock =  colorbasecube.collider.get_parent().get_surface_material(0).albedo_color
			var resultroot = result.collider.get_parent().get_parent()
			var _tokenboxes = result.collider.get_parent().name
#			-------------Check if spirit is true or false---Skillgun is true------------------------------------
			if resultroot.get_child(0).name == "basecube":
				spiritdetected = result.collider.get_parent().get_parent().spirit
			elif resultroot.get_child(0).name == "Medicbox" or resultroot.get_child(0).name == "Ammobox":
				spiritdetected = result.collider.get_parent().get_parent().get_parent().get_parent().get_parent().spirit
			else:
				print("basecube, Medicbox and Ammobox were not found in resultroot:", resultroot)
#			-------------------------------------------------------------------------------------
			if !spiritdetected: # or tokenboxes == "token":
				objID = result.collider
				emit_signal("destroy", objID)
				resultfront = null
#				globals.hitsound.volume_db = globals.game_data["effectsvolume"]
				globals.hitsound.play()
				if result.collider.get_parent().get_parent().name == "AmmoBox":
					globals.ammo += 25
#					globals.game_data["coins"] += 5
					objID = result.collider
					objID.get_parent().queue_free()
					emit_signal("destroy", objID)
					resultgone = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,originy,originz + globals.raycast_length), [self])
					if resultgone.collider != objID:
						result.collider.get_parent().get_surface_material(0).emission_enabled = false
					resultfront = null
				elif result.collider.get_parent().get_parent().name == "MedicBox":
					globals.health += 25
#					globals.game_data["coins"] += 5
					objID = result.collider
					objID.get_parent().queue_free()
					emit_signal("destroy", objID)
					resultgone = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,originy,originz + globals.raycast_length), [self])
					if resultgone.collider != objID:
						result.collider.get_parent().get_surface_material(0).emission_enabled = false
					resultfront = null
				elif result.collider.get_parent().get_child(1).has_node("bomb"):
					if result.collider.get_parent().get_child(1).get_child(0).name == "bomb":
						if globals.bombexplodedcheck == result.collider:
							globals.bombticking.stop()
						objID = result.collider
						emit_signal("destroy", objID)
						resultgone = space_state.intersect_ray(Vector3(originx,originy,originz), Vector3(originx,originy,originz + globals.raycast_length), [self])
						if resultgone.collider != objID:
							result.collider.get_parent().get_surface_material(0).emission_enabled = false
						resultfront = null
			globals.raycast_length = -8					
		elif result and colorbasecube: #skillgun is false
			checkLeftRight(result)
			if "material/1" in result.collider.get_parent():
				color2 = result.collider.get_parent().get_surface_material(1).albedo_color
			else:
				color2 = null
			var colorbaseblock =  colorbasecube.collider.get_parent().get_surface_material(1).albedo_color
			var resultroot = result.collider.get_parent().get_parent()
			var _tokenboxes = result.collider.get_parent().name
#			-------------Check if spirit is true or false---Skillgun is false------------------------------------
			if resultroot.get_child(0).name == "basecube":
				spiritdetected = result.collider.get_parent().get_parent().spirit
			elif resultroot.get_child(0).name == "Medicbox" or resultroot.get_child(0).name == "Ammobox":
				spiritdetected = result.collider.get_parent().get_parent().get_parent().get_parent().get_parent().spirit
			else:
				spiritdetected = false
				print("basecube, Medicbox and Ammobox were not found in resultroot:", resultroot)	
#			-------------------------------------------------------------------------------------				
			if !spiritdetected: #or tokenboxes == "token":
				if color2 == colorbaseblock and globals.ammogun:
					objID = result.collider
#					globals.skillgun = false
					emit_signal("destroy", objID)
#					globals.hitsound.volume_db = globals.game_data["effectsvolume"]
					globals.ammo -= 1
					globals.gunshot.play()
					globals.hitsound.play()
				elif result.collider.get_parent().get_parent().name == "AmmoBox" and globals.spiritgun == false:
#					globals.skillgun = false
					globals.ammo += 25
#					globals.game_data["coins"] -= 5
					objID = result.collider
					objID.get_parent().queue_free()
					globals.ammo -= 1
					globals.gunshot.play()
					globals.hitsound.play()
#					emit_signal("destroy", objID)
					resultfront = null
				elif result.collider.get_parent().get_parent().name == "MedicBox" and globals.spiritgun == false:
#					globals.skillgun = false
					globals.health += 25
#					globals.game_data["coins"] -= 5
					objID = result.collider
					objID.get_parent().queue_free()
					globals.ammo -= 1
					globals.gunshot.play()
					globals.hitsound.play()
#					emit_signal("destroy", objID)
					resultfront = null
				else:
					if globals.ammogun:
						globals.alarmgun.play()
				if globals.spiritgun and result.collider.get_parent().get_parent().name != "MedicBox" and result.collider.get_parent().get_parent().name != "AmmoBox" \
					and result.collider.get_parent().name != "laserone":
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
						globals.magicspell.play()
						resultroot.spirit = true
#						globals.ammogun = true
	#					emit_signal("resetgun")
#						globals.spiritlocation.get_child(0).get_surface_material(0).emission_enabled = false
						globals.spiritlocation.get_child(0).get_child(2).emitting = false
	#					globals.spiritlocation.get_child(0).get_surface_material(0).emission = Color(0, 0, 0, 1)
						resultroot.get_child(0).get_child(2).emitting = true
#						resultroot.get_child(0).get_surface_material(0).emission_enabled = true
#						resultroot.get_child(0).get_surface_material(0).emission = Color(.5, .5, .5, .5)
						globals.spiritlocation.spirit = false
#						bombset = true
						globals.spiritlocation = resultroot		
			else:
				globals.alarmgun.play()
		else:
			globals.alarmgun.play()
		fired_weapon = false
		globals.ammogun = false
		globals.spiritgun = false
		globals.skillgun = false
		

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

func checkLeftRight(_hitobj):
	print("result", _hitobj)
	var resultv3 = _hitobj["position"]
	var resultv3pos = _hitobj.collider.get_parent().translation.y
	var leftcolor
	var rightcolor
	resultright = space_state.intersect_ray(resultv3, resultv3 + Vector3(3, 0, -0.5), [self])
	resultleft = space_state.intersect_ray(resultv3, resultv3 + Vector3(-3, 0, -0.5), [self])
	print("resultv3: ",resultv3pos)
	if resultleft and resultright:
		if "material/1" in resultleft.collider.get_parent():
			if "material/1" in resultright.collider.get_parent():
				leftcolor = resultleft.collider.get_parent().get_surface_material(1).albedo_color
				var midpoint = (resultleft.collider.get_parent().get_parent().translation.x + resultright.collider.get_parent().get_parent().translation.x)/2
				var lengthlaser = (resultright.collider.get_parent().get_parent().translation.x - resultleft.collider.get_parent().get_parent().translation.x)
				print("leftcolor", leftcolor)
				rightcolor = resultright.collider.get_parent().get_surface_material(1).albedo_color
				print("rightcolor", rightcolor)
				if leftcolor == rightcolor and resultv3pos <= -0.5:
					print("color match")
					laserdata = {"trans" :_hitobj.collider.get_parent().get_parent().translation,  "midpoint": midpoint, "length" : lengthlaser}
					emit_signal("laser", laserdata)
	
	

func _on_GameTick_timeout():
	ply = get_tree().get_root().get_node("Main/player1")
	space_state = get_world().direct_space_state
	var playerposx = ply.get_global_transform().origin.x
	var playerposy = ply.get_global_transform().origin.y
	var playerposz = ply.get_global_transform().origin.z
	var resultfrontcollide = space_state.intersect_ray(Vector3(playerposx,playerposy,playerposz), Vector3(playerposx,playerposy,playerposz -1.5), [self])
	if resultfrontcollide.has("collider"):
		if globals.game_data["finalscore"] > globals.game_data["highscore"]:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		globals.output = globals.crashed
		globals.endgame.play()
		globals.gameplaymusic.playing = false
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		globals.save_game()
	elif globals.ammo == 0:# or globals.health == 0:
		if globals.game_data["finalscore"] > globals.game_data["highscore"]:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		globals.output = globals.noammo
		globals.endgame.play()
		globals.gameplaymusic.playing = false
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		globals.save_game()
	elif globals.health <= 0:
		if globals.game_data["finalscore"] > globals.game_data["highscore"]:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		globals.output = globals.nohealth
		globals.endgame.play()
		globals.gameplaymusic.playing = false
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		globals.save_game()
	elif globals.spiritdied:
		if globals.game_data["finalscore"] > globals.game_data["highscore"]-1:
			globals.game_data["highscore"] = globals.game_data["finalscore"]
		globals.output = globals.spiritdeath
		globals.endgame.play()
		globals.gameplaymusic.playing = false
		var _highscore =	get_tree().change_scene("res://Scenes/HighScoreScreen.tscn")
		globals.save_game()
	else:
#		globals.rowchangetick.volume_db = globals.game_data["effectsvolume"]
		globals.rowchangetick.play()
		var cam = get_tree().get_root().get_node("Main/Camera")
		globals.game_data["finalscore"] += 1
		ply.global_translate(Vector3(0,0,-1))
		cam.global_translate(Vector3(0,0,-1))	




func _on_SpiritGun_pressed():
	globals.skillgun = false
	globals.ammogun = false
	if didstart.game_started:
		fired_weapon = true
		globals.spiritgun = true
#	if globals.ammogun == false:
#		globals.ammogun = true
#	elif globals.ammogun == true:
#		globals.ammogun = false


func _on_AmmoGun_pressed():
	globals.skillgun = false
	globals.spiritgun = false
	if didstart.game_started:
		globals.ammogun = true
		fired_weapon = true
#		globals.gunshot.play()
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
		globals.game_data["coins"] -= 25
		if globals.game_data["coins"] < 0:
			globals.game_data["coins"] = 0
		globals.skillgun = true
		globals.raycast_length = -8
		fired_weapon = true
	

