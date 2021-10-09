extends Control

onready var globals = $"/root/Globalnode"
var loadbuttons_delay = 0

func _ready():
	$Menu/HBoxContainer/highscore.text = str(globals.game_data["highscore"])
	setmusicvolumes()
	seteffectvolumes()
#	globals.gameplaymusic.volume_db = globals.game_data["musicvolume"]
#	globals.gunshot.volume_db = globals.game_data["effectsvolume"] - globals.effectsadjust[0]
#	globals.hitsound.volume_db = globals.game_data["effectsvolume"] - globals.effectsadjust[1]
	

func _process(_delta):
	loadbuttons_delay += 1
	if loadbuttons_delay >80:
		$Menu/VBoxContainer/Play.disabled = false
		$Menu/VBoxContainer/Play.modulate = Color(1,1,1,1)
		if loadbuttons_delay>100:
			$Menu/VBoxContainer/SettingsButton.disabled = false
			$Menu/VBoxContainer/SettingsButton.modulate = Color(1,1,1,1)
			if loadbuttons_delay>120:
				$Menu/VBoxContainer/AchievementsButton.disabled = false
				$Menu/VBoxContainer/AchievementsButton.modulate = Color(1,1,1,1)
				if loadbuttons_delay>140:
					$Menu/VBoxContainer/NoAdsButton.disabled = false
					$Menu/VBoxContainer/NoAdsButton.modulate = Color(1,1,1,1)

func set_visibility(isvisible):
	self.visible = isvisible

func _on_Play_pressed():
	globals.menubutton.play()
	var _chscene = get_tree().change_scene("res://Scenes/main.tscn")
	globals.titlemusic.playing = false

func _on_SettingsButton_pressed():
	globals.menubutton.play()
	globals.titlemusic.play()
	var _settingscreen = get_tree().change_scene("res://Scenes/SettingScreen.tscn")

func _on_AchievementsButton_pressed():
	globals.menubutton.play()
	var _settingscreen = get_tree().change_scene("res://Scenes/Achievements.tscn")

func _on_NoAdsButton_pressed():
	globals.menubutton.play()
	
func setmusicvolumes():
	var i = 0
	for player in globals.musicplayerarray:
		player.volume_db =  globals.game_data["musicvolume"] - globals.musicadjust[i]
		i+=1
		
func seteffectvolumes():
	var i = 0
	for player in globals.effectplayerarray:
		player.volume_db =  globals.game_data["effectsvolume"] - globals.effectsadjust[i]
		i+=1
 
