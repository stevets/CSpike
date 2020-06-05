extends Node

onready var globals = $"/root/Globals"

onready var titlemusic = $TitleMusicPlayer


func _ready():
	titlemusic.volume_db = globals.music_volume
	
	
	


