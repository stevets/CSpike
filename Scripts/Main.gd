extends Node


signal swiped(direction)
#signal swipe_canceled(start_position)
signal selfdestruct(plyposz)


onready var cubeinst = preload("res://Scenes/cube.tscn")
onready var ballinst = preload("res://Scenes/ball.tscn")
onready var geminst = preload("res://Scenes/gem.tscn")
onready var coneinst = preload("res://Scenes/pyramid.tscn")
onready var playinst = preload("res://Scenes/Player.tscn")
onready var cubetexinst = preload("res://Scenes/newcube.tscn")
onready var ammobox = preload("res://Scenes/AmmoBox.tscn")
onready var medicbox = preload("res://Scenes/MedicBox.tscn")
onready var bombinst = preload("res://Scenes/bomb.tscn")
onready var laserbeam = preload("res://Scenes/laser.tscn")
onready var timer = $Timer
onready var gametick = $GameTick
onready var globals = $"/root/Globalnode"
onready var eventtype = [InputEventMouseButton, InputEventScreenTouch]


var red = ColorN("red", 1)
var blue = ColorN("blue", 1)
var green = ColorN("green", 1)
var yellow = ColorN("yellow", 1)
var colorarray = [red, blue, green, yellow]
var rng = RandomNumberGenerator.new()
var rng1 = RandomNumberGenerator.new()
var raise_rng = RandomNumberGenerator.new()
export var space = 1
var rows = 20
export var columns = 5
var skillgunactivated = 15
var ply : KinematicBody
var game_started = true
var game_began = false
var raise = 0
var firstraise = 0
var spirit = true
var bomb = false
var time1 = 200
var lastrow = rows
var firstrow = 0
var swipe_start_position = Vector2(0,0)

func _ready():
	globals.game_data["finalscore"] = globals.finalscore
	globals.gameplaymusic.play()
	$HUD.show()
	gametick.start(10)
	game_started = true
	_createGameBoard(firstrow, lastrow)
	#Add Player-----------------------------------------------------------------------------
	ply = playinst.instance()
	var scaleply = 0.25
	ply.scale = Vector3(scaleply,scaleply,scaleply)
	ply.name = "player1"
	add_child(ply)
	ply.global_translate(Vector3(0, 0.8 ,0))
#------Swipe dectection and Click-----------------------------------------------
func _process(_delta):
	$HUD/ScoreBox/VBoxContainer/VBoxContainer/ProgressBar.value = gametick.time_left * 10
	time1 -= 1
	$HUD.update_score()
	$HUD.update_ammo()
	$HUD.update_health()
	$HUD.update_coins()
	if globals.game_data["coins"] < skillgunactivated:
		$HUD/ScoreBox/VBoxContainer/HSplitContainer/Control/SkillGun.visible = false
	else:
		$HUD/ScoreBox/VBoxContainer/HSplitContainer/Control/SkillGun.visible = true
	emit_signal("selfdestruct", ply.translation.z)
	if globals.cubedestroyed == true:
		_on_Main_createrow()
		globals.cubedestroyed = false

func _input(event):
	if not event is eventtype[0]:
		return
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)

func _start_detection(position):
	swipe_start_position = position
	timer.start()
	
func _end_detection(position):
	timer.stop()
	var direction = (position - swipe_start_position)
	var swipedetection = 60
	var hangle = 15
	var _vangle = 75
	if direction.length() >= 60:
		var swipeangle = direction.angle_to(Vector2(1, 0))*180/3.14
#		print(swipeangle)
		if swipeangle <= hangle or swipeangle >= 180 - hangle:
			if direction.x >= swipedetection or direction.x <= -swipedetection:
				globals.swipe.play()
				emit_signal('swiped', Vector2(-sign(direction.x), 0.0))
#		elif swipeangle >= vangle or swipeangle <= 180 - vangle:
#			emit_signal('swipedup')
		else:
			print('swipe again')
#	elif game_started :
#		#$EffectGunPlayer.volume_db = -80
#		emit_signal('click')
#		print("click")
	else:
#		globals.gunshot.volume_db = globals.game_data["effectsvolume"]
#		emit_signal('click')
#		print("beganclick")
		pass

