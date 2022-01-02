extends Node

onready var globals = $"/root/Globalnode"
#globals.next_scene = load("res://Scenes/main.tscn").instance()

onready var anim = $AnimationPlayer
onready var canvaslayer = $CanvasLayer/Label
# Called when the node enters the scene tree for the first time.
func _ready():
#	canvaslayer = $CanvasLayer/Label
	canvaslayer.visible = true
	pass # Replace with function body.

func handle_scene_changed():
	anim.play("fade_in")
	add_child(globals.next_scene)
	$MainScreen.queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			_on_MainScreen_scene_changed().resume()
		"fade_out":
			pass

func _on_MainScreen_scene_changed():
	anim.play("fade_in")
#	yield()
	anim.stop()
	$MainScreen.queue_free()
	var next_scene = load("res://Scenes/main.tscn").instance()
	yield(get_tree().create_timer(0.25), "timeout")
	add_child(next_scene)
#	yield(get_tree().create_timer(0.25), "timeout")
	$CanvasLayer/Label.visible = false
	anim.play("fade_out")
	yield()
	anim.stop()
	



