extends Node

onready var globals = $"/root/Globalnode"
onready var next_scene1 = preload("res://Scenes/main.tscn").instance()

onready var anim = $AnimationPlayer
onready var canvaslayer = $CanvasLayer/Label
#onready var next_scene = load("res://Scenes/main.tscn").instance()

var BannerSizes = []
var BannerPosition
var next_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	next_scene = next_scene1
	print("Operating System: ", OS.get_name())
#	for banner_size in MobileAds.AdMobSettings.BANNER_SIZE:
#		BannerSizes.add_item(banner_size)
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
#		MobileAds.AdMobSettings.config.banner.position
		var _res = MobileAds.connect("initialization_complete", self, "_on_MobileAds_initialization_complete")

func _on_MainScreen_scene_changed():
	$MainScreen.queue_free()
	add_child(next_scene)
	
func _on_MobileAds_initialization_complete(status : int, _adapter_name : String) -> void:
	if status == MobileAds.AdMobSettings.INITIALIZATION_STATUS.READY:
		MobileAds.load_banner()