func _on_Timer_timeout():
	emit_signal('swipe_canceled', swipe_start_position)

func _createGameBoard(_firstrow, _lastrow):
	var tokenArray = [ammobox, medicbox, ammobox, medicbox]
	for  i in range(_firstrow, _lastrow):
		for j in range(columns):
			rng.randomize()
			raise_rng.randomize()
			var my_random_number = rng.randi_range(0, 3)
			var s = cubetexinst.instance()
			if s.translation.x != 10:
				s.add_to_group("cubes")
			var duptoken
			var unique_mat0 = s.get_child(0).get_surface_material(0).duplicate()
			s.get_child(0).set_surface_material(0, unique_mat0)
			s.get_child(0).get_surface_material(0).emission = red
			var unique_mat1 = s.get_child(0).get_surface_material(1).duplicate()
			s.get_child(0).set_surface_material(1, unique_mat1)
			s.get_child(0).get_surface_material(1).albedo_color = colorarray[my_random_number]
			if i > 5:
				if i == 6 and j == 0:
					firstraise = 1
					s.get_child(0).get_child(2).emitting = true
					globals.spiritlocation = s
					spirit = false
					s.spirit = true
				rng1.randomize()
				var vis_random = rng1.randi_range(0,4)
				var _my_random_numberp = rng1.randi_range(0, 3)
				var my_random_assetbox = rng1.randi_range(0, 3)
				raise = raise_rng.randi_range(0,1)
				if vis_random == 1:
					if firstraise == 1:
						add_child(s)
						s.global_translate(Vector3((j * space), firstraise  ,-i * space))
						firstraise = 0
					else:
						var bomb_node = bombinst.instance()
						var dupbomb = bomb_node.duplicate()
						s.get_child(0).get_child(1).add_child(dupbomb)
						bomb = true
						add_child(s)
						s.global_translate(Vector3((j * space), 1  ,-i * space))
				elif vis_random == 2:
					if my_random_assetbox == 0:
						var token_node = tokenArray[0].instance()
						duptoken = token_node.duplicate()
					elif my_random_assetbox == 1:
						var token_node = tokenArray[1].instance()
						duptoken = token_node.duplicate()
					elif my_random_assetbox == 2:
						var token_node = tokenArray[1].instance()
						duptoken = token_node.duplicate()
					elif my_random_assetbox == 3:
						var token_node = tokenArray[1].instance()
						duptoken = token_node.duplicate()
					else:
						continue					
					s.get_child(0).get_child(1).add_child(duptoken)
					s.get_child(0).get_child(1).get_child(0).get_child(0).create_trimesh_collision()
					add_child(s)

					if firstraise == 1:
						s.global_translate(Vector3((j * space), firstraise  ,-i * space))
						firstraise = 0
					else:
						s.global_translate(Vector3((j * space), raise  ,-i * space))
				else:
					add_child(s)
					if firstraise == 1:
						s.global_translate(Vector3((j * space), firstraise  ,-i * space))
						firstraise = 0
					else:
						s.global_translate(Vector3((j * space), raise  ,-i * space))
			else:
				add_child(s)
				s.global_translate(Vector3((j * space), 0 ,-i * space))

func _on_Main_createrow():
	firstrow = lastrow
	lastrow = lastrow + 1
	_createGameBoard(firstrow, lastrow)

func _on_PauseButton_pressed():
	var paused = get_tree().paused
	print("paused: ", paused)
	if paused:
		$PausePopup.hide()
		get_tree().paused = false
	else:
		$PausePopup.show()
		get_tree().paused = true

func _on_Player_laser(laserdata):
	print("hitobj: ", laserdata)
	var zpos = laserdata["trans"].z
	var xpos = laserdata["midpoint"] 
	var xlaserlength = laserdata["length"]
	print("xpos: ", xpos)
	var laser = laserbeam.instance()
	laser.name = "laserone"
	laser.duplicate()
	laser.height	= xlaserlength - 1
	laser.get_node("StaticBody/CollisionShape").scale.y = (xlaserlength - 1.0)/2.0
#	laser.shapecalc(xlaserlength - 1)
	add_child(laser)
	laser.global_translate(Vector3(xpos,1,zpos))
