extends Control


func _ready():
	$Endscene.play()

func _on_Endscene_finished():
	get_tree().change_scene("res://scenes/Main_Menu.tscn")
