extends Node

var nextLevel = null
onready var currentLevel = $Level1
onready var aniPlay      = $AnimationPlayer 

func _ready():
	currentLevel.connect("levelChanged",self,"handle_level_changed")
	currentLevel.setting_Up()

func handle_level_changed(currentLevelName: String):
	print("level changed func")
	var nextLevelName: String 
	match currentLevelName:
		"level1":
			nextLevelName = "Level2"
		"level2":
			nextLevelName = "Level3"
		"level3":
			nextLevelName = "level4"
		_:
			return
#	var player = currentLevel.extract_player()
	
	nextLevel = load("res://scenes/"+ nextLevelName +".tscn").instance()
	
	aniPlay.play("fade_in")
	#currentLevel.clean_up()
	nextLevel.connect("levelChanged",self,"handle_level_changed")
	transfer_Data_between_scenes()


func transfer_Data_between_scenes():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			var drone = currentLevel.extract_drone()
			var player = currentLevel.extract_player()
			currentLevel.clean_up()
			currentLevel = nextLevel 
			call_deferred("add_child", currentLevel)
			currentLevel.inject_player(player)
			currentLevel.inject_drone(drone)
			nextLevel = null
			aniPlay.play("fade_out")
		"fade_out":
			pass
#			currentLevel.play_Loaded_Sound()
