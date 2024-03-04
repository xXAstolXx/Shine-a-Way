extends Node2D

func power_box_activated():
	print("yeeahhhhhhh!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	$AnimationPlayer.play("Level Finished Lighting")

func _on_PowerBox_LevelEnd():
	power_box_activated()
	pass
