extends Area2D

func _ready():
	pass

#func _process(delta):
#	pass

func _on_DeathZone_body_entered(body):
	if body.name == "Player": #dont work with direct names
		get_tree().reload_current_scene()
