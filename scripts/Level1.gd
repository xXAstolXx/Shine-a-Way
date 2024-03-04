extends Node2D

signal levelChanged
export (String) var levelName = "level"
export var collectiblesNeeded = 1
var delayStart = 0.5
func play_Loaded_Sound():
	pass

func setting_Up():
	#$LevelPowerBoxEnd.monitoring = true
	pass
	
func _enter_tree():
#	if Checkpoint.last_position:
#		$Player.global_position = Checkpoint.last_position
	pass


func extract_drone():
	var drone = $Drone
	remove_child(drone)
	return drone

func extract_player():
	var player = $Player
	remove_child(player)
	print("player: "+str(player))
	return player

func inject_player(player):
	player.position = $Player.position
	remove_child($Player)
	add_child(player)

func inject_drone(drone):
	drone.position = $Player.droneArea.position
	drone.nav = $Navigation2D
	add_child(drone)

func clean_up():
#	if $LevelExitSound.playing:
#		yield($LevelExitSound,"finished")
	queue_free()



func _on_LevelPowerBoxEnd_body_entered(body):
	if Global.toolCount >= collectiblesNeeded:
		Global.toolCount -= collectiblesNeeded
		print("emit_scene switch signal")
		print(body.name)
		$LevelPowerBoxEnd/AnimationPlayer.play("repaired")
		$LevelPowerBoxEnd.monitoring = false 
		emit_signal("levelChanged", levelName)

