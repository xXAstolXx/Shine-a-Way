extends Control
onready var masterBus = AudioServer.get_bus_index("Master")
onready var feedbackBus = AudioServer.get_bus_index("Feedback")
onready var ambientBus = AudioServer.get_bus_index("Ambient")
onready var popUpExit     =  $PopUps/Popup_for_Exit
onready var popUpControls =  $PopUps/Popup_for_Controls
onready var popUpCredits  =  $PopUps/Popup_for_Credits
onready var popUpOptions  =  $PopUps/Popup_for_Options
onready var popUpHelp     =  $PopUps/Popup_for_Help

onready var _env = preload("res://Game_env.tres")
onready var gammaSlider = $PopUps/Popup_for_Options/Options_Panel/VBoxGammaContainer/GammaSlider

onready var GameScene = preload("res://scenes/Game.tscn")
onready var MainMenuCursor = load("res://assets/ui/Cursor/Menu_corsur_Version3.png")
func _on_Exit_Button_button_up():
	$Exit_Button/AudioStreamPlayer.play()
	popUpExit.popup()

func _ready():
	Input.set_custom_mouse_cursor(MainMenuCursor, 0, Vector2( 16, 16 ))
func _on_Start_Button_pressed():
	get_tree().change_scene_to(GameScene)
	get_tree().root.get_node("MainMenu").queue_free()
	get_tree().paused = false




func _on_Options_Button_pressed():
	$Start_Button/AudioStreamPlayer.pitch_scale = 0.9
	$Start_Button/AudioStreamPlayer.play()
	popUpOptions.popup()


func _on_Master_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(masterBus, value)


func _on_Ambient_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(ambientBus, value)



func _on_Feedback_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(feedbackBus, value)



func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Controls_Button_pressed():
	$Start_Button/AudioStreamPlayer.pitch_scale = 1.0
	$Start_Button/AudioStreamPlayer.play()
	popUpControls.popup()


func _on_Credits_Button_pressed():
	$Start_Button/AudioStreamPlayer.pitch_scale = 0.8
	$Start_Button/AudioStreamPlayer.play()
	popUpCredits.popup()


func _on_ExitYesButton_pressed():
	 get_tree().quit()


func _on_ExitNoButton_pressed():
	$Start_Button/AudioStreamPlayer.pitch_scale = 1.3
	$Start_Button/AudioStreamPlayer.play()
	popUpExit.visible = false


func _on_Help_Button_pressed():
	$Start_Button/AudioStreamPlayer.pitch_scale = 1.1
	$Start_Button/AudioStreamPlayer.play()
	popUpHelp.popup()

#func _on_VideoPlayer_finished():
#	$VideoPlayer.play()

func _on_UI_Menu_ready():
	$VideoPlayer.play()


func _on_GammaSlider_value_changed(value):
	_env.tonemap_exposure = gammaSlider.value
