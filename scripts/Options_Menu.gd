extends Control
onready var masterBus = AudioServer.get_bus_index("Master")
onready var feedbackBus = AudioServer.get_bus_index("Feedback")
onready var ambientBus = AudioServer.get_bus_index("Ambient")
onready var popUpOptions  = $PopUps/Popup_for_Options
onready var popUpControls = $PopUps/Popup_for_Controls
onready var popUpHelp     = $PopUps/Popup_for_Help

onready var _env = preload("res://Game_env.tres")
onready var gammaSlider = $PopUps/Popup_for_Options/Options_Panel/VBoxGammaContainer/GammaSlider

func _enter_tree():
#	randomize()
#	$AudioStreamPlayerOpenMenu.pitch_scale = rand_range(0.25, 1.05)
	$AudioStreamPlayerOpenMenu.play()

func _on_ResumeButton_pressed():
	$AudioStreamPlayerStartSFX.pitch_scale = 1.2
	$AudioStreamPlayerStartSFX.play()
	var Options = get_node("../inGameMenu")
	Options.call_deferred("free")
	get_tree().paused = false

func _process(delta):
	if Input.is_action_just_released("Pause_Menu"):
		$AudioStreamPlayerStartSFX.pitch_scale = 1.2
		$AudioStreamPlayerStartSFX.play()
		var Options = get_node("../inGameMenu")
		Options.call_deferred("free")
		get_tree().paused = false


func _on_OptionButton_pressed():
	$AudioStreamPlayerStartSFX.pitch_scale = 0.9
	$AudioStreamPlayerStartSFX.play()
	popUpOptions.popup()


func _on_ControlsButton_pressed():
	$AudioStreamPlayerStartSFX.pitch_scale = 1.0
	$AudioStreamPlayerStartSFX.play()
	popUpControls.popup()


func _on_Legend_pressed():
	$AudioStreamPlayerStartSFX.pitch_scale = 1.1
	$AudioStreamPlayerStartSFX.play()
	popUpHelp.popup()


func _on_MainMenu_pressed():
	var load_main_Menu = load("res://scenes/Main_Menu.tscn")
	var instance_main_Menu = load_main_Menu.instance()
	get_tree().root.get_node("Game").call_deferred("free")
	get_tree().root.add_child(instance_main_Menu)


func _on_Master_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(masterBus, value)



func _on_Feedback_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(feedbackBus, value)


func _on_Ambient_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(ambientBus, value)


func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = !OS.window_fullscreen


func _on_GammaSlider_value_changed(value):
	_env.tonemap_exposure = gammaSlider.value 
