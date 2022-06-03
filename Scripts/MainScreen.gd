extends Control


signal scene_changed


onready var animms = get_parent().get_child(1)

onready var globals = $"/root/Globalnode"
#onready var mainscene = preload("res://Scenes/main.tscn")
var loadbuttons_delay = 0

func _ready():
	$Menu/HBoxContainer/highscore.text = str(globals.game_data["highscore"])
	setmusicvolumes()
	seteffectvolumes()
	if !globals.retrygame:
		globals.gameintro.play()
	

func _process(_delta):	
	if !globals.retrygame:
		loadbuttons_delay += 5
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
						if loadbuttons_delay>160:
							$Menu/VBoxContainer/Tutorial.disabled = false
							$Menu/VBoxContainer/Tutorial.modulate = Color(1,1,1,1)
	else:
		_on_Play_pressed()

func set_visibility(isvisible):
	self.visible = isvisible

func _on_Play_pressed():
	globals.tutorial = false
	globals.menubutton.play()
	globals.retrygame = false
	globals.titlemusic.playing = false
	emit_signal("scene_changed")

func _on_SettingsButton_pressed():
	globals.menubutton.play()
	globals.titlemusic.play()
	var _settingscreen = get_tree().change_scene("res://Scenes/SettingScreen.tscn")

func _on_AchievementsButton_pressed():
	globals.menubutton.play()
	var _settingscreen = get_tree().change_scene("res://Scenes/Achievements.tscn")

func _on_NoAdsButton_pressed():
	globals.menubutton.play()
	var _settingscreen = get_tree().change_scene("res://Scenes/Ads.tscn")
	
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
 
func _exit_tree():
	self.queue_free()



func _on_Tutorial_pressed():
	globals.tutorial = true
	globals.menubutton.play()
	globals.retrygame = false
	globals.titlemusic.playing = false
	emit_signal("scene_changed")
