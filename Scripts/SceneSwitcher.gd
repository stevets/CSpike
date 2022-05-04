extends Node

onready var globals = $"/root/Globalnode"
#globals.next_scene = load("res://Scenes/main.tscn").instance()

onready var anim = $AnimationPlayer
onready var canvaslayer = $CanvasLayer/Label
onready var next_scene = load("res://Scenes/main.tscn").instance()

var BannerSizes = []
var BannerPosition
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Operating System: ", OS.get_name())
#	for banner_size in MobileAds.AdMobSettings.BANNER_SIZE:
#		BannerSizes.add_item(banner_size)
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
#		MobileAds.AdMobSettings.config.banner.position
		var _res = MobileAds.connect("initialization_complete", self, "_on_MobileAds_initialization_complete")
#	canvaslayer = $CanvasLayer/Label
#	canvaslayer.visible = true
	

#func handle_scene_changed():
#	anim.play("fade_in")
#	add_child(globals.next_scene)
#	$MainScreen.queue_free()

#func _on_AnimationPlayer_animation_finished(anim_name):
#	match anim_name:
#		"fade_in":
#			_on_MainScreen_scene_changed().resume()
#		"fade_out":
#			pass

func _on_MainScreen_scene_changed():
#	anim.play("fade_in")
##	yield()
#	anim.stop()
	$MainScreen.queue_free()
#	onready var next_scene = load("res://Scenes/main.tscn").instance()
#	yield(get_tree().create_timer(0.25), "timeout")
	add_child(next_scene)
#	yield(get_tree().create_timer(0.25), "timeout")
#	$CanvasLayer/Label.visible = false
#	anim.play("fade_out")
#	yield()
#	anim.stop()
	
func _on_MobileAds_initialization_complete(status : int, _adapter_name : String) -> void:
	if status == MobileAds.AdMobSettings.INITIALIZATION_STATUS.READY:
		MobileAds.load_banner()


