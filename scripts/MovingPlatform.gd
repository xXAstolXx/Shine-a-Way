extends Node2D

onready var movingPathAni = $AnimationPlayer
export (float) var platformActiDelay = 0.1

func _flickering():
	pass

func _on_MovingPlatformActivation_body_entered(body):
	if body.has_method("isPlayer"):
		movingPathAni.play("move")
		$AnimationPlayerForLight.play("moveLight")
