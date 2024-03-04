extends Area2D

func _ready():
	pass 



func _on_DeathZone_body_entered(body):
	body.death()




