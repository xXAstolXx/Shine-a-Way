extends Area2D

func _ready():
	pass

#func _process(delta):
#	pass



func _on_SlowZone_body_entered(body):
	if body.name == "Player":
		#reduce gravity of player and disable input (left,right,jump,light)
		emit_signal("body_entered")
	pass
