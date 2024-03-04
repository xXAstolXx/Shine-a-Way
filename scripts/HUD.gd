extends Control

onready var IngameMenu = preload("res://scenes/Options_Menu.tscn")

func _process(delta):
	if Input.is_action_just_released("Pause_Menu"):
		$Options/Options_Sound.play()
		get_tree().paused = true 
		var instance_Options = IngameMenu.instance()
		add_child(instance_Options)




