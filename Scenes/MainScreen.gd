extends Control

onready var globals = $"/root/Globalnode"
var loadbuttons_delay = 0

func _ready():
	$Menu/HBoxContainer/highscore.text = str(globals.game_data["highscore"])

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
	var _settingscreen = get_tree().change_scene("res://Scenes/SettingScreen.tscn")

func _on_AchievementsButton_pressed():
	globals.menubutton.play()
	var _settingscreen = get_tree().change_scene("res://Scenes/Achievements.tscn")

func _on_NoAdsButton_pressed():
	globals.menubutton.play()
 
