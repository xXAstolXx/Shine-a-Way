extends Control

var delay = 0.25
onready var Gamma_Slider = $Gamma_Slider
onready var Gamma_Label  = get_node("Gamma")
var game_env = preload("res://Game_env.tres")

func ready():
	print(Gamma_Slider.value)
func _on_Fullscreen_Button_toggled(button_pressed):
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Return_Button_pressed():
	var video_settings = get_node("../Video_Settings")
	remove_child(video_settings)
	yield(get_tree().create_timer(delay), "timeout")
	video_settings.call_deferred("free")


func _on_HSlider_value_changed(value):
	game_env.tonemap_exposure = Gamma_Slider.value
	Gamma_Label.text = str("Gamma: ", value)
	
