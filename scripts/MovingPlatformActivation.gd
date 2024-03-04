extends Area2D

onready var activationAni = $AnimationPlayer

func _flickering():
	pass

func _on_MovingPlatformActivation_body_entered(body):
	if body.has_method("isPlayer"):
		activationAni.play("activate")
