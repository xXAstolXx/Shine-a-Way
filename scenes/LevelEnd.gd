extends Node2D

export var collectiblesNeeded = 1



func inject_player(player):
	player.position = $Player.position
	remove_child($Player)
	add_child(player)

func inject_drone(drone):
	drone.position = $Player.droneArea.position
	drone.nav = $Navigation2D
	add_child(drone)

func _on_LevelPowerBoxEnd_body_entered(body):
	if Global.toolCount >= collectiblesNeeded:
		Global.toolCount -= collectiblesNeeded
		print("emit_scene switch signal")
		print(body.name)
		$LevelPowerBoxEnd/AnimationPlayer.play("repaired")
		$LevelPowerBoxEnd.monitoring = false 
		get_tree().change_scene("res://scenes/level4.tscn")
